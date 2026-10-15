"""Scribbot: copy a drawing.

The webcam (or a photo) looks at a sticky note with a doodle on it. This finds the note,
traces the dark lines, and sends them to the arm (draw.ino) to redraw on its own note.

Run:   python copy_drawing.py                 (webcam 0, COM3)
       python copy_drawing.py --camera 1
       python copy_drawing.py --image doodle.jpg
       python copy_drawing.py --image doodle.jpg --no-arm      (just test the tracing)
       python copy_drawing.py --aim                  (live view to aim the camera, q to close)

Then type at the > prompt:
    see       take a picture, find the note and trace it (a preview window opens)
    go        draw the traced lines with the arm
    anything else is sent to the arm as-is: h, d, u, D, U, t, q, c, s, wHI, k3, m, v, o ...
    quit
"""
import argparse
import contextlib
import os
import re
import sys
import time
from pathlib import Path

import cv2
import numpy as np
from skimage.morphology import skeletonize

WARP = 600          # the note is straightened to WARP x WARP pixels
NOTE_MM = 76        # 3 in sticky note
DRAW_MM = 50        # the copy is drawn this big on the arm's note
MARGIN = 0.06       # ignore this fraction around the note edge (shadows, curl)
MIN_PATH_PX = 25    # ignore specks and skeleton spurs shorter than this (about 3 mm on the note)
OUT = Path(__file__).with_name('last_trace.png')


# ---------- finding the note ----------

def order_corners(pts):
    pts = pts.reshape(4, 2).astype(np.float32)
    s, d = pts.sum(1), np.diff(pts, axis=1).ravel()
    return np.array([pts[s.argmin()], pts[d.argmin()], pts[s.argmax()], pts[d.argmax()]], np.float32)


def find_note(img):
    """Corners of the sticky note, or None. Color clusters first, then the older mask search."""
    q = find_note_by_color(img)
    return q if q is not None else find_note_by_masks(img)


