# Vision Draw Arm — phase 2 preliminary design

Status: engineering proposal and printable fit tests; not a validated arm assembly.

## Accepted configuration

Use two positional 180-degree MG996R servos (shoulder and elbow), and four owned MG90S servos (base yaw, wrist pitch, optional removable tool roll, gripper). The roll axis is along the pen axis when drawing. It rotates the gripper and cartridge for dock alignment, and remains fixed during drawing. It must not be implemented as a sideways wrist yaw axis: that would change the constrained inverse kinematics. Leave enough wire loop for limited roll, never continuous rotation.

Links are 120 mm center-to-center. Shoulder height is nominally 100 mm above the board. Target wrist-to-tip distance is 95 mm with the roll module; it must be measured on the assembled tool and entered into calibration. Base plate remains 150 mm square. Maximum straight-link reach is 240 mm, not the recommended drawing radius.

Use a single approximately 76.2 mm square sticky note, not a stack. Initial drawing region is 60 mm square. Measure the actual note before changing holder parameters. Place its center nominally at robot (165,0) mm, edges parallel to robot X/Y, giving drawing bounds X=135..195, Y=-30..30 mm. Maximum radial drawing distance is approximately 197.3 mm. Put the adhesive edge against a registration edge. The holder bed is 2 mm thick; calibrate paper Z on its actual surface. Recess all mounting screws or keep them outside the motion envelope.

Provisional dock location is (130,-90) mm, radius 158.1 mm. This is a layout target only: full pen length, upper barrel sweep, jaw opening and all approach heights must pass collision checks before fixing the dock. Provide slotted dock mounting in later CAD.

## Wrist module load budget

Original endpoint gripper/cartridge/pen budget: 60 g. Add 13.4 g roll servo and 15 g combined roll bracket, bearing/bush and coupling allowance: 28.4 g increase. Tool endpoint budget becomes 88.4 g. Keep total wrist-to-tip length at or below 95 mm if feasible. Weigh the completed tool; an overweight tool triggers recalculation.

Horizontal gravity estimate, mass in kg and radius in cm:

Shoulder = 0.045*6 + 0.075*12 + 0.040*18 + 0.025*24 + 0.0884*24 = 4.6116 kgf cm.

Elbow = 0.040*6 + 0.025*12 + 0.0884*12 = 1.6008 kgf cm.

At 2x allowance these become 9.2232 and 3.2016 kgf cm. The shoulder is almost at the published 9.4 kgf cm stall figure at 4.8 V. This is insufficient evidence of a thermally reliable shoulder. Previous confidence in the five-servo configuration does not carry over unchanged to the roll-equipped version.

Retain the roll module as requested, but require a shoulder load test before full-arm printing. The standard bracket should allow a later servo replacement. If the test fails, first remove roll and retest; then choose between a measured counterbalance solution and a stronger shoulder servo with verified dimensions and ratings. Do not assume a generic “20 kg” label solves backlash or thermal duty. Do not increase the supply voltage without verifying every attached servo.

The calculation assumes the distal assembly is centered below the wrist when drawing. During handling its horizontal center-of-mass offset can increase shoulder torque by up to approximately 0.0884*9.5=0.84 kgf cm in an unfavorable orientation. Such poses are excluded from the initial loaded motion plan. Pen drag and acceleration add load; the 2x number is an engineering allowance, not a continuous torque rating.

## Mechanical interfaces to implement after measurement

- Base, shoulder and elbow use six total 625-2RS bearings (5x16x5 mm). Smooth metal journals carry bearing inner races; clamped printed carriers carry outer races. Hardware geometry must be resolved in assembly before ordering final pivot bolt lengths.
- Use supplied servo horns, never printed splines. The horn transmits torque; separately supported pivots carry structural loads. Provide accessible center screws and removable couplings.
- Link ends use removable end fittings and M3 captive-nut interfaces. Nominal tool-module interface: four M3 clearance holes on a 24 mm square, centered on the tool axis. This is a reserved envelope, not a released fabrication drawing.
- Tool roll uses a coaxial removable cartridge and limited angular travel. Keep the complete pen, including barrel above the grip, inside collision models. A servo/body interference check is required before releasing wrist CAD.
- The compliant pen cartridge has 6 mm stroke, keyed slider, positive retaining flange and adjustable spring seat. Spring force target is approximately 0.1–0.4 N, plus moving weight and friction. Calibrate force with a scale before drawing.
- Use a gripper with synchronized opposing racks. Grip the cartridge neck below its flange. The dock supports the cartridge without loading the pen tip and leaves both jaws clear.

## Exact measurements needed

Measure one representative MG90S, then check the others for differences. Repeat for the actual purchased shoulder/elbow servos. Record in MEASUREMENTS.csv, in millimeters. A digital caliper is helpful.

1. Body length and width below the mounting ears, excluding wires.
2. Body depth below mounting ears and total height to top of output shaft.
3. Overall mounting-ear span and ear thickness.
4. Mounting-hole center spacing in both directions and hole diameter.
5. Output-axis location from two perpendicular body faces.
6. Supplied horn diameter/length, thickness, fastening-hole pattern and installed offset from the body.
7. Center screw specification from supplied hardware; do not guess thread size.
8. Wire exit location and bend-clearance envelope.
9. Actual positional travel after gentle bench calibration; do not command hard stops.
10. Pen diameter, total length, grip-to-tip distance, mass; sticky-note width/thickness; webcam dimensions/mass; resin name/type and its recommended post-cure process.

No exact servo ear spacing or spline geometry has been assumed in the fit coupons. They test BODY clearance only. Do not force a servo through a coupon or use the coupon as a structural bracket.

