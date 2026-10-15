# Design folders

One folder per build stage, in build order. Folders with a `START_HERE.md` have full print settings and assembly steps; the others are short and explained here.

| Folder | What it is |
|---|---|
| `phase-2` | Fit coupons for the servo bodies, bearings and slider clearance. `FIT_RESULTS.md` has the accepted fits. |
| `mounting-templates` | Flat templates to check the servo mounting-hole spacing before printing anything big. |
| `mechanical-fit-v1` | Servo mount plates and the bearing carrier. |
| `compact-base-stage-1` | The bearing turntable: base, pedestal, rotors, big gear. |
| `compact-base-stage-2` | Base servo mount: four posts and backing plates. |
| `base-horn-fit` | The small motor gear that fits the MG90S horn. |
| `base-servo-test` | First power-on: wiring diagram and the centering sketch. |
| `base-calibration` | Pointer, scale strip and sketch for calibrating the base angle. |
| `shoulder-horn-fit` | The hub that bolts to an MG996R horn. Used at the shoulder and elbow. |
| `shoulder-stage` | Shoulder carrier, bearing housing and the test arm for the load test. |
| `elbow-stage` | Elbow bracket and upper-arm cheeks. |
| `pen-fit` | Bore coupons for the Sharpie: the 12.4 mm ring was the keeper. |
| `wrist-stage` | Lighter forearm, MG90S wrist bracket, gravity pen holder, and `arm_test/` for driving all four joints. |
| `calibration` | How the joint offsets and gains were measured, and the numbers. |
| `drawing` | `draw/draw.ino`: inverse kinematics on the Nano, draws shapes and text, takes strokes from the PC. |
| `camera-stand` | Printed stand that holds the webcam above the input note. |
| `vision` | `copy_drawing.py`: finds the note, traces the ink, and sends it to the arm. |

Kept for reference only, do not build: `rotating-base-v1` (first base design) and `compact-base-review` (design checks for the compact base before it was split into stages).

`CURRENT_BUILD_STATUS.md` is the running build log, newest entry first.