def find_note_by_color(img):
    """Split the picture into 3-5 color groups. The note is the patch of one color that fills
    a near-square rectangle. Works when glare or a same-color shadow touches the note."""
    h, w = img.shape[:2]
    s = 480 / w
    small = cv2.GaussianBlur(cv2.resize(img, (480, int(h * s)), interpolation=cv2.INTER_AREA), (5, 5), 0)
    sh, sw = small.shape[:2]
    lab = cv2.cvtColor(small, cv2.COLOR_BGR2LAB).reshape(-1, 3).astype(np.float32)
    best = None
    for k in (3, 4, 5):
        _, lbl, _ = cv2.kmeans(lab, k, None, (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 20, 1.0),
                               3, cv2.KMEANS_PP_CENTERS)
        lbl = lbl.reshape(sh, sw)
        for c in range(k):
            m = cv2.morphologyEx((lbl == c).astype(np.uint8) * 255, cv2.MORPH_OPEN, np.ones((5, 5), np.uint8))
            n, cc, st, _ = cv2.connectedComponentsWithStats(m)
            for i in range(1, n):
                if not (0.03 * sh * sw < st[i, 4] < 0.7 * sh * sw):
                    continue
                cnts, _ = cv2.findContours((cc == i).astype(np.uint8), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                hull = cv2.convexHull(max(cnts, key=cv2.contourArea))
                rect = cv2.minAreaRect(hull)
                rw, rh = rect[1]
                if min(rw, rh) == 0:
                    continue
                fill = cv2.contourArea(hull) / (rw * rh)          # 1.0 = a perfect rectangle
                box = cv2.boxPoints(rect)
                inside = np.all((box >= -2) & (box <= [sw + 2, sh + 2]))
                if fill < 0.9 or max(rw, rh) / min(rw, rh) > 1.4 or not inside:
                    continue
                score = cv2.contourArea(hull) * fill
                if best is None or score > best[0]:
                    best = (score, hull)
    if best is None:
        return None
    hull = best[1]
    for eps in np.linspace(0.01, 0.1, 19):
        q = cv2.approxPolyDP(hull, eps * cv2.arcLength(hull, True), True)
        if len(q) == 4:
            return order_corners(q / s)
    return order_corners(cv2.boxPoints(cv2.minAreaRect(hull)) / s)


def find_note_by_masks(img):
    """Corners of the sticky note, or None.

    Tries several masks (saturation, brightness, edges) and keeps the biggest roughly
    square 4-corner shape that does not touch the picture edge."""
    h, w = img.shape[:2]
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    blur = cv2.GaussianBlur(hsv, (9, 9), 0)
    masks = []
    for ch in (1, 2):                                   # saturation, brightness
        _, m = cv2.threshold(blur[:, :, ch], 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        masks += [m, 255 - m]
    edges = cv2.dilate(cv2.Canny(cv2.GaussianBlur(img, (5, 5), 0), 40, 120), np.ones((5, 5), np.uint8))
    masks.append(edges)

    best, best_area = None, 0
    for m in masks:
        m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((15, 15), np.uint8))
        contours, _ = cv2.findContours(m, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
        for c in contours:
            area = cv2.contourArea(c)
            if not (0.02 * w * h < area < 0.8 * w * h) or area <= best_area:
                continue
            x, y, bw, bh = cv2.boundingRect(c)
            if x <= 2 or y <= 2 or x + bw >= w - 2 or y + bh >= h - 2:
                continue                                # touches the edge: background, not the note
            quad = cv2.approxPolyDP(cv2.convexHull(c), 0.04 * cv2.arcLength(c, True), True)
            if len(quad) != 4 or cv2.contourArea(quad) < 0.85 * cv2.contourArea(cv2.convexHull(c)):
                continue
            q = order_corners(quad)
            sides = [np.linalg.norm(q[i] - q[(i + 1) % 4]) for i in range(4)]
            if max(sides) > 2.0 * min(sides):
                continue                                # not square enough
            best, best_area = q, area
    return best


# ---------- tracing the lines ----------

NEIGHBORS = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]


def trace_paths(skel):
    """Walk the 1-pixel skeleton into polylines."""
    pts = set(zip(*np.nonzero(skel)))
    def nbrs(p):
        return [(p[0] + dy, p[1] + dx) for dy, dx in NEIGHBORS if (p[0] + dy, p[1] + dx) in pts]
    paths = []
    while pts:
        ends = [p for p in pts if len(nbrs(p)) == 1]
        p = ends[0] if ends else next(iter(pts))
        path = [p]
        pts.discard(p)
        while True:
            n = nbrs(p)
            if not n:
                break
            # prefer straight-on neighbors so corners stay sharp
            n.sort(key=lambda q: abs(q[0] - p[0]) + abs(q[1] - p[1]))
            p = n[0]
            path.append(p)
            pts.discard(p)
        if len(path) >= MIN_PATH_PX:
            paths.append(np.array([[x, y] for y, x in path], np.float32))
    return paths


def simplify(paths):
    out = []
    for p in paths:
        s = cv2.approxPolyDP(p.reshape(-1, 1, 2), 1.5, False).reshape(-1, 2)
        if len(s) >= 2:
            out.append(s)
    return out


def order_paths(paths):
    """Nearest-neighbor order, flipping paths when the far end is closer."""
    left, done, pos = list(paths), [], np.array([0, 0], np.float32)
    while left:
        best = min(range(len(left)), key=lambda i: min(np.linalg.norm(left[i][0] - pos), np.linalg.norm(left[i][-1] - pos)))
        p = left.pop(best)
        if np.linalg.norm(p[-1] - pos) < np.linalg.norm(p[0] - pos):
            p = p[::-1]
        done.append(p)
        pos = p[-1]
    return done


def trace(img):
    """Returns (strokes in mm from the note center, x right / y up), preview image."""
    corners = find_note(img)
    preview = img.copy()
    if corners is None:
        print('No whole sticky note in view, so nothing to draw. Re-aim the camera (run with --aim) and type see again.')
        cv2.putText(preview, 'NO NOTE FOUND', (30, 90), cv2.FONT_HERSHEY_SIMPLEX, 3, (0, 0, 255), 8)
        return [], preview
    cv2.polylines(preview, [corners.astype(int)], True, (0, 200, 0), 4)

    dst = np.array([[0, 0], [WARP, 0], [WARP, WARP], [0, WARP]], np.float32)
    note = cv2.warpPerspective(img, cv2.getPerspectiveTransform(corners, dst), (WARP, WARP))
    m = int(WARP * MARGIN)
    gray = cv2.cvtColor(note, cv2.COLOR_BGR2GRAY)
    ink = cv2.adaptiveThreshold(cv2.GaussianBlur(gray, (5, 5), 0), 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                                cv2.THRESH_BINARY_INV, 41, 15)
    ink[:m], ink[-m:], ink[:, :m], ink[:, -m:] = 0, 0, 0, 0
    ink = cv2.morphologyEx(ink, cv2.MORPH_OPEN, np.ones((3, 3), np.uint8))
    paths = order_paths(simplify(trace_paths(skeletonize(ink > 0))))

    # Pixels -> mm on the arm's note. The drawing itself (not the whole note) is scaled to
    # fill DRAW_MM, so a small doodle comes out big and clean.
    if paths:
        allp = np.vstack(paths)
        lo, hi = allp.min(0), allp.max(0)
        k = DRAW_MM / max(hi - lo).clip(1)
        mid = (lo + hi) / 2
    else:
        k, mid = 1, np.zeros(2)
    strokes = [np.column_stack(((p[:, 0] - mid[0]) * k, (mid[1] - p[:, 1]) * k)) for p in paths]

    # Preview: straightened note | traced lines.
    traced = np.full_like(note, 255)
    for p in paths:
        cv2.polylines(traced, [p.astype(int)], False, (0, 0, 0), 2)
        cv2.circle(traced, tuple(p[0].astype(int)), 4, (0, 0, 255), -1)
    small = cv2.resize(preview, (int(preview.shape[1] * WARP / preview.shape[0]), WARP))
    sheet = np.hstack([small, note, traced])
    cv2.putText(sheet, f'{len(strokes)} strokes, {sum(len(s) for s in strokes)} points  (red dot = start)',
                (10, WARP - 15), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255), 2)
    return strokes, sheet


