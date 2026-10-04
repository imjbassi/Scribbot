# Use the consolidated build guide

Open [BUILD_GUIDE.html](BUILD_GUIDE.html). It is the current guide and includes the fully threaded axle limitation, hardware inventory, numbered diagram and expanded assembly steps. No STL geometry changed.

The earlier instructions below are retained as a design reference; follow the consolidated guide when they differ.

---

# Next build: passive compact turntable

This is the bearing-supported rotating base, assembled WITHOUT the motor gear engaged. It is an engineering prototype for physical fit and hand-turn testing, not a validated complete robot. The old tall base remains superseded.

## Confirmed and pending

You confirmed the white horn fits the black MG90S, the small gear sits flush, opposite holes align, the gear clears the case, and the center screw is accessible. Keep that printed gear. Those checks do not establish attachment screw size or loaded performance. You have only the supplied servo screws. Do not force them into the horn or substitute a long screw for the original center screw. Horn-to-gear fastening remains pending; the motor stays detached in this stage.

## Print list

Print flat as exported, 100% scale, PLA, 0.4 mm nozzle, your tested 0.12 mm layer / 0.2 mm first-layer profile. Use 4 walls, 5 top/bottom layers and 40% infill; use 100% infill for the pedestal and both inner-ring spacers. No supports. Inspect bridges over underside base recesses; remove loose strands before fitting hardware. Do not transfer the validated FDM clearances directly to resin.

| File | Total quantity | Notes |
|---|---:|---|
| 01_base.stl | 1 | 150 x 150 mm; new compact base |
| 02_fixed_pedestal.stl | 1 | Narrow end points upward |
| 03_lower_rotor.stl | 1 | 9 mm tall |
| 04_large_gear.stl | 1 | 50 teeth |
| 05_upper_rotor.stl | 1 | 15.4 mm tall |
| 06_bearing_cap.stl | 2 total | Reuse your accepted plain cap; print only one more if you have one |
| 07_top_platform.stl | 1 | 80 mm diameter |
| 08_inner_spacer_18mm.stl | 1 | Between inner bearing races |
| 09_top_spacer_10mm.stl | 1 | Above upper inner race |

Ten pieces total, or nine new pieces if reusing one cap. Reuse the small gear and MG90S mounting plate later. The old single-bearing carrier is NOT one of the new rotor blocks. Print one file at a time or arrange separate plates; do not stack the STLs on the slicer bed.

## Hardware required for this stage

This is a dimensional specification, not a verified supplier listing. Check any hardware you already own before ordering.

- Two 625-2RS bearings, 5 x 16 x 5 mm, from your existing supply.
- One M5 x 80 partially threaded socket-head bolt. Its smooth shank must extend at least 55 mm from under the head, with usable threads at 66.7–74.7 mm from under the head. A fully threaded bolt is unsuitable. Head must fit a 9.6 mm diameter x 5.5 mm-deep recess. Both bearings must slide onto the smooth shank without visible rocking; a nominal M5 label alone does not prove the fit.
- Two ordinary M5 hex nuts, approximately 4 mm thick each, used as jam nuts.
- Five narrow washers: approximately 5.3 mm ID, 9 mm OD, 1 mm thick. They must bear on the bearing INNER metal ring without touching the rubber seal. Check the actual bearing contact; dimensions alone do not guarantee seal clearance.
- Four M3 x 45 machine screws, four M3 nuts and eight thin M3 washers (approximately 0.5 mm thick). These clamp the rotating shell, not the fixed axle.

Do not buy the withdrawn design's 100 mm shaft, collars or long frame bolts. No motor fasteners or board screws are required for the initial bench fit. The base must later be secured before powered or loaded use.

## Assembly: two stacks share one axle

Use numbered_connection_guide.png alongside this sequence; its part numbers match the STL filenames. The inner stack stays still. The outer shell rotates around it. All heights are nominal; washer and print thickness affect the fit.

1. With the axle loose, check both bearings on its SMOOTH shank. Stop if the fit rocks visibly, binds, or puts a bearing on threads.
2. Insert the M5 bolt upward through the base from underneath. Seat its head in the recess. Place the pedestal over the axle, narrow tip upward, then one narrow washer.
3. Lower a bearing cap and the lower rotor over the pedestal tip. Insert the lower bearing into the rotor from above, sliding its inner ring onto the axle until it rests on the narrow washer. The bearing must be supported through its inner ring; do not press through its seal.
4. Add a narrow washer, the 18 mm spacer and another narrow washer onto the axle. Add the large gear and upper rotor around that stack. Align all four corner holes through the rotating parts.
5. Slide the upper bearing into the upper rotor from above until its inner ring reaches the washer. Add the second bearing cap and top platform. Insert four M3 x 45 screws through the corner-hole stack with washers and nuts. Tighten evenly only until seated; stop if tightening introduces binding or distorts the prints.
6. Above the upper bearing INNER ring, add a narrow washer, the 10 mm spacer and the fifth narrow washer. These pass through the cap/platform center opening. Add the two M5 nuts. The lower nut holds the stationary inner stack; the upper nut locks against it. Hold the lower nut while tightening the upper so you do not change the stack compression.
7. The design leaves approximately 0.4 mm total outer-ring axial clearance. Check for rubbing and excessive play. Do not eliminate binding by overtightening. If the washer stack differs or the assembly binds, report it so spacer length can be adjusted.

## Pass/fail before adding the motor

With the motor gear detached and no arm attached, hold the base and turn the platform by hand through one full turn. Bearing seals may add gentle, consistent drag.

PASS: smooth movement without a tight spot, no seal/cap scraping, no visible rocking of the platform, axle remains fixed, and the printed stack stays clamped. Repeat after locking the M5 nuts.

FAIL: catching, grinding, obvious wobble, bearing threads contact, or movement becomes tight after locking nuts. Stop and identify which symptom occurs. Do not add the motor or power it to overcome resistance.

Report: "turntable turns smoothly, no wobble" or the symptom. This test establishes unloaded fit only; loaded deflection, backlash, thermal behavior, fasteners and powered travel remain later checks.
