# Stage 3: first powered test — center the base servo

Goal: command the base MG90S to its center position with the gears **out of mesh**, then re-mesh the gears so the platform's center matches the servo's center.

This is one servo, no arm, no load. Nothing else is powered.

## What you need

- Arduino Nano + its USB cable
- ONE HiLetgo PCA9685 board (keep the second as a spare)
- Basicvolt 5 V 3 A adapter, with the **plain barrel plug** on the cord (no tip adapter)
- The **female** end of the 18 AWG barrel pigtail pair
- 4 female-to-female jumpers (ELEGOO kit)
- Multimeter
- Small flat screwdriver for the green screw terminal
- Arduino IDE (already installed on your PC)

## 1. Check the power adapter first (nothing else connected)

1. Plug the adapter's barrel into the female pigtail.
2. Plug the adapter into the wall.
3. Multimeter on DC volts: red probe on the pigtail's **red** wire, black probe on its **black** wire.
4. **Pass:** +4.9 to +5.3 V. **Fail:** negative reading (polarity reversed), or above 5.5 V. Stop and report it.
5. Unplug the adapter from the wall.

## 2. Wire it (adapter unplugged)

Follow `wiring_diagram.png`.

| From | To |
|---|---|
| Nano **GND** | PCA9685 header **GND** |
| Nano **5V** (not VIN) | PCA9685 header **VCC** |
| Nano **A4** | PCA9685 header **SDA** |
| Nano **A5** | PCA9685 header **SCL** |
| Pigtail **red** | green terminal **V+** |
| Pigtail **black** | green terminal **GND** |
| Servo plug | Channel **0**: brown on GND row (board edge), orange on PWM row |

Leave the header's **OE** and **V+** pins empty. Tug each screw-terminal wire gently to confirm it's clamped on bare copper, not insulation.

## 3. Upload the test sketch (adapter still unplugged)

1. Open `base_servo_test/base_servo_test.ino` in Arduino IDE. No extra libraries are needed.
2. **Tools → Board → Arduino Nano.**
3. **Tools → Processor:** try **ATmega328P (Old Bootloader)** first. Most clone Nanos need it. If the upload fails, switch to **ATmega328P**.
4. **Tools → Port:** pick the COM port that appears when the Nano is plugged in. If no port appears, your Nano probably uses a CH340 USB chip and needs its Windows driver. Tell me and I'll walk you through it.
5. Upload, then open **Serial Monitor** at **115200 baud** with **Newline** line ending.
6. **Pass:** it prints `PCA9685 found`. **Fail:** `NOT found` means one of the four jumpers is wrong or loose.

At this point the servo gets no signal, so it stays limp. That's intended.

## 4. Center the servo

1. Confirm the small gear is **not touching** the large gear.
2. Plug the adapter into the wall. The driver's LED lights. The servo should stay still.
3. Type `c` and press Enter. The servo turns once to center (1500 µs) and holds.
4. Try `+` and `-` a few times. It should nudge a small amount each time and hold firmly.
5. Type `1300`, then `1700`. It should move smoothly to each position and stop.
6. Type `c` to return to center. **Leave it powered at center.**

**Pass:** smooth moves, holds position, no buzzing louder than a faint hum, servo body stays cool to the touch after 2 minutes.
**Fail:** jitter, continuous buzzing, the Nano resetting (the `PCA9685 found` message reappears), or a hot servo. Type `o` to release the servo, unplug the adapter, and report which symptom you saw.

## 5. Re-mesh the gears at center

1. With the servo **holding center**, turn the turntable by hand so the platform faces the middle of where the sticky note will be. This makes center equal "pointing at the drawing area".
2. Loosen the four motor-plate nuts slightly and slide the plate toward the large gear until the teeth mesh. Don't let the small gear rotate. If tooth tips collide, nudge the **platform** a few degrees and retry.
3. Aim for barely-there play: rocking the platform should give a tiny click, not grinding and not tightness. A strip of printer paper between the teeth while you tighten, then pulled out, gives about the right gap.
4. Tighten the four nuts evenly.
5. Type `o` to release the servo, then unplug the adapter.

## 6. First geared motion check

1. Plug the adapter back in. Type `c`. The platform should hold where you set it, or move only slightly.
2. Type `1400`, then `1600`, then `c`. The platform should swing a little each way and return.

**Pass:** smooth, no skipped teeth, no grinding, no tight spot, and the plate doesn't shift.
**Fail:** clicking or skipping teeth, stalling, or the servo straining. Type `o`, unplug, and report it.

Stay within 1300–1700 µs for now. Full travel limits come after we confirm how far the platform can swing without hitting anything.

## Report back

- Voltage reading from step 1
- Did `PCA9685 found` print?
- Steps 4 and 6: pass, or which symptom?
- A short video of step 6 if you can.