# ---------- talking to the arm ----------

class Arm:
    def __init__(self, port):
        import serial
        self.s = serial.Serial(port, 115200, timeout=0.2)
        time.sleep(2.5)                      # the Nano restarts when the port opens
        self.echo()

    def echo(self, wait=0.3):
        end = time.time() + wait
        while time.time() < end:
            line = self.s.readline().decode(errors='replace').strip()
            if line:
                print('  arm:', line)
                end = time.time() + wait

    def send(self, cmd):
        self.s.write((cmd + '\n').encode())
        self.echo(1.0)

    def step(self, cmd, timeout=30):
        """Send one M/L/E command and wait for ok."""
        self.s.write((cmd + '\n').encode())
        end = time.time() + timeout
        while time.time() < end:
            line = self.s.readline().decode(errors='replace').strip()
            if line == 'ok':
                return True
            if line:
                print('  arm:', line)
                if line == 'err' or 'first' in line or 'off' in line:
                    return False
        print('  arm did not answer')
        return False

    def draw(self, strokes):
        total = len(strokes)
        for i, st in enumerate(strokes, 1):
            print(f'  stroke {i}/{total}')
            if not self.step(f'M{st[0][0]:.1f} {st[0][1]:.1f}'):
                return
            for x, y in st[1:]:
                if not self.step(f'L{x:.1f} {y:.1f}'):
                    return
        self.step('E')
        print('Done.')


