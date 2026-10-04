# Stage 7: wrist and pen holder

A small MG90S at the end of a new forearm tilts a pen holder, so the pen can stay straight up and down whatever the arm is doing. The Sharpie slides freely in the holder: when the robot lowers it onto the paper, the pen rides up a few millimeters and presses on the paper with just its own weight. A collar stops it falling out.

Pictures in this folder:

- `after_this_stage.png`: the whole robot with the pen on the sticky note
- `construction_diagram.png`: exploded view, numbered in build order
- `screw_map.png`: every screw, lettered, with what it passes through

## Print

All PLA, your 0.12 mm profile, 100% scale, flat as exported, no supports.

| File | Qty | Settings |
|---|---:|---|
| 12_forearm_cheek_A_hub_side.stl | 1 | 4 walls, 40% |
| 13_forearm_cheek_B_bearing_side.stl | 1 | 4 walls, 40% |
| 14_wrist_bracket.stl | 1 | 3 walls, 20%. Stands on its thick end plate, 53 mm tall. |
| 15_pen_holder_arm_A.stl | 1 | 4 walls, 40% |
| 16_pen_holder_body.stl | 1 | 3 walls, 15%. The pen hole runs sideways and has a pointed top on purpose, so it prints without supports. |
| 17_pen_collar.stl | 1 | 4 walls, 40% |
| 18_pivot_sleeve.stl | 1 | 100% infill (tiny tube) |

The test arm's cheeks and two of its rungs retire. Keep **one rung** (with its nuts): it goes into the new forearm.

## Hardware

- One MG90S from your box, with its bag (horn, horn screws, center screw, 2 tab screws)
- New: M3 × 16: 5, M3 × 12: 3, M3 nuts: 8, M3 washer: 1
- Reused: the 4 × M3 × 12 that held the test arm to the elbow hub, the rung's 2 screws, the elbow's M5 washer and nut
- 3 male-to-female jumper wires (your ELEGOO kit) to extend the MG90S cable, which is too short to reach the driver board

## Wiring and program

- Extend the MG90S cable with the 3 jumpers, matching colors, and plug it into **channel 3** (next to the elbow), brown toward the board edge.
- Upload `arm_test/arm_test.ino` from this folder. It drives four joints: `b` base, `s` shoulder, `e` elbow, `w` wrist. The wrist is limited to 1350-1650 until we know which way it turns. The elbow now stops at 1900 so the new forearm can't fold into the upper arm.

## Build order (numbers match construction_diagram.png)

**1. Take the test arm off the elbow**, the same way you took it off the shoulder: M5 nut off, cheek B's 3 rung screws out, cheek B off, then the 4 screws holding cheek A to the elbow hub. Keep one rung and all the screws.

**Steps 2-7 happen on the table, on the wrist bracket alone.**

2. Find the bracket's two walls: the **tab wall** has the rectangular window, the **back wall** has a small slot-shaped hole.
3. Plug the MG90S into channel 3, power on, type `w1500`, then `wo`, and unplug. It is now centered. Slide it into the window from the side away from the back wall. Shaft points **away from the back wall**, and the shaft end goes toward the **open end** of the bracket, away from the thick end plate. Two tab screws into the wall.
4. Horn onto the shaft. Pen-holder arm A goes on the horn: counterbored face outward, 2 horn screws through opposite slots. Turn the horn so arm A's wide end points **straight along the bracket, away from the end plate**. Then the center screw.
5. Drop an M3 nut into the slot-shaped pocket on the servo side of the back wall. Drop 2 M3 nuts into the slots on the long sides of the pen-holder body, near the top.
6. Push the pivot sleeve through the hole in the body's arm B, then hold the body so arm B sits outside the back wall and the sleeve goes into the slot.
7. M3 × 16 with the washer through the sleeve into the nut. **Leave it loose.** Bring the body up against arm A and screw them together with 2 × M3 × 12. Wiggle the holder up and down a few times, then tighten the pivot screw.

**Steps 8-10 put it on the arm.**

8. Rung onto forearm cheek A, in the hole near the round end (M3 × 16).
9. Drop 4 M3 nuts into the 4 slots at the ends of the bracket's thick end plate. Hold the bracket against cheek A with the **MG90S horn side facing cheek A**. Two M3 × 16 through cheek A into the end plate. Then cheek A onto the elbow hub with the 4 × M3 × 12, forearm pointing **straight down when the upper arm is level**, like the test arm was.
10. Spacers on the elbow bolt, cheek B over it, then 3 screws into cheek B: one into the rung, two into the end plate. Elbow M5 washer and nut back on.

**Steps 11-12: the pen.**

11. Nut into the collar's side slot, M3 × 12 started in it. Slide the collar onto the Sharpie (cap off), about halfway up.
12. Drop the pen tip-first down through the holder, from the side where the collar will rest. Slide the collar until about **1 inch of pen** sticks out of the bottom of the holder, and tighten the collar screw just snug.

**Check:** push the pen tip up gently with a finger. It should slide up and drop back by itself, without catching.

## First power-on

Base clamped. Support the forearm with your hand at first.

1. `s1500`, then raise the shoulder in steps: `s1400`, `s1300`, `s1200`, `s1100`.
2. `e1500`. The forearm hangs at a right angle to the upper arm.
3. `w1500`. The pen lines up with the forearm.
4. Try `w1450` and `w1550`. **Which one tilts the pen tip forward**, away from the base toward the sticky note?

Stop (`o`, arm supported) if anything rubs, buzzes loudly or heads for the table.

## Report back

- Which wrist number tilts the pen tip forward: `w1450` or `w1550`?
- Does the pen slide freely in the holder?
- Anything rubbing? A photo of the wrist helps.

Next comes calibration: teaching the software the exact angle each servo pulse gives, then the first drawn square.

## What was checked in CAD (not yet on the real robot)

- All 7 parts are single, watertight solids and fit the A1 mini bed.
- Pen holder vs the wrist bracket and servo: clear from -75 to +45 degrees of wrist turn.
- Pen (full 125 mm Sharpie) vs the forearm: clear from -75 to +15 degrees. Drawing needs -11 to -42.
- New forearm vs upper arm: clear from +20 down to -125 degrees of elbow; touches at -140, hence the 1900 limit.
- Drawing poses (pen on the paper and 25 mm above it, near and far edges of the sticky note): the arm clears the shoulder mount and the table.
- MG90S size, shaft position and horn height are estimates. The pivot slot gives the holder about 1.5 mm of adjustment to line up with the real shaft.