## First prints and how to judge them

Print MG90S coupon, bearing coupon and slide coupon first in the FDM material intended for final parts. Use 0.2 mm layers and the same wall settings as the later bracket. Each separate coupon island is intentionally disconnected in the STL. Raised labels identify opening allowances. Print flat, without support, and remove elephant-foot edges before evaluating.

MG90S and MG996R coupons provide total added body width/length of 0.4, 0.6 and 0.8 mm (half that clearance per side). Select the smallest opening that accepts the body without force. The MG996R coupon should wait until the actual servos arrive. A body's rounded corners and taper may require additional changes.

Bearing coupons have through-bores of 16.0/16.1/16.2/16.3 mm. Select a sliding/snug hand fit; retention will come from caps, not heavy interference. Slide channels provide 0.2/0.3/0.4 mm lateral clearance per side. Select a channel that moves freely after cleaning, then test again under representative side load. This open channel only measures lateral fit; it is not a finished anti-rotation linear guide.

The note holder is an initial flat backing and registration fixture, sized for a single nominal 76.2 mm note. Its two low edges locate the note, leaving opposite edges accessible. It has four 4.5 mm mounting holes outside the paper. Verify the note stays flat; adhesive variability may require a small removable edge tape outside the drawing patch. This first holder is parameter-adjustable by reprinting, not mechanically adjustable. A later slotted guide version can accommodate multiple sizes without reprinting.

Resin is optional for dimension coupons, gripper pinion/racks, cartridge inserts and fixtures. Use a suitable tough/engineering resin after checking its datasheet; ordinary brittle resin is not the default for structural links, flexures or screw-loaded servo brackets. Evaluate fit after full prescribed post-cure. Resin shrinkage means FDM-selected clearances do not transfer automatically. Use the printer/material manufacturer's handling and processing instructions.

## Bench gates before completing the arm

These are proposed project acceptance criteria, not manufacturer limits or measured performance.

### Shoulder load test

1. Mount the servo and supplied horn on a rigid temporary fixture. Support the test lever so radial load is not carried solely by the servo spline. Provide a catch under the lever and accessible power disconnect.
2. Confirm unloaded movement around the intended working pose, calibrated pulse range and stable supply voltage.
3. For the roll-equipped gravity budget, an approximately 235 g load at 200 mm gives 4.7 kgf cm. Subtract the lever's own moment from the added load. Begin at 25% load, then 50%, 75%, 100%, supporting it while changing weights.
4. At each step hold for 30 seconds, checking for sag, buzzing and supply collapse. At full load extend to 2 minutes, then 10 minutes only if stable. Do not deliberately stall the servo.
5. Conservative project stop: case surface reaches 45 C, rises more than 20 C above ambient, motion becomes unstable, or supply falls below the servo's verified minimum. Use a thermometer; touch is not a measurement.
6. Pass: no stop condition, less than 1 degree additional sag from the settled starting position, and no continued rapid temperature rise at ten minutes. Passing supports a prototype only; repeat with actual duty cycle and complete arm later.

### Base repeatability

1. With links supported and pen lifted, attach a lightweight 200 mm pointer or use the final pen over a reference grid.
2. Command the same central target 20 times from clockwise approach and 20 times from counterclockwise approach at low speed.
3. Measure endpoint position after settling each time. Pass for initial 60 mm symbols: total spread no more than 2 mm and mean approach-direction separation no more than 2 mm. If failed, inspect horn fastening, bearing fit and cable torque; do not claim software interpolation removes backlash.

### Dock pickup

1. First perform ten open-gripper approaches above the dock, then lower incrementally after checking clearances.
2. Grip the cartridge, lift 20 mm, hold five seconds, replace, open and withdraw. Run slowly with an accessible disconnect.
3. Pass: 20 consecutive complete cycles without dropping, binding, scraping the tip, or shifting the cartridge grip height by more than 0.5 mm. Failure requires dock/gripper changes before adding automatic vision.

### Compliance and drawing

1. With the tool held vertical, measure force against a scale at several displacements through the usable stroke. Confirm return without sticking and no coil bind.
2. Start with approximately 2 mm compression and at least 3 mm remaining stroke. Verify paper force is suitable for the chosen pen.
3. Draw repeated 40 mm squares and circles inside the 60 mm region using known coordinates. Record closure error, repeatability and paper damage before enabling vision.

## Software consequences and next stage

Set paper size to measured dimensions, independent of draw-region size. Use a 60 mm drawing square centered on the note. Four ArUco markers go on the surrounding rigid board, not inside the small note. Marker-to-note position is fixed by the holder only after calibration.

Constrained IK remains base yaw plus planar shoulder/elbow plus compensating wrist pitch. Tool roll is an independent fixed angle during drawing, provided the roll axis and pen axis are coaxial. Recalibrate tool length for each installed module. Use measured joint travel and collision validation, not assumed 0–180 degree mechanical travel.

Next release: measured servo envelopes, complete supported joint geometry and horn adapters, base/shoulder/link CAD, assembly-specific hardware schedule and collision-checked motion envelope. Do not order all final screw lengths or print the full arm from this preliminary package. STEP and complete assembly files are not included in this fit-test release.

## Reference specifications

- https://towerpro.com.tw/product/mg996r/ — nominal MG996R body, mass and stall torque. Manufacturer distinguishes positional travel variants.
- https://towerpro.com.tw/product/mg90s-3/ — nominal MG90S body and mass. Verify the actual owned units and supply rating.
- https://learn.adafruit.com/16-channel-pwm-servo-driver/hooking-it-up — separate logic and servo power wiring.

These sources were inspected during phase 1. Their figures are reference inputs, not measurements of the user's hardware.