def find_camera(name='Brio'):
    """OpenCV (DirectShow) index of the first camera whose name contains `name`, or None."""
    try:
        import imageio_ffmpeg, subprocess
        out = subprocess.run([imageio_ffmpeg.get_ffmpeg_exe(), '-hide_banner', '-list_devices', 'true',
                              '-f', 'dshow', '-i', 'dummy'], capture_output=True, text=True).stderr
    except Exception:
        return None
    names = re.findall(r'"([^"]+)" \(video\)', out)
    for i, n in enumerate(names):
        if name.lower() in n.lower():
            return i
    print('Cameras found:', ', '.join(names) or 'none', f'-- no "{name}". Is the webcam plugged in?')
    return None


@contextlib.contextmanager
def quiet():
    """Hide the log spam some camera drivers (NVIDIA Broadcast) print when a camera opens."""
    sys.stdout.flush()
    saved = [os.dup(1), os.dup(2)]
    null = os.open(os.devnull, os.O_WRONLY)
    os.dup2(null, 1)
    os.dup2(null, 2)
    try:
        yield
    finally:
        os.dup2(saved[0], 1)
        os.dup2(saved[1], 2)
        for fd in saved + [null]:
            os.close(fd)


def open_camera(camera):
    with quiet():
        cap = cv2.VideoCapture(camera, cv2.CAP_DSHOW)
        cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1920)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1080)
    return cap


def aim(camera):
    """Live view. The note gets a green outline when the whole note is in view."""
    cap = open_camera(camera)
    print('Tilt the camera until the note has a GREEN outline with space around it. Press q to close.')
    while True:
        ok, img = cap.read()
        if not ok:
            break
        corners = find_note(img)
        view = img.copy()
        if corners is not None:
            cv2.polylines(view, [corners.astype(int)], True, (0, 220, 0), 8)
            msg, col = 'NOTE FOUND', (0, 220, 0)
        else:
            msg, col = 'no whole note in view', (0, 0, 255)
        cv2.putText(view, msg, (30, 80), cv2.FONT_HERSHEY_SIMPLEX, 2.5, col, 6)
        cv2.imshow('Scribbot aim (q to close)', cv2.resize(view, None, fx=0.5, fy=0.5))
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()


def grab(camera, image):
    if image:
        img = cv2.imread(image)
        if img is None:
            sys.exit(f'Could not read {image}')
        return img
    cap = open_camera(camera)
    with quiet():
        for _ in range(30):                  # let the exposure settle
            ok, img = cap.read()
        cap.release()
    if not ok:
        sys.exit(f'Camera {camera} gave no picture. Is the webcam plugged in?')
    return img


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', default='COM3')
    ap.add_argument('--camera', type=int, help='camera number (default: find the Brio by name)')
    ap.add_argument('--image', help='use a photo instead of the webcam')
    ap.add_argument('--no-arm', action='store_true', help='only trace, do not connect to the arm')
    ap.add_argument('--aim', action='store_true', help='live view to aim the camera')
    a = ap.parse_args()
    if a.camera is None and not a.image:
        a.camera = find_camera()
        if a.camera is None:
            sys.exit('Plug the webcam in and run this again.')
        print(f'Using camera {a.camera} (Brio).')
    if a.aim:
        aim(a.camera)
        return

    arm = None if a.no_arm else Arm(a.port)
    strokes = None
    print('Type: see, go, quit, or an arm command (h, d, t, ...). Start with h, d until the pen touches, t.')
    while True:
        cmd = input('> ').strip()
        if cmd in ('quit', 'exit', 'q!'):
            break
        if cmd == 'see':
            strokes, sheet = trace(grab(a.camera, a.image))
            cv2.imwrite(str(OUT), sheet)
            print(f'{len(strokes)} strokes traced. Preview saved to {OUT.name}. Close the window, then type go.')
            cv2.imshow('Scribbot sees', cv2.resize(sheet, None, fx=0.6, fy=0.6))
            cv2.waitKey(0)
            cv2.destroyAllWindows()
        elif cmd == 'go':
            if not strokes:
                print('Nothing traced yet: type see first.')
            elif arm is None:
                print('Started with --no-arm.')
            else:
                arm.draw(strokes)
        elif cmd and arm:
            arm.send(cmd)
    if arm:
        arm.s.close()


if __name__ == '__main__':
    main()
