> SUPERSEDED — DO NOT PRINT OR BUY FROM THIS PACKAGE.
> The compact-base-review revision replaces this tall prototype. See outputs/CURRENT_BUILD_STATUS.md. Existing fit-test results remain valid.
# Rotating base V1 — hand-operated mechanical prototype

This stage adds a real two-bearing rotating platform. It does not yet include the servo-horn connection, powered movement, shoulder support or links. Test it by hand without the arm attached. The existing accepted MG90S plate remains the motor-mount interface for the next stage.

## How it works

Four bolted printed columns hold two stationary decks. Each deck carries one of the tested bearing carriers and caps. Both 625 bearing inner rings and a smooth vertical shaft rotate; outer rings stay in the fixed housings. The rotating platform clamps onto the shaft. Its weight travels through the shaft's upper collar and narrow washer into the upper bearing inner ring, then its outer ring and the stationary frame. The second bearing, 35 mm below the first, helps resist tilting. The lower collar prevents upward escape; it must not preload the bearings.

The drive will attach below the lower bearing. It must transmit torque while preserving axial clearance so the servo cannot take the platform weight. No drive adapter is released until the supplied MG90S horn is identified and its attachment geometry checked. Do not power a jury-rigged coupling.

This prototype uses a smooth shaft instead of treating a bolt's threads as a bearing journal. It introduces purchased shaft/collars because they provide a repeatable bearing surface and positive axial retention. None of the parts is claimed load-tested.

## Print list

| File | Copies | Orientation |
|---|---:|---|
| 01_base_v1.stl | 1 | Label upward |
| 02_bearing_deck.stl | 2 | Flat |
| 03_lower_posts_4x.stl | 1 file = 4 posts | Upright |
| 04_upper_posts_4x.stl | 1 file = 4 posts | Upright |
| 05_rotating_platform.stl | 1 | Broad round flange on bed, clamp block upward |
| 06_bearing_carrier.stl | 1 additional if your tested carrier is available | Pocket upward |
| 07_bearing_cap.stl | 1 additional if your tested cap is available | Flat |

Reuse ONE carrier and ONE cap from the successful previous test: total required is TWO of each. The carrier and cap geometry is unchanged. This base supersedes the optional mechanical-fit-v1 base for this prototype; do not stack the two bases.

Use the tested PLA, 0.4 mm nozzle, 0.12 mm layers and 0.20 mm first layer. Four walls, six top/bottom layers, 25% infill are initial settings. Print at 100% scale. No supports expected; inspect the short bridges over recessed fastener pockets and the horizontal clamp-screw hole. Clear strings without altering the bearing fit. Every individual part fits the A1 mini's 180 mm square bed. Do not shrink a crowded layout; use additional plates.

## Hardware for the hand-operated assembly

Confirm availability before printing the large frame. These dimensions are a proposed build specification; substitutions need a stack/clearance check.

| Item | Quantity | Function |
|---|---:|---|
| 625-2RS bearing, 5x16x5 mm | 2 total | Already purchased; reuse the tested one |
| Smooth precision steel shaft, nominal 5 mm diameter x 100 mm length | 1 | Rotating bearing journal; not threaded rod |
| Metal shaft collar, 5 mm bore, approximately 12 mm OD x 7 mm axial width, with retaining screw | 2 | Upper/lower axial retention |
| Narrow steel washer, 5.3 mm ID x 9 mm OD x approximately 1 mm thick | 2 | Collar contact with bearing inner ring only |
| M4 x 110 mm socket-head machine screw | 4 | Full frame columns; inspect actual threaded length |
| M4 nut | 4 | Frame retention |
| M4 washer, OD no larger than 8.8 mm and thickness no greater than 0.8 mm for bottom recess | 8 | Frame bolts, one each end |
| M3 x 20 mm machine screw | 8 | Each cap/carrier/deck stack uses four |
| M3 nut | 8 | Bearing stacks |
| Thin M3 washer | 16 | Bearing stack screws |
| M3 x 30 mm socket-head screw | 1 | Platform split clamp |
| M3 hex nut, approximately 5.5 mm across flats | 1 | Platform clamp nut trap |
| Thin M3 washer | 1 | Platform clamp screw head |
| Approximately 4 x 16 mm wood screw plus washer | 4 | Mount to an 18 mm board |

Socket heads and washers must fit recessed pockets and stay below the base bottom. Base thickness above recess = 4.2 mm, lower post 55, first deck 4, upper post 31, second deck 4, total 98.2 mm. With a bottom washer up to 0.8 mm, top washer up to 0.8 mm and approximately 3.2 mm nut, occupied length is approximately 103 mm. Actual fastener dimensions determine protrusion; require at least two full threads beyond each nut. Verify with your hardware before tightening. The corner hardware stays outside the 80 mm rotating disk sweep.

