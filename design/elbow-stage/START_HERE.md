# Stage 6: elbow joint

The elbow is a copy of the shoulder joint, carried on a short new upper arm. Your 120 mm test arm is not wasted: it moves out to the elbow and becomes the forearm.

Pictures in this folder:

- `after_this_stage.png`: what the robot looks like when this stage is done
- `construction_diagram.png`: exploded view, numbered in build order
- `screw_map.png`: every screw, lettered, with what it passes through

## Print

All PLA, your 0.12 mm profile, 100% scale, flat as exported, no supports.

| File | Qty | Settings |
|---|---:|---|
| 09_elbow_bracket.stl | 1 | 3 walls, 20% infill. Prints standing up, 85 mm tall, thick end plate on the bed. |
| 10_upper_cheek_A_hub_side.stl | 1 | 4 walls, 40% |
| 11_upper_cheek_B_bearing_side.stl | 1 | 4 walls, 40% |
| 01_hub_PRINT_1_MORE.stl | 1 | 4 walls, 40% |
| 03_bearing_housing_PRINT_1_MORE.stl | 1 | 4 walls, 40% |
| 04_bearing_cap_PRINT_1_MORE.stl | 1 | 4 walls |
| 08_axle_spacers_PRINT_1_MORE.stl | 1 | 100% infill |

## Hardware (new for this stage)

- The second MG996R, its double-arm horn, 2 horn screws and its center screw
- 1 × 625 bearing
- 1 × M5 bolt, washer and nut, the same kind you used at the shoulder
- M3 × 16: 8, M3 × 20: 4, M3 × 12: 4, M3 nuts: 12, M3 washers: 8

## Wiring and program

- Elbow servo plugs into **channel 2** on the driver board (next to the shoulder on channel 1), brown wire toward the board edge.
- Upload `arm_test/arm_test.ino`. It drives all three joints. Every command starts with the joint letter: `b` base, `s` shoulder, `e` elbow. Examples: `e1500`, `s+`, `eo` (elbow off), `o` (everything off).

## Build order (numbers match construction_diagram.png)

**Take the test arm off the shoulder first**
1. Type `o` and unplug the adapter. Support the arm.
2. Undo the M5 nut and washer on the bearing side. Take out the 3 rung screws on cheek B and pull cheek B off. Leave the spacers on the bolt.
3. Undo the 4 screws holding cheek A to the shoulder hub. The test arm (cheek A with its 3 rungs) comes off as one piece. Leave the hub on the servo.

**Upper arm onto the shoulder**
4. Upper cheek A onto the shoulder hub with the same 4 screws, pointing **straight forward**, where the test arm pointed.
5. Drop 4 M3 nuts into the slots at the two ends of the bracket's thick end plate. Hold the bracket between the cheeks with its two walls pointing away from the shoulder. The **thin wall with the window goes on the hub side**. Two M3 × 16 through cheek A into the bracket.
6. Upper cheek B over the shoulder bolt, two M3 × 16 into the bracket, then the M5 washer and nut back on.

**Elbow joint (same as the shoulder)**
7. M5 bolt through the bearing and new housing, cap on, 4 × M3 × 20 into the bracket's back wall. Bolt head inside the big hole. Leave the screws slightly loose.
8. Plug the second servo into channel 2. Power on, type `e1500`, then `eo`, and unplug. The servo is now centered.
9. Slide the servo into the bracket's window from the hub side. Its shaft must line up with the big hole in the back wall, so the **shaft end points away from the shoulder**. Bolt the tabs with 4 × M3 × 16, washers and nuts.
10. Press 4 M3 nuts into the new hub's hex pockets. Screw the horn to the hub with 2 horn screws. Press it onto the shaft and put the center screw in.
11. Test arm onto the new hub with 4 × M3 × 12, pointing **straight down** when the upper arm is level (a right angle to the upper arm, as close as the horn's teeth allow). Raise the upper arm by hand first so the forearm has room.
12. Spacers on the elbow bolt, cheek B over the bolt, its 3 rung screws back in, then the M5 washer and nut.
13. Swing the forearm gently by hand to line up the bearing, then tighten the 4 housing screws.

## First power-on

Keep the base clamped. Hold the forearm lightly in your hand.

1. Type `s1500`. The upper arm goes level.
2. Raise the upper arm: on the shoulder, **lower numbers go up**. Type `s1400`, `s1300`, `s1200`, `s1100`, `s1000`, pausing at each, until it is about halfway to vertical. This gives the forearm room. The program stops the shoulder at 1550, just below level.
3. Type `e1500`. The forearm should hang at a right angle to the upper arm.
4. Type `e1400`, then `e1600`, then `e1500`. It should swing smoothly both ways.

**Stop** (type `o` with the arm supported) if anything binds, buzzes loudly or heads for the table.

## Report back

- Which elbow number swings the forearm **forward and up** (away from the base): `e1400` or `e1600`?
- Does it all move smoothly? A photo of the arm helps.

## Known limits

- The test arm is heavier than the final forearm will be. It is fine for this stage; a lighter forearm comes with the wrist.
- With the upper arm level and the elbow at a right angle, the forearm reaches the table. Raise the shoulder before bending the elbow down.
- Collision checks in CAD: forearm against upper arm clear from 20° past straight to folded 140°; arm against the shoulder mount clear from level to 120° up. The base, table and cables are not in that check.
