# Fit results — 2026-09-24

User-reported physical test results, with slicer settings transcribed from the supplied screenshot.

| Test | Reported result | Design interpretation |
|---|---|---|
| MG90S body | +0.6 best | Add 0.6 mm total to nominal length and width: 0.3 mm per side |
| MG996R body | +0.6 best | Add 0.6 mm total to nominal length and width: 0.3 mm per side |
| 625 bearing | 16.3 best | Use 16.3 mm nominal CAD bore as starting point; retain bearing with caps |
| Slider | User selected 0.3 after follow-up | Use 0.3 mm per side; final spring-loaded guide still needs testing |
| Sticky-note holder | Fits good | Keep current nominal holder geometry; actual note dimensions not measured/reported |

## Slicer settings shown

- Printer profile: Bambu Lab A1 mini.
- Nozzle: 0.4 mm, standard flow.
- Filament profile: Generic PLA (actual filament brand not supplied).
- Layer height: 0.12 mm; initial layer: 0.20 mm.
- Seam: aligned.

These fit allowances apply to this tested printing setup. Do not assume identical results at 0.2 mm layer height, with PETG, or with resin. Fit-critical pockets should retain the tested settings or be rechecked after a process change. Design future parts within the A1 mini build envelope, rather than the larger bed originally assumed.

## Derived CAD openings

- MG90S reference body opening: 23.4 x 12.8 mm.
- MG996R reference body opening: 41.3 x 20.3 mm.
- Bearing pocket diameter: 16.3 mm. Depth, axial clearance and retention are not established by the through-hole coupon.
- Slider side clearance: 0.3 mm per side, 0.6 mm total additional channel width.

These tests establish body-fit clearances and the selected mounting patterns below, not full servo mounting geometry. Horn offsets, wire exits and supported axle geometry still require verification. The slider coupon does not verify an enclosed guide, friction under spring load, or vertical clearance.

Follow-up: user selected the 0.3 mm slider channel.

## Mounting-template results

User reported: "m1a27 and s2a49b10".

- MG90S: M1, A = 27 mm center-to-center between end mounting holes.
- MG996R: S2, A = 49 mm lengthwise and B = 10 mm across each end tab.
- Carry these nominal pattern dimensions into bracket CAD alongside the confirmed body openings. This is a visual template selection, not a precision caliper measurement. M1 is the smallest tested MG90S spacing; if a later bracket shows systematic misalignment, revisit that boundary rather than force assembly.
- The template's small reference-hole diameters are not final mounting-screw clearances. Final holes must match actual fasteners and tab geometry.
- Next design step: removable servo brackets and supported joints, with assembly fit verification. No additional measurement tracing is needed for these selected patterns.

## Mechanical plate and bearing retention follow-up — 2026-09-25

The user accepted the parts 01–04 checks with "everything good": both servo plates sit flat with aligned holes, and the bearing turns freely with the cap held in place. See `../mechanical-fit-v1/FIT_RESULTS.md` for scope. This confirms hand-held fit, not powered or load-tested operation. Optional base and spacer parts have no reported fit result yet.