Do not substitute a large M5 washer that touches bearing seals or the outer ring. Check the narrow washer against your actual bearing inner race. Collar/washer dimensions vary; set positions physically rather than relying on the preview's exact collar coordinates. A clamp-style collar is acceptable if its envelope clears surrounding caps and platform; otherwise the specified compact set-screw style is the space budget.

## Assembly order

1. Fit one bearing into each carrier. Place the cap on top. Set each carrier on a deck, aligning the central opening and four holes on 24 mm centers. Fasten cap + carrier + deck with four M3 x 20 screws, washers and nuts. Snug evenly; verify free inner-ring rotation. These longer screws replace the M3 x 16 used for the earlier carrier-only check.
2. Insert the four M4 x 110 bolts upward through the base's OUTER frame pattern (72 x 72 mm centers), with the heads and narrow washers in the underside recesses. The inner slotted holes are reserved for the servo plate and are not frame holes.
3. On each bolt stack one 55 mm post, the lower bearing deck (bearing pocket upward), one 31 mm post, then the upper bearing deck (pocket upward). Add top washers and nuts but leave the assembly loose enough to align.
4. Pass the smooth shaft through both bearings. It should slide with gentle hand pressure. Do not hammer it. If it will not pass, stop: check shaft diameter, burrs and frame alignment. Do not enlarge the bearing inner rings.
5. With the shaft acting as an alignment reference, snug the four frame bolts progressively. Rotate the shaft after each pass. Stop if tightening introduces binding. Recheck each bearing cap; do not use nut torque to bend misaligned decks into place.
6. Above the upper bearing, put a narrow washer against the INNER ring, then an upper collar. Below the lower bearing, use the other washer and collar in reverse order. Access to the lower collar is through the open sides, under the lower deck. Secure the upper collar to the shaft. Set the lower collar with a small perceptible axial clearance, about 0.2–0.4 mm, rather than squeezing the bearings together. Secure its screw using the collar supplier's instructions.
7. Install the platform flipped relative to its print orientation: clamp block DOWN, flat disk UP. Slip its 5.2 mm clearance bore over the shaft. Fit the M3 nut in the side trap and the M3 x 30 clamp screw with washer. Position the platform clear of the upper collar; start with disk top about 142 mm above the board. Snug just enough to prevent slipping. Do not force the slit fully shut or crack the hub. The shaft may protrude above the disk; the later shoulder support must leave its center clear.
8. Rotate the platform by hand through a full turn. Check that the collar, hub, platform, caps and all screws remain clear. The final wired robot will have limited base travel; this full-turn check is for the bare mechanical assembly only.
9. Anchor the base to the board only after verifying all underside heads sit recessed and the base sits flat. Test the hand rotation again.

## Acceptance checks

- Shaft rotates freely with no new tight spots after bolting down the frame.
- Platform does not slip around the shaft with gentle hand rotation; do not apply arm-scale load yet.
- No visible rocking of bearings in their carriers or shifting of frame joints under a gentle fingertip push.
- Small axial end play remains; bearing seals do not rub printed rims or washers.
- All rotating parts clear the stationary frame and the upper collar clears the platform hub.

Report rubbing, wobble, slipping or difficulty inserting the shaft rather than forcing a fit. Passing these checks is only an unloaded mechanical result. Arm loads, servo torque, backlash and thermal duty remain untested.

## Geometry changes and remaining work

The preliminary platform height is about 142 mm above the board, not the earlier 100 mm shoulder-axis estimate. The final shoulder axis will be higher still; its exact height depends on the shoulder carrier. Recompute reach, dock approach and inverse kinematics with the actual shoulder-axis height before powered motion. No full-sheet reach or original workspace guarantee is carried into this taller prototype.

The servo plate's existing 52x32 mm mounting pattern fits the base's inner slots, allowing +/-6 mm X adjustment. This may not cover the actual output-axis offset: verify with the shaft before attaching any drive. Y adjustment and horn-height spacing may need a revised adapter after horn inspection. The manual assembly is independent of that pending motor alignment.

Source `rotating_base.scad` contains assembly and exploded inspection modes (`part="assembly"` or `part="exploded"`). Gray shaft, collars, washers and bearings are reference metal parts, never printable substitutes. Assembly view omits frame fasteners and servo hardware for clarity. Export only the individual print modes. No STEP or complete arm assembly is included in this stage.

