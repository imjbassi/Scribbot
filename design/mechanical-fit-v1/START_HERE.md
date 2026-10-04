# First mechanical interfaces — fit release V1

This release converts the accepted mounting templates into removable screw-mounted servo plates and a common base interface. It also tests a captured 625 bearing. It is NOT the complete robot, a finished shoulder/elbow joint, or a load-test fixture. No servo should be powered in this assembly yet.

Editable OpenSCAD source: set `part` to `assembly_micro`, `assembly_standard`, or `exploded_standard` to inspect the pedestal arrangement. Gray servo boxes are approximate envelope references only, and omit ears, horns, screws and wires. Never export these assembly previews as printable parts. Export the individually named part options instead. STEP files are not included in this OpenSCAD fit release.

## Print first

Print one each of `01_mg90s_mount_plate.stl`, `02_mg996r_mount_plate.stl`, `03_625_bearing_carrier.stl`, and `04_625_bearing_cap.stl`. Each has one part. Print flat, labeled face up where present, at 100% scale with your confirmed PLA/0.4 mm nozzle/0.12 mm layer profile and 0.20 mm first layer. Use four walls and at least five top/bottom layers; no supports. Print carrier pocket upward. Clear loose strings without enlarging fit surfaces.

Do not print extra shoulder/elbow copies yet. These plates establish interfaces for those later modules; their carrier structures and horn couplings are still pending.

## What to test

### Servo plates

Feed the cable through the body opening, then insert the servo from the labeled side. Tabs rest on the 4 mm thick plate. Check that every intended screw location aligns while the body sits naturally. There must be no need to bend tabs or squeeze the body. Reference openings are 23.4 x 12.8 mm for MG90S and 41.3 x 20.3 mm for MG996R.

MG90S uses the selected 27 mm spacing and 2.2 mm holes intended for M2 machine screws. MG996R uses 49 x 10 mm spacing and 3.4 mm holes intended for M3 machine screws. Actual servo slot width and supplied screws have not been verified. Try any available correctly sized screw gently; do not drill the servo or force an oversized screw. A smaller screw with appropriate washers can be evaluated if the slot will not accept the proposed size. The supplied coarse servo mounting screws are not assumed to match these machine-screw holes.

The four outer M3 holes on either plate have identical 52 x 32 mm center spacing. They attach the plate to a pedestal independently of the servo tab screws. Use washers on servo tabs where they fit without touching the body; tighten only enough to retain the servo without deforming its plastic tabs. Report interference instead of forcing it.

### Bearing carrier and cap

Insert ONE 625-2RS bearing into the 16.3 mm pocket from above. It should seat on the narrow outer support rim; nominal bearing top is 0.2 mm below the housing top. Set the cap over it, aligning four holes. The 14.6 mm central openings retain the bearing near its outer edge while leaving the shaft and inner race clear. Confirm the printed rims do not rub either rubber seal: actual bearing ring geometry varies.

With the cap held in place by fingers, turn the inner ring gently. Compare freedom of rotation with the loose bearing. If it binds or the seal rubs, stop and report it. Then, if hardware is available, fit four M3 x 16 machine screws, eight thin M3 washers and four M3 nuts. Tighten evenly and lightly. Check again. The bearing must not escape and should have only small axial clearance, not intentional preload. No axle or servo load is applied in this test.

The later major joints use TWO bearings each; this test only validates one retained bearing interface. It does not prove bending capacity, shaft alignment or a complete load path. Smooth metal journals and inner-race spacers will be specified with the complete joint; do not use bolt threads as final bearing journals.

## Optional base assembly after plate fit succeeds

`05_base_plate.stl` is 150 x 150 x 7 mm plus its label and fits the A1 mini bed. Print label upward; the small 7 mm underside counterbores require short bridging, not supports. `06_mg90s_spacers_4x.stl` contains four 20 mm high spacers; `07_mg996r_spacers_4x.stl` contains four 35 mm high spacers. Use only the matching spacer set for whichever servo plate is installed. They provide an open-sided, removable pedestal, not a closed housing. Verify clearance under actual servo cases, case screws, connectors and wire bends before tightening.

Stack, from bottom up: M3 screw head + washer, base plate, spacer, servo plate, washer + nut. Four M3 x 35 screws suit the nominal micro stack, or four M3 x 50 suit the standard stack. Check protrusion with actual nuts/washers. Under-base nuts for the servo tab screws remain separately accessible. The base access window and open sides allow cable routing and access.

Both servo plates fit the same outer bolt pattern; this makes the mounting platform swappable. Their OUTPUT SHAFT positions are not guaranteed to coincide. A later bearing support and horn coupling must align to each actual servo shaft; this release does not claim a drop-in drive-axis upgrade.

Board holes are 4.5 mm diameter on 124 x 124 mm centers. Four approximately 4 x 16 mm wood screws and washers suit an 18 mm board with this 7 mm base, subject to actual screw/washer thickness. Four underside pockets, 7 mm diameter and 3.6 mm deep, recess the module's M3 socket heads and thin washers. Check that these sit flush or below the bottom surface before anchoring the base. Use washers that fit the recess; report any protrusion rather than bending the base flat. Remove the base from the board to access the recessed heads when changing the module.

## Hardware for one initial fit of each plate and one bearing pod

No purchases are needed just to check that the servo bodies and bearing seat correctly. For screw-fastened checks, the following is a provisional allocation, dependent on actual servo slots accepting the screw diameters:

| Item | Quantity | Purpose |
|---|---:|---|
| M2 x 10 machine screw | 2 | MG90S tab attachment |
| M2 nut | 2 | MG90S tab attachment |
| M2 thin washer | 4 | MG90S attachment, clearance permitting |
| M3 x 12 machine screw | 4 | MG996R tab attachment |
| M3 x 16 machine screw | 4 | Bearing cap |
| M3 nut | 8 | Standard servo and bearing cap |
| M3 thin washer | 16 | Standard servo and bearing cap |
| Owned 625-2RS bearing | 1 | Retention test |

Optional base pedestal: four M3 x 35 OR four M3 x 50 screws, four M3 nuts and eight thin washers. The micro mounting interface introduces M2 hardware because these tabs should not be assumed to accept M3. Final arm quantities remain pending assembly CAD.

## Report back

1. MG90S: sits flat, both holes align, screw size tried (if any).
2. MG996R: sits flat, all four holes align, screw size tried (if any).
3. Bearing: seats fully, cap sits flat, inner ring still turns freely.
4. Any rubbing, interference or loose fit; a photo is useful if unclear.

Remaining mechanical work: output-horn attachment, shaft-axis position, bearing-support carriers, link geometry, complete assembly clearances, gravity/load verification and wrist module packaging. Earlier inferred tab heights are provisional; this release uses open space and through-fasteners to avoid tightly fitting unverified tab thicknesses.
