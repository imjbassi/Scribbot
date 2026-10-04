// Base calibration: Arduino Nano + PCA9685, base servo on channel 0.
// No extra libraries needed. Serial Monitor at 115200 baud, "Newline".
//
// Commands:
//   c        go to center (1500 us)
//   +  / -   nudge 10 us
//   1400     go to a pulse width in us (limited to 600-2400)
//   r        repeatability run: 10 approaches from each side, 4 s pause at center
//   o        outputs off (servo goes limp)
//   ?        show status
//
// Outputs stay OFF at startup until you send a command.
// Every move steps 10 us every 25 ms, so the platform turns slowly.

#include <Wire.h>

const uint8_t PCA_ADDR = 0x40;
const uint8_t CHANNEL = 0;
const int MIN_US = 600;
const int MAX_US = 2400;
const int CENTER_US = 1500;
const int NUDGE_US = 10;
const int REPEAT_OFFSET_US = 200;
const int REPEAT_CYCLES = 10;
const unsigned long REPEAT_DWELL_MS = 4000;

int currentUs = -1;  // -1 = output off

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
  Serial.println(F("Output OFF (servo limp)."));
}

void writeUs(int us) {
  // 50 Hz frame = 20000 us split into 4096 ticks.
  uint16_t ticks = (uint32_t)us * 4096UL / 20000UL;
  setChannelTicks(CHANNEL, 0, ticks);
  currentUs = us;
}

// Returns false if a key was pressed during the move (abort).
bool moveTo(int target, bool report = true) {
  target = constrain(target, MIN_US, MAX_US);
  if (currentUs < 0) {
    writeUs(target);  // unknown start: one jump
  } else {
    while (currentUs != target) {
      if (Serial.available()) return false;
      int step = constrain(target - currentUs, -NUDGE_US, NUDGE_US);
      writeUs(currentUs + step);
      delay(25);
    }
  }
  if (report) {
    Serial.print(F("Pulse = "));
    Serial.print(currentUs);
    Serial.println(F(" us"));
  }
  return true;
}

// Returns false if a key was pressed during the wait.
bool waitMs(unsigned long ms) {
  unsigned long start = millis();
  while (millis() - start < ms) {
    if (Serial.available()) return false;
  }
  return true;
}

void repeatabilityRun() {
  Serial.println(F("Repeatability run. Press Enter any time to stop."));
  if (!moveTo(CENTER_US, false) || !waitMs(REPEAT_DWELL_MS)) goto aborted;
  for (int side = 0; side < 2; side++) {
    int offset = side == 0 ? REPEAT_OFFSET_US : -REPEAT_OFFSET_US;
    for (int i = 1; i <= REPEAT_CYCLES; i++) {
      if (!moveTo(CENTER_US + offset, false)) goto aborted;
      if (!waitMs(500)) goto aborted;
      if (!moveTo(CENTER_US, false)) goto aborted;
      Serial.print(side == 0 ? F("PLUS side  #") : F("MINUS side #"));
      Serial.print(i);
      Serial.println(F("  -> read the ruler now"));
      if (!waitMs(REPEAT_DWELL_MS)) goto aborted;
    }
  }
  Serial.println(F("Repeatability run finished. Holding center."));
  return;
aborted:
  while (Serial.available()) Serial.read();
  Serial.print(F("Stopped. Holding "));
  Serial.print(currentUs);
  Serial.println(F(" us"));
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

  Serial.println(F("PCA9685 found. Commands: c, +, -, 600-2400, r, o, ?"));
}

void loop() {
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
  } else if (cmd == "r") {
    repeatabilityRun();
  } else if (cmd == "o") {
    outputOff();
  } else if (cmd == "?") {
    Serial.print(F("Current pulse: "));
    if (currentUs < 0) Serial.println(F("OFF"));
    else { Serial.print(currentUs); Serial.println(F(" us")); }
  } else if (isDigit(cmd.charAt(0))) {
    moveTo(cmd.toInt());
  } else {
    Serial.println(F("Unknown command. Use c, +, -, 600-2400, r, o, ?"));
  }
}
