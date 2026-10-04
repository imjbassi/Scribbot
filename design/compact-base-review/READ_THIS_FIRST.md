# Compact base revision — design review, NOT a print release

The earlier tall rotating-base-v1 package is superseded. Do not buy its 100 mm shaft, collars or M4 x 110 frame bolts for this revision. Keep the successful fit-test parts and bearings. This package is source CAD, reference renders and numerical design checks; it deliberately contains no printable STL release while the actual servo-horn interface remains unresolved.

## Settled layout for this revision

- Fixed 150 x 150 x 9 mm board-mounted base.
- One stationary M5 axle bolt, with two 625 bearings running on its smooth shank.
- Bearing INNER rings stay stationary; OUTER rings turn with the printed rotor, gear and top platform. This reverses the bearing arrangement of the withdrawn design.
- Bearing center spacing: 25 mm. Platform top: 67.4 mm above board.
- Target shoulder-axis height: approximately 115 mm, to be set by shoulder-carrier CAD. A central clearance well must accommodate the stationary bolt/nut stack up to approximately 86 mm above the board; no shoulder part may sweep through it.
- One MG90S beside the rotor, mounted in the previously accepted plate geometry.
- Printed 25-tooth motor gear drives a printed 50-tooth base gear, module 1.25 and 20-degree pressure angle. Nominal shaft spacing is 46.875 mm.
- The drive provides 2:1 torque multiplication before friction; 140 degrees of usable servo travel gives 70 degrees of base travel. Planned base range is -35 to +35 degrees, contingent on actual calibrated servo travel.
- Standard shoulder/elbow servos remain MG996R; optional wrist rotation remains in the mass budget. This base change does not resolve the outstanding shoulder thermal/load test.

## Complete load path

Arm/shoulder carrier -> rotating top platform -> bolted rotor and gear stack -> bearing outer rings -> balls -> stationary inner rings -> narrow washers and central support/spacer stack -> base board.

The MG90S drives through its supplied horn and the small gear. It supports the small gear and receives tooth reaction forces, but not the arm's weight. The pinion is not separately bearing-supported; the hobby servo output still sees gear-mesh radial force. This tradeoff must be checked at low acceleration, rather than claiming the servo shaft is entirely load-free.

## Motor connection: designed concept, one remaining physical check

The small gear bolts to the SUPPLIED horn; no printed spline is used. Candidate gear attachment slots accept M2-sized fasteners at radii 7–11 mm in four directions. The central 8 mm access hole allows the original horn screw to be reached. At least two compatible horn attachment locations are required, preferably on opposite arms. Fasteners must clear the servo case below and the large gear beside it.

The reference render assumes a double-ended 26 mm long, 2 mm thick horn, with attachment locations at +/-9 mm. These are placeholders, NOT measurements of the user's hardware. The photographed MG996R horn assortment does not establish the MG90S horn dimensions.

Update: IMG_9221.png shows a double-ended white horn with multiple holes per arm. The user confirmed this horn seats snugly on the black MG90S shaft without forcing. Shaft compatibility is accepted from that physical check. Exact hole diameters, horn thickness and fastener clearance remain unmeasured. The candidate motor gear is now released separately in ../base-horn-fit for an UNPOWERED alignment check only. Its slots must align with two opposite horn holes while centered. Do not force or drill the horn to match.

Gear-height alignment is adjustable by changing the four printed motor-post heights and using thin shims. The nominal 10 mm posts and 6.5 mm body-to-shaft offset in CAD are layout references. The base slots permit translation to align the gear axes and set mesh clearance. The motor gear and base gear must overlap axially without rubbing, and the original horn screw must be accessible before any powered test.

## Why this is preferable to the withdrawn base

It removes the separate precision shaft, two collars, tall two-deck frame and long M4 bolts. It places the arm much closer to the original height budget and makes the motor accessible from the side. The reduction improves base torque and halves the base angle change corresponding to a given servo angle change.

The tradeoff is printed gear backlash and limited yaw. Nominal tooth thinning produces 0.12 mm total pitch-circle backlash, equivalent to approximately 0.22 degrees at the base, or 0.77 mm at 200 mm radius. Real printed clearances, servo backlash, flex and wear can add more. This is a design calculation, not a measured accuracy specification. Avoid heavy grease on PLA; lubrication selection is not part of this release.

## Reach checks completed

With 120 mm links and an ideal vertical 95 mm tool offset, the checker sampled the 60 x 60 mm drawing patch (X=135..195, Y=-30..30 mm) at tip heights 2, 12 and 25 mm. It also checked provisional dock tip targets at X=145, Y=-75 mm, Z=10/25/40 mm. This replaces the old provisional dock location.

At each of six assumed shoulder heights from 100 to 125 mm, all 510 sampled targets had an IK solution within the chosen candidate joint limits. The dock yaw is approximately -27.35 degrees, within the planned +/-35-degree base sector. At the target 115 mm shoulder height, sampled joint ranges were approximately:

| Joint | Geometric angle range |
|---|---|
| Base yaw | -27.35 to +12.53 degrees |
| Shoulder | 29.15 to 57.87 degrees |
| Elbow | -111.49 to -68.73 degrees |
| Wrist pitch | -56.77 to -26.98 degrees |

