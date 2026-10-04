// Arm joint test: Arduino Nano + PCA9685.
// Channel 0 = base (b), channel 1 = shoulder (s), channel 2 = elbow (e).
// No extra libraries needed. Serial Monitor at 115200 baud, "Newline".
//
// Commands (joint letter first):
//   e1500    move the elbow to 1500 us      (also b1500, s1500)
//   e+  e-   nudge the elbow 10 us          (also b+, b-, s+, s-)
//   eo       elbow off / limp               (also bo, so)
//   o        ALL joints off (the arm DROPS: support it first)
//   ?        show every joint
//
// All outputs stay OFF at startup until you command a joint.
// Every move steps 10 us every 25 ms, so joints move slowly.

#include <Wire.h>

const uint8_t PCA_ADDR = 0x40;
const uint8_t JOINTS = 3;
const char JOINT_KEY[JOINTS] = {'b', 's', 'e'};
const char* const JOINT_NAME[JOINTS] = {"base", "shoulder", "elbow"};
const int MIN_US[JOINTS] = {720, 700, 950};   // elbow kept inside the collision-checked fold range
const int MAX_US[JOINTS] = {2280, 1550, 2050};  // shoulder: 1500 = level, lower = up, so stop just below level
const int NUDGE_US = 10;

int currentUs[JOINTS] = {-1, -1, -1};  // -1 = output off

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

void jointOff(uint8_t j) {
  setChannelTicks(j, 0, 0x1000);  // full-off bit
  currentUs[j] = -1;
}

void writeUs(uint8_t j, int us) {
  // 50 Hz frame = 20000 us split into 4096 ticks.
  uint16_t ticks = (uint32_t)us * 4096UL / 20000UL;
  setChannelTicks(j, 0, ticks);
  currentUs[j] = us;
}

void report(uint8_t j) {
  Serial.print(JOINT_NAME[j]);
  Serial.print(F(" = "));
  if (currentUs[j] < 0) Serial.println(F("OFF"));
  else { Serial.print(currentUs[j]); Serial.println(F(" us")); }
}

void moveTo(uint8_t j, int target) {
  target = constrain(target, MIN_US[j], MAX_US[j]);
  if (currentUs[j] < 0) {
    writeUs(j, target);  // unknown start: one jump. Support the arm.
  } else {
    while (currentUs[j] != target) {
      int step = constrain(target - currentUs[j], -NUDGE_US, NUDGE_US);
      writeUs(j, currentUs[j] + step);
      delay(25);
    }
  }
  report(j);
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
  for (uint8_t j = 0; j < JOINTS; j++) jointOff(j);

  Serial.println(F("ARM TEST. b = base, s = shoulder, e = elbow."));
  Serial.println(F("Examples: e1500   s+   bo   o (all off)   ?"));
}

void loop() {
  if (!Serial.available()) return;
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  if (cmd.length() == 0) return;

  if (cmd == "o") {
    for (uint8_t j = 0; j < JOINTS; j++) jointOff(j);
    Serial.println(F("ALL joints OFF."));
    return;
  }
  if (cmd == "?") {
    for (uint8_t j = 0; j < JOINTS; j++) report(j);
    return;
  }

  int8_t joint = -1;
  for (uint8_t j = 0; j < JOINTS; j++) if (cmd.charAt(0) == JOINT_KEY[j]) joint = j;
  String arg = cmd.substring(1);
  if (joint < 0 || arg.length() == 0) {
    Serial.println(F("Start with b, s or e. Examples: e1500  s+  bo  o  ?"));
    return;
  }

  if (arg == "o") {
    jointOff(joint);
    report(joint);
  } else if (arg == "+" || arg == "-") {
    if (currentUs[joint] < 0) {
      Serial.println(F("That joint is off. Send a pulse first, like e1500."));
    } else {
      moveTo(joint, currentUs[joint] + (arg == "+" ? NUDGE_US : -NUDGE_US));
    }
  } else if (isDigit(arg.charAt(0))) {
    moveTo(joint, arg.toInt());
  } else {
    Serial.println(F("Use a number, +, - or o after the joint letter."));
  }
}
