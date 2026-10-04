# Stage 4: base calibration and repeatability

You'll measure three things before any arm parts go on the base:

1. **Scale:** how far the platform turns per microsecond of servo pulse.
2. **Travel:** whether the base reaches the planned ±35° without straining.
3. **Repeatability:** whether it returns to the same spot every time. This is the "base repeatability" test from the original spec.

A pen held 120 mm from the axis hovers over a ruler. At that radius, 1° of turn moves the tip about 2.1 mm.

See `setup_preview.png` for the complete setup and `pointer_mounting_diagram.png` for how the pointer bolts on.

## Print

`calibration_pointer.stl`, one copy. PLA, your usual 0.12 mm profile, 4 walls, 30% infill, 100% scale, flat as exported, no supports. It's 170 × 42 × 24 mm and fits the A1 mini bed straight.

## Hardware (all from your kits)

- 4 × M3 × 16 screws (× 20 also works), 4 × M3 nuts, 4 × M3 washers: pointer to platform
- 1 × M3 × 16 screw + 1 × M3 nut: pen set screw
- Any pen or pencil 8–15 mm thick (a felt-tip is fine)
- A ruler with millimeter marks, plus tape

## Set up

1. **Bolt the pointer to the platform.** It sits flat on the platform top. The four small holes line up with the platform's four outer holes (the ones not used by the turntable bolts). The large holes clear the turntable bolt heads and the center nuts. Put the screws down from the top, with a washer and nut underneath the platform. You can reach under from the side, above the big gear.
2. **Fit the pen.** Drop the M3 nut into the slot on the sleeve's outer block, then thread the M3 × 16 screw in from outside. Slide the pen down through the sleeve, tip pointing down. Set the tip about **1 mm above the table** and tighten the screw just enough to hold it.
3. **Keep the base from moving.** Tape or clamp the base to the table. If it slides, every reading is wrong.
4. **Tape the ruler to the table under the pen tip.** The ruler should run crosswise to the pointer, so the tip travels along it.
5. Clear the table in a circle about 25 cm around the base. The pen swings along an arc during the travel test.

## Upload the new sketch

Open `base_calibration/base_calibration.ino` and upload it the same way as before (Arduino Nano, Old Bootloader, COM3). Close the Serial Monitor first, or the upload can't open the port. Then reopen Serial Monitor at 115200 with Newline.

This sketch allows 600–2400 µs and adds an `r` command. It still moves in slow steps.

## Test A: scale and direction

1. Plug in the adapter. Type `c`. Note the ruler reading under the tip.
2. Type `1700`. Note the new reading. The difference is **d** (mm).
3. From above, note the direction the platform turned for `1700`: **clockwise or counterclockwise**.
4. Type `1300`, then `c`. The tip should land about the same distance on the other side.

## Test B: travel to ±35°

Find your **d** in this table and use the two pulse values on that row.

| d (mm, 1500→1700) | Platform turned (°) | µs per degree | −35° pulse | +35° pulse |
|---:|---:|---:|---:|---:|
| 16 | 7.6 | 26.3 | 578 | 2422 |
| 18 | 8.5 | 23.4 | 679 | 2321 |
| 20 | 9.5 | 21.1 | 760 | 2240 |
| 22 | 10.4 | 19.3 | 826 | 2174 |
| 24 | 11.3 | 17.7 | 881 | 2119 |
| 26 | 12.2 | 16.4 | 927 | 2073 |
| 28 | 13.1 | 15.2 | 967 | 2033 |
| 30 | 14.0 | 14.2 | 1001 | 1999 |

Round d to the nearest row. If d is **below 17 mm**, the servo can't reach ±35° inside 600–2400 µs. Do only steps 1–2 below using 700 and 2300, then report.

1. Walk out in 100 µs steps toward the **+35° pulse** (for example `1800`, `1900`, `2000`, and so on), then type that pulse itself. Watch and listen at each step.
2. Type `c`, then walk out the same way to the **−35° pulse**.
3. Type `c` to return to center.

**Pass:** it moves at every step, reaches both pulses smoothly, and holds without loud buzzing. No gear clicks or skipped teeth.
**Fail:** the platform stops moving while the pulse keeps changing (the servo has hit its internal limit), buzzing or straining, or gear skipping. Type the last good pulse, then `o`, and report where it failed. Don't keep pushing past the point where the platform stops moving.

## Test C: repeatability

1. Type `c` and wait a few seconds.
2. Type `r`. The base swings out and back to center 10 times from the PLUS side, then 10 times from the MINUS side. It pauses 4 seconds at center each time and prints a line like `PLUS side #3 -> read the ruler now`.
3. Write down the ruler reading at every pause, to the nearest 0.5 mm. It's easier to film the tip with your phone and read the video afterward.
4. Press Enter at any time to stop.

**Pass:** all 20 readings fall within **1.2 mm** of each other, and the PLUS average and MINUS average differ by no more than 1.2 mm. At 120 mm, this is the same angle as the spec's 2 mm at 200 mm, about 0.6°.
**If it fails:** don't worry yet. Report the numbers. A consistent PLUS-versus-MINUS gap is gear and servo backlash. Random scatter points to something loose, such as the horn screws, the gear-to-horn screws, the motor-plate nuts, or the axle.

## Report back

- **d** and direction (clockwise or counterclockwise for 1700)
- Test B: pass, or where it stopped
- Test C: the 20 readings (or a video of the run)

## Why this matters

These numbers turn "pulse width" into real base angles for the software. They confirm the dock direction (about −27°) is reachable, and they tell us whether base backlash is small enough for 60 mm drawings before we spend filament on the shoulder.
