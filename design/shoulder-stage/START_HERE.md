# Stage 5: shoulder mount + load test

Build the MG996R shoulder on the turntable with a 120 mm **test arm**, then check that the servo can hold the weight of a full arm without sagging or overheating. This is the shoulder load test from the original spec. Nothing in the real arm gets printed until this passes.

- `everything_so_far.png`: the whole robot so far, assembled and labeled
- `construction_diagram.png`: exploded view, every part numbered in build order (use this one)
- `servo_orientation.png`: which way round the MG996R goes (its shaft is off-center)
- `screw_map.png`: every screw, lettered A-G, with what it passes through and how many
- `assembly_preview.png`: what it looks like built
- `assembly_stack_diagram.png`: schematic top view of the stack

## Print

All PLA, your 0.12 mm profile, 100% scale, flat as exported, no supports.

| File | Qty | Settings |
|---|---:|---|
| 02_shoulder_carrier.stl | 1 | 5 walls, 40% infill. Prints standing up (base plate on the bed). |
| 03_bearing_housing.stl | 1 | 4 walls, 40% |
| 04_bearing_cap.stl | 1 | 4 walls |
| 05_lever_cheek_A_hub_side.stl | 1 | 4 walls, 40% |
| 06_lever_cheek_B_bearing_side.stl | 1 | 4 walls, 40% |
| 07_lever_rung_PRINT_3.stl | **3** | 4 walls, 40% |
| 08_axle_spacers.stl | 1 | 100% infill (6 small rings) |

You already have `01_shoulder_hub` from the horn fit check.

## Hardware

| Item | Qty | Used for |
|---|---:|---|
| M3 × 16 screw + nut + washer | 4 | carrier to platform (same holes as the pointer) |
| M3 × 16 screw + nut + washer | 4 | servo tabs to carrier |
| M3 × 20 screw + washer | 4 | cap + housing into the carrier's back wall (screws thread into the plastic, no nuts) |
| M3 × 12 screw + nut | 4 | cheek A to hub (nuts press into the hub's hex pockets) |
| M3 × 16 screw + nut | 6 | rungs to cheeks (nuts drop into the rung slots) |
| **M5 × 30 bolt** + M5 nut + M5 washer | 1 | shoulder stub axle on the bearing side |
| 625 bearing | 1 | from your spares |
| Horn screws (came with the MG996R) | 2 | horn to hub |

**M5 × 30:** if you only have the long M5 × 80, it works for this test; the extra length just sticks out sideways.

For the load test you also need an empty water bottle, string or a zip tie, a measuring cup (1 mL of water = 1 g), and something to act as a catch under the arm (a box or a stack of books).

## Before you start

- **Secure the base to the table** with clamps or lots of strong tape. The test arm plus weight can tip the robot over.
- Remove the calibration pointer from the platform.
- Plug the MG996R into **channel 1** on the driver board (the next column over from the base servo), brown wire to the board edge.

## Build order (the order matters)

1. **Carrier onto the platform.** Use the same 4 holes and screws as the pointer. Either direction works; the easy way is screws up from below with the nuts on top, like you did for the pointer. See `carrier_on_your_photo.png`. Do this before anything else; the servo covers two of the screws.
   **Then aim it at the sticky note.** The carrier sits a quarter turn from where the calibration pointer sat, so the arm would point sideways. With the power off, loosen the 4 motor-plate nuts and slide the plate back until the gears separate. Don't turn the small gear. Turn the platform by hand until the carrier's short end (where the arm will stick out) faces the sticky note. Slide the plate back in to re-mesh and tighten the nuts. See `everything_so_far.png`.
2. **Bearing side.** Press the bearing into the housing pocket. Put one 1 mm spacer on the M5 bolt, then push the bolt through the bearing from the housing's flat side (the side without the pocket), so the head ends up on the flat side. Put the cap over the pocket. Hold the housing against the back wall's outer face (the bolt head goes into the big hole, threads pointing out), and thread in the 4 × M3 × 20 with washers. **Leave them slightly loose** so the housing can still slide a little.
3. **Center the servo.** Upload `shoulder_test/shoulder_test.ino`, plug in the adapter, and type `c`. The MG996R goes to its center. Then type `o` and unplug the adapter.
4. **Servo into the carrier.** The shaft is near one end of the servo body, not in the middle; see `servo_orientation.png`. Slide the body through the window from the hub side (the side away from the back wall), shaft pointing away from the back wall. Turn it so the **shaft end faces the SHORT end of the base plate** and the shaft lines up with the big round hole in the back wall. Check from the hub side, looking square on: the shaft (or the hub's center screw) should sit directly above the round hole in the middle of the base plate, not off to one side. The cable comes out at the shaft end on this servo. Bolt the tabs with 4 × M3 × 16, nuts on the inside.
5. **Hub onto the servo.** Press 4 M3 nuts into the hub's hex pockets first. Screw the horn to the hub (2 horn screws through opposite slots). Press the horn onto the shaft so the hub's small top dot points **up and forward**, about 45°. The arm should point about 45° up when the servo is centered. Put the center screw in through the hub.
6. **Build the test arm.** Drop an M3 nut into each rung-end slot. Screw all 3 rungs to cheek A (M3 × 16).
7. **Arm onto the hub.** Hold cheek A against the hub and screw it on with 4 × M3 × 12 into the hub nuts. The arm should point forward and up.
8. **Cheek B.** Slide spacers onto the M5 bolt until they fill the gap between the bearing and cheek B (start with the 8 mm + 1 mm). Fit cheek B over the bolt and screw it to the 3 rungs. Add the M5 washer and nut outside and tighten.
9. **Line up the bearing.** Swing the arm to horizontal by hand (gently). Now tighten the 4 housing screws. Cheek B is narrow so you can reach them. The housing shifts itself into line with the servo shaft as you tighten.

**Check:** power on, `c`, then `1300` and `1700`. The arm swings smoothly with no binding or creaking. If it binds, loosen the housing screws, run `c` again, and re-tighten.

## Load test

**Setup.** Put the catch (a box) under the arm tip, about 1 cm below horizontal, so the arm lands on it if power drops. Stand a tape measure upright next to the end rung to watch for sag.

1. Power on, type `c`. Use `+` / `-` to make the arm **exactly horizontal** (a phone level app on the arm helps). Write down that pulse.
2. Tie the empty bottle to the hole in the **end rung** with string or a zip tie.
3. For each step: add water, return to the horizontal pulse, type `t` to start the timer, and watch the arm tip on the tape measure.

| Step | Bottle + water | Hold |
|---|---:|---|
| 25% | 55 g | 30 s |
| 50% | 150 g | 30 s |
| 75% | 250 g | 30 s |
| 100% | 345 g | 2 min, then 10 min if everything is fine |

(A typical empty bottle weighs about 10 g, so 345 g is about 335 mL of water.)

**Stop immediately** (lower the arm onto the catch with `-`/`+`, then `o`) if:
- the servo gets **hot**. Warm is okay; too hot to keep a finger on means stop. An infrared thermometer is better if you have one: stop at 45 °C.
- it **buzzes loudly**, jitters, or the arm creeps down.
- the arm tip sags more than **about 2 mm** from where it started (about 1°).
- the voltage at the green terminal drops below **4.8 V** (measure it during the 100% hold).

**Pass:** 100% held for 10 minutes: no stop condition, sag under about 2 mm, servo no more than warm.

## Report back

- The horizontal pulse
- For each step: did it hold? Any sag (tape reading start and end)?
- How warm the servo got at 100% after 2 min and after 10 min
- Voltage at the terminal during the 100% hold
