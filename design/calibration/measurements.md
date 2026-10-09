# Calibration measurements

Heights above the table, in inches (read from photos, about +/- 1/4 in).

## Pose A: s1100, e1500, w1450 (pen vertical)

| Point | in | mm |
|---|---|---|
| S shoulder nut | 5 | 127 |
| E elbow nut | 7 1/4 | 184 |
| W wrist screw | 4 5/8 | 117 |
| T pen tip | 2 | 51 |

Derived (L = 120 mm):

- Shoulder axis height: 127 mm (design 115)
- Upper arm: asin((184 - 127) / 120) = +28.5 deg at s1100 (design about +38)
- Forearm absolute: asin((117 - 184) / 120) = -33.8 deg, so the elbow is -62.3 deg at e1500 (design -90)
- Wrist at w1450: -90 - 28.5 + 62.3 = -56.2 deg (pen vertical)
- Wrist axis to pen tip, vertical: 67 mm (design 80)

## Pose B: s900, e1500, pen vertical at w1680

| Point | in | mm |
|---|---|---|
| S shoulder nut | 5 (same as A) | 127 |
| E elbow nut | 8 1/4 | 210 |
| W wrist screw | 7 5/16 | 186 |
| T pen tip | 4 5/8 (photos disagree, 4 1/2 to 5 1/4) | 117 |

Derived:

- Upper arm: asin((210 - 127) / 120) = +43.5 deg at s900
- Shoulder: 1100 -> 900 gave 15 deg, so about 13.9 us/deg. Level (0 deg) at about 1495 us, matching "1500 = level".
- Forearm absolute: -11.3 deg, so the elbow is -54.8 deg at e1500. Pose A gave -62.3, so use the average of about -58.5 (photo error about 3 deg).
- Wrist (pen vertical): -78.7 deg at w1680 vs -56.2 deg at w1450, so about 10.2 us/deg, and higher us = more negative.

## Pose C: s1100, e1300, pen vertical at w1680

No photos needed: the wrist acts as a level. w1680 means the wrist is at -78.7 deg, so the forearm is at -11.3 deg. With the shoulder at +28.5, the elbow is -39.8 deg at e1300.
Elbow: -58.5 at 1500 and -39.8 at 1300, so about 10.7 us/deg. Lower us = forearm up.

## Result (angles in degrees; positive = up; elbow and wrist relative to the previous link)

    shoulder_us = 1495 - 13.9 * shoulder
    elbow_us    = 1500 - 10.7 * (elbow + 58.5)
    wrist_us    = 1450 - 10.2 * (wrist + 56.2)
    shoulder axis 127 mm above the table, pen tip 67 mm below the wrist axis, offset 25 mm forward (design, not measured)

Drawing patch at z = 0:

| r mm | s us | e us | w us |
|---|---|---|---|
| 135 | 1079 | 2127 | 906 |
| 150 | 1091 | 2045 | 975 |
| 165 | 1114 | 1957 | 1042 |
| 180 | 1147 | 1862 | 1108 |
| 197 | 1198 | 1743 | 1184 |

The near half needs elbow > 1900 and wrist < 950, so the arm_test limits were widened to elbow 2200 and wrist 880, pending a clearance check.