These are geometric angles, not raw servo commands. Zero offsets and direction signs remain to be calibrated. The check does not prove full continuous-path coverage, physical servo travel, gripper/dock access, full-pen clearance, or self-collision avoidance. Complete shoulder, wrist and dock meshes are still needed for those checks. Do not use these numbers directly as servo targets.

The 2D involute gear profiles were checked in 561 sampled poses across the planned base range with zero polygon overlap at nominal spacing. Calculated nominal contact ratio is about 1.68. This is a tooth-profile interference check, not a torque, wear or printed-mesh test.

## Prospective parts list — do not purchase yet

### Already available or previously fitted

- 1 MG90S for base drive, with original horn and horn-center screw.
- 2 of the purchased 625-2RS bearings.
- Accepted MG90S plate geometry, rotated 90 degrees for this layout; the existing plate can be reused.
- One tested bearing cap can be reused; two caps total are needed. The old single-bearing carrier is a useful fit reference but does not become the new rotating rotor block.

### Proposed new hardware

| Part | Qty | Required check |
|---|---:|---|
| M5 x 80 partially threaded socket-head bolt | 1 | Smooth shank must cover both bearing journals; minimum approximately 55 mm from underside of head. Threads must reach upper nuts. Bearing fit must not visibly rock. |
| M5 hex nuts, approximately 4 mm thick | 2 | Lock together without overcompressing printed spacers or preloading bearings |
| Narrow M5 washers, 5.3 ID x 9 OD x 1 mm thick | 5 | Must contact inner races only; actual thickness affects axial stack |
| M3 x 45 machine screws | 4 | Through rotating platform + caps + rotor/gear stack |
| M3 nuts | 8 | Four rotor bolts and four motor-plate bolts |
| Thin M3 washers | 16 | Eight for rotor stack, eight for motor plate |
| M3 x 30 socket-head screws | 4 | Motor plate/post/base mounting; exact length after horn-height adjustment |
| M2 x 10 machine screws, M2 nuts, thin M2 washers | 2, 2, 4 | Existing proposed servo-tab fastening; use only if actual tabs accept it |
| Horn-to-gear fasteners | At least 2 | Diameter and length pending actual horn; not yet orderable |
| Approximately 4 x 16 wood screws and washers | 4 | Base to an 18 mm board; check actual engagement |

An undersized general-purpose bolt shank can introduce tilt even when its nominal diameter is M5. Do not assume the bolt is a precision shaft. Verify its two bearing fits before committing to loaded operation. If there is visible rocking or thread contact, this axle choice must be revised. The inner-ring spacers are printed to maximize printable content; compression/creep under clamping is another physical validation item. Jam nuts prevent loosening but do not justify overtightening.

### Proposed print list

Base x1; stationary pedestal x1; lower rotor block x1; upper rotor block x1; large gear x1; small gear x1; rotating platform x1; bearing caps x2 total; inner-ring spacer x1; top spacer x1; motor plate x1 total; motor posts x4. Gear and rotor blocks are separate so the gears can print flat without large unsupported overhangs and can be replaced individually.

## Assembly sequence after interface release

1. Check the actual bolt's smooth journal fit in both bearings and its thread reach. Fit the stationary axle through the base from below, with its head recessed.
2. Stack the stationary pedestal and first narrow washer on the axle. Lower bearing bottom is nominally Z=30.2 mm.
3. Build the rotating shell loosely from lower cap, lower rotor block, large gear and upper rotor block around the axle. The two bearings sit at opposite ends of the 16.3 mm bore; their separation is set by the inner-ring spacer stack, not by the servo.
4. Between the bearings fit a narrow washer, the 18 mm inner spacer, and a second narrow washer. Fit the upper bearing, then the top cap and platform. Bolt the rotating stack with four M3 x 45 screws and washers/nuts. Ensure the bearing outer rings are captured without seal rubbing.
5. Above the upper inner race, fit a narrow washer, 10 mm top spacer, another washer and the two M5 nuts. Adjust to hold the inner-ring stack while allowing free rotor movement. Nominal total outer-race axial freedom is 0.4 mm; printed and washer tolerances may require spacer adjustment. Do not squeeze away a tight spot by tightening harder.
6. Attach the actual supplied horn to the disconnected MG90S using its original screw. Attach the small gear with the matched fasteners once that interface is released. Install the motor plate, posts and servo; align gear height and mesh without binding.
7. Disconnect/disengage the motor gear for the first free-turn test. Then mesh the gears and check tooth engagement gently within the calibrated range; do not force the servo through a hard stop by turning the platform.
8. Only after mechanical fit, safe pulse calibration and the future joint-limit procedure should unloaded powered tests begin. No firmware is supplied in this review package.

## Superseding physical-fit update

The user confirmed the printed motor gear sits flush, opposite holes align, it clears the MG90S case, and the center screw remains accessible. These checks pass. Horn-to-gear fastening is still unresolved; the user has only supplied servo screws. The next limited release is ../compact-base-stage-1: a passive turntable prototype, motor detached. Its instructions supersede the earlier request to repeat the horn fit check. The full powered base remains unreleased.

## Previous next-action note (superseded)

Use the separate base-horn-fit instructions for the small gear alignment check. Do not print the full base or buy the prospective hardware yet. The existing fitted components remain valid. The next release should contain a matched motor connection, final hardware schedule and one assembly guide, rather than another disconnected test structure.
