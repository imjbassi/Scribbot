// Shoulder test: Arduino Nano + PCA9685, MG996R shoulder on channel 1.
// The base servo (channel 0) is never commanded here, so it stays limp.
// No extra libraries needed. Serial Monitor at 115200 baud, "Newline".
//
// Commands:
//   c        go to 1500 us
//   +  / -   nudge 10 us
//   1400     go to a pulse width in us (limited to 700-2300)
//   t        start/stop the hold timer (prints elapsed time every 10 s)
//   o        outputs off (servo goes limp: the lever DROPS, keep the catch under it)
//   ?        show status
//
// Outputs stay OFF at startup until you send a command.
// Every move steps 10 us every 25 ms, so the lever moves slowly.

#include <Wire.h>

const uint8_t PCA_ADDR = 0x40;
const uint8_t CHANNEL = 1;
const int MIN_US = 700;
const int MAX_US = 2300;
const int CENTER_US = 1500;
const int NUDGE_US = 10;

int currentUs = -1;  // -1 = output off
bool timing = false;
unsigned long timerStart = 0;
unsigned long lastReport = 0;

void writeReg(uint8_t reg, uint8_t value) {
  Wire.beginTransmission(PCA_ADDR);
  Wire.write(reg);
  Wire.write(value);
  Wire.endTransmission();
}

void setChannelTicks(uint8_t ch, uint16_t on, uint16_t off) {
  Wire.beginTransmission(PCA_ADDR);
  Wire.write(0x06 + 4 * ch);
  Wire.write(on & 0xFF);
  Wire.write(on >> 8);
  Wire.write(off & 0xFF);
  Wire.write(off >> 8);
  Wire.endTransmission();
}

void outputOff() {
  setChannelTicks(CHANNEL, 0, 0x1000);  // full-off bit
  currentUs = -1;
  timing = false;
  Serial.println(F("Output OFF (servo limp)."));
}

void writeUs(int us) {
  // 50 Hz frame = 20000 us split into 4096 ticks.
  uint16_t ticks = (uint32_t)us * 4096UL / 20000UL;
  setChannelTicks(CHANNEL, 0, ticks);
  currentUs = us;
}

void moveTo(int target) {
  target = constrain(target, MIN_US, MAX_US);
  if (currentUs < 0) {
    writeUs(target);  // unknown start: one jump
  } else {
    while (currentUs != target) {
      int step = constrain(target - currentUs, -NUDGE_US, NUDGE_US);
      writeUs(currentUs + step);
      delay(25);
    }
  }
  Serial.print(F("Pulse = "));
  Serial.print(currentUs);
  Serial.println(F(" us"));
}

void toggleTimer() {
  if (currentUs < 0) {
    Serial.println(F("Servo is off. Send c or a pulse first."));
    return;
  }
  timing = !timing;
  if (timing) {
    timerStart = millis();
    lastReport = timerStart;
    Serial.println(F("Timer started. Type t again to stop."));
  } else {
    Serial.print(F("Timer stopped at "));
    Serial.print((millis() - timerStart) / 1000UL);
    Serial.println(F(" s"));
  }
}

bool pcaPresent() {
  Wire.beginTransmission(PCA_ADDR);
  return Wire.endTransmission() == 0;
}

void setup() {
  Serial.begin(115200);
  Wire.begin();
  delay(200);

  if (!pcaPresent()) {
    Serial.println(F("PCA9685 NOT found at 0x40. Check VCC, GND, SDA->A4, SCL->A5."));
    while (true) {}
  }

  writeReg(0x00, 0x10);  // MODE1: sleep so the prescaler can be set
  writeReg(0xFE, 121);   // PRESCALE: ~50 Hz with the nominal 25 MHz oscillator
  writeReg(0x00, 0x20);  // MODE1: wake, register auto-increment
  delay(1);
  writeReg(0x00, 0xA0);  // MODE1: restart
  outputOff();

  Serial.println(F("SHOULDER TEST (channel 1). Commands: c, +, -, 700-2300, t, o, ?"));
}

void loop() {
  if (timing && millis() - lastReport >= 10000UL) {
    lastReport += 10000UL;
    Serial.print(F("  holding "));
    Serial.print((millis() - timerStart) / 1000UL);
    Serial.print(F(" s at "));
    Serial.print(currentUs);
    Serial.println(F(" us"));
  }

  if (!Serial.available()) return;
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  if (cmd.length() == 0) return;

  if (cmd == "c") {
    moveTo(CENTER_US);
  } else if (cmd == "+") {
    moveTo((currentUs < 0 ? CENTER_US : currentUs) + NUDGE_US);
  } else if (cmd == "-") {
    moveTo((currentUs < 0 ? CENTER_US : currentUs) - NUDGE_US);
  } else if (cmd == "t") {
    toggleTimer();
  } else if (cmd == "o") {
    outputOff();
  } else if (cmd == "?") {
    Serial.print(F("Current pulse: "));
    if (currentUs < 0) Serial.println(F("OFF"));
    else { Serial.print(currentUs); Serial.println(F(" us")); }
  } else if (isDigit(cmd.charAt(0))) {
    moveTo(cmd.toInt());
  } else {
    Serial.println(F("Unknown command. Use c, +, -, 700-2300, t, o, ?"));
  }
}
