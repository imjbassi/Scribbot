// Scribbot drawing program: Arduino Nano + PCA9685.
// Channel 0 = base, 1 = shoulder, 2 = elbow, 3 = wrist.
// Serial Monitor at 115200 baud, "Newline".
//
// Positions are in mm from the base axis: x = straight out, y = sideways, z = pen tip height.
// The pen always points straight down.
//
// Commands:
//   h       hover 25 mm above the middle of the note (do this first)
//   d  u    pen down / up 1 mm (D / U = 5 mm)
//   t       "the pen is touching the paper right now": saves this height
//   q       draw a 40 mm square          (q, c, s and w need t first)
//   c       draw a 40 mm circle
//   s       draw a star
//   wHI     write text: letters, numbers and spaces, up to 8 characters
//   m       text comes out mirrored? send m once to flip it
//   v       text comes out upside down? send v once to turn it
//   l  r    turn the whole drawing 1 degree left / right
//   ?       show position and pulses
//   o       all joints off (the arm DROPS: support it first)

#include <Wire.h>
#include <math.h>
#include <avr/pgmspace.h>

const uint8_t PCA_ADDR = 0x40;

// Geometry (mm), from calibration.
const float L1 = 120, L2 = 120;   // upper arm, forearm
const float SH_H = 127;           // shoulder axis above the table
const float PEN_D = 67;           // wrist axis to pen tip, straight down
const float PEN_E = 25;           // pen tip ahead of the wrist axis

// Note center and drawing sizes.
const float NOTE_X = 166, NOTE_Y = 0;
const float SIZE = 40;            // square side, circle diameter
const float TEXT_W = 50;          // text never wider than this
const float TEXT_H = 14;          // or taller than this
const float HOVER = 25;           // hover height above the paper
const float LIFT = 6;             // pen-up height while drawing
const float PRESS = 2;            // go this far below the paper (the holder slides up)

const int MIN_US[4] = {720, 700, 950, 880};
const int MAX_US[4] = {2280, 1550, 2200, 1700};

float px, py, pz;                 // current pen position
float paperZ = 0;                 // saved by t
bool paperSet = false;
bool armOn = false;
float baseTrim = 0;               // degrees, from l / r
bool mirrorText = false;          // m
bool flipText = false;            // v
int us[4];

// Stroke font on a 4 x 6 grid. Each point is two digits (x, y), y up.
// A space lifts the pen.
const char F_A[] PROGMEM = "0004264440 0343";
const char F_B[] PROGMEM = "00063645443303 3342413000";
const char F_C[] PROGMEM = "4536160501103041";
const char F_D[] PROGMEM = "00062644422000";
const char F_E[] PROGMEM = "40000646 0333";
const char F_F[] PROGMEM = "000646 0333";
const char F_G[] PROGMEM = "45361605011030414323";
const char F_H[] PROGMEM = "0006 4046 0343";
const char F_I[] PROGMEM = "1030 2026 1636";
const char F_J[] PROGMEM = "4641301001";
const char F_K[] PROGMEM = "0006 4603 1440";
const char F_L[] PROGMEM = "060040";
const char F_M[] PROGMEM = "0006234640";
const char F_N[] PROGMEM = "00064046";
const char F_O[] PROGMEM = "100105163645413010";
const char F_P[] PROGMEM = "00063645443303";
const char F_Q[] PROGMEM = "100105163645413010 2240";
const char F_R[] PROGMEM = "00063645443303 3340";
const char F_S[] PROGMEM = "453616050413334241301001";
const char F_T[] PROGMEM = "0646 2620";
const char F_U[] PROGMEM = "060110304146";
const char F_V[] PROGMEM = "062046";
const char F_W[] PROGMEM = "0600234046";
const char F_X[] PROGMEM = "0046 0640";
const char F_Y[] PROGMEM = "062346 2320";
const char F_Z[] PROGMEM = "06460040";
const char F_0[] PROGMEM = "100105163645413010 0541";
const char F_1[] PROGMEM = "152620 1030";
const char F_2[] PROGMEM = "05163645440040";
const char F_3[] PROGMEM = "05163645443313 334241301001";
const char F_4[] PROGMEM = "30360242";
const char F_5[] PROGMEM = "460603334241301001";
const char F_6[] PROGMEM = "4536160501103041423303";
const char F_7[] PROGMEM = "064620";
const char F_8[] PROGMEM = "13040516364544331302011030414233";
const char F_9[] PROGMEM = "4313040516364541301001";
const char* const LETTERS[26] PROGMEM = {F_A, F_B, F_C, F_D, F_E, F_F, F_G, F_H, F_I, F_J, F_K, F_L, F_M,
                                         F_N, F_O, F_P, F_Q, F_R, F_S, F_T, F_U, F_V, F_W, F_X, F_Y, F_Z};
const char* const DIGITS[10] PROGMEM = {F_0, F_1, F_2, F_3, F_4, F_5, F_6, F_7, F_8, F_9};

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

void writeUs(uint8_t ch, int u) {
  setChannelTicks(ch, 0, (uint32_t)u * 4096UL / 20000UL);
}

void allOff() {
  for (uint8_t ch = 0; ch < 4; ch++) setChannelTicks(ch, 0, 0x1000);
  armOn = false;
}

// Pen position -> pulses. Returns false if out of reach or past a joint limit.
bool solve(float x, float y, float z, int out[4]) {
  float r = sqrt(x * x + y * y);
  float base = atan2(y, x) * 180 / M_PI + baseTrim;
  float rw = r - PEN_E, zw = z + PEN_D - SH_H;
  float dd = sqrt(rw * rw + zw * zw);
  float c = (dd * dd - L1 * L1 - L2 * L2) / (2 * L1 * L2);
  if (c < -1 || c > 1) return false;
  float elbow = -acos(c) * 180 / M_PI;
  float shoulder = (atan2(zw, rw) + acos(dd / (L1 + L2))) * 180 / M_PI;
  float wrist = -90 - shoulder - elbow;

  out[0] = 1500 + 22.2 * base;
  out[1] = 1495 - 13.9 * shoulder;
  out[2] = 1500 - 10.7 * (elbow + 58.5);
  out[3] = 1450 - 10.2 * (wrist + 56.2);
  for (uint8_t j = 0; j < 4; j++) if (out[j] < MIN_US[j] || out[j] > MAX_US[j]) return false;
  return true;
}

void report() {
  Serial.print(F("pen x=")); Serial.print(px, 1);
  Serial.print(F(" y=")); Serial.print(py, 1);
  Serial.print(F(" z=")); Serial.print(pz, 1);
  if (paperSet) { Serial.print(F("  (paper z=")); Serial.print(paperZ, 1); Serial.print(')'); }
  Serial.print(F("   b s e w = "));
  for (uint8_t j = 0; j < 4; j++) { Serial.print(us[j]); Serial.print(' '); }
  Serial.println();
}

// Straight line to (x, y, z) in 1 mm steps.
bool lineTo(float x, float y, float z) {
  float dx = x - px, dy = y - py, dz = z - pz;
  int steps = max(1, (int)ceil(sqrt(dx * dx + dy * dy + dz * dz)));
  int t[4];
  for (int i = 1; i <= steps; i++) {
    float f = (float)i / steps;
    if (!solve(px + dx * f, py + dy * f, pz + dz * f, t)) {
      Serial.println(F("Out of reach. Stopped."));
      return false;
    }
    for (uint8_t j = 0; j < 4; j++) { us[j] = t[j]; writeUs(j, t[j]); }
    delay(20);
  }
  px = x; py = y; pz = z;
  return true;
}

// Pen up, travel to (x, y), pen down.
bool penTo(float x, float y) {
  float up = paperZ + LIFT;
  return lineTo(px, py, up) && lineTo(x, y, up) && lineTo(x, y, paperZ - PRESS);
}

// Draw (pen already down) to (x, y).
bool drawTo(float x, float y) {
  return lineTo(x, y, paperZ - PRESS);
}

void finish(const __FlashStringHelper* msg) {
  lineTo(px, py, paperZ + LIFT);
  lineTo(NOTE_X, NOTE_Y, paperZ + LIFT);
  Serial.println(msg);
}

// First move from off: one joint at a time, shoulder first so the arm lifts.
void powerOn(float x, float y, float z) {
  int t[4];
  if (!solve(x, y, z, t)) { Serial.println(F("Hover point out of reach.")); return; }
  const uint8_t order[4] = {1, 2, 3, 0};
  for (uint8_t k = 0; k < 4; k++) {
    uint8_t j = order[k];
    us[j] = t[j];
    writeUs(j, t[j]);
    delay(700);
  }
  px = x; py = y; pz = z;
  armOn = true;
}

void square() {
  float h = SIZE / 2;
  float cx[5] = {NOTE_X - h, NOTE_X + h, NOTE_X + h, NOTE_X - h, NOTE_X - h};
  float cy[5] = {NOTE_Y - h, NOTE_Y - h, NOTE_Y + h, NOTE_Y + h, NOTE_Y - h};
  if (!penTo(cx[0], cy[0])) return;
  for (uint8_t i = 1; i < 5; i++) if (!drawTo(cx[i], cy[i])) return;
  finish(F("Square done."));
}

void circle() {
  float rad = SIZE / 2;
  if (!penTo(NOTE_X + rad, NOTE_Y)) return;
  for (int i = 1; i <= 72; i++) {
    float a = i * 2 * M_PI / 72;
    if (!drawTo(NOTE_X + rad * cos(a), NOTE_Y + rad * sin(a))) return;
  }
  finish(F("Circle done."));
}

void star() {
  float rad = SIZE / 2 + 2;
  for (int i = 0; i <= 5; i++) {
    float a = (i * 2 % 5) * 2 * M_PI / 5;   // every second point: 0, 2, 4, 1, 3, 0
    float x = NOTE_X - rad * cos(a), y = NOTE_Y + rad * sin(a);
    if (i == 0 ? !penTo(x, y) : !drawTo(x, y)) return;
  }
  finish(F("Star done."));
}

// Text. The reader's "up" on the paper points toward the base (-x), "right" is +y.
// m and v flip these if the test comes out wrong.
void textPoint(float gx, float gy, float u, float left, float bottom, float& x, float& y) {
  float right = left + gx * u, up = bottom + gy * u;   // mm in the reader's frame, centered on the note
  if (flipText) { right = -right; up = -up; }
  if (mirrorText) right = -right;
  x = NOTE_X - up;
  y = NOTE_Y + right;
}

void writeText(String s) {
  s.toUpperCase();
  int n = s.length();
  if (n == 0 || n > 8) { Serial.println(F("Use 1 to 8 characters, like wHI")); return; }
  // Each character is 4 units wide plus 2 units of gap; 6 units tall.
  float u = min(TEXT_H / 6, TEXT_W / (6 * n - 2));
  float left = -(6 * n - 2) * u / 2, bottom = -3 * u;
  char buf[40];
  for (int k = 0; k < n; k++) {
    char ch = s.charAt(k);
    const char* p = nullptr;
    if (ch >= 'A' && ch <= 'Z') p = (const char*)pgm_read_ptr(&LETTERS[ch - 'A']);
    else if (ch >= '0' && ch <= '9') p = (const char*)pgm_read_ptr(&DIGITS[ch - '0']);
    if (p) {
      strncpy_P(buf, p, sizeof(buf) - 1);
      buf[sizeof(buf) - 1] = 0;
      bool penDown = false;
      for (int i = 0; buf[i]; ) {
        if (buf[i] == ' ') { penDown = false; i++; continue; }
        float x, y;
        textPoint(buf[i] - '0', buf[i + 1] - '0', u, left + k * 6 * u, bottom, x, y);
        if (!(penDown ? drawTo(x, y) : penTo(x, y))) return;
        penDown = true;
        i += 2;
      }
    }
  }
  finish(F("Text done."));
}

void setup() {
  Serial.begin(115200);
  Wire.begin();
  delay(200);
  Wire.beginTransmission(PCA_ADDR);
  if (Wire.endTransmission() != 0) {
    Serial.println(F("PCA9685 NOT found at 0x40. Check VCC, GND, SDA->A4, SCL->A5."));
    while (true) {}
  }
  writeReg(0x00, 0x10);
  writeReg(0xFE, 121);
  writeReg(0x00, 0x20);
  delay(1);
  writeReg(0x00, 0xA0);
  allOff();
  Serial.println(F("SCRIBBOT DRAW. Start with h (hover). Then d / u, t, then q c s or wHI."));
}

void loop() {
  if (!Serial.available()) return;
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  if (cmd.length() == 0) return;
  char c = cmd.charAt(0);

  if (c == 'o') { allOff(); Serial.println(F("ALL joints OFF.")); return; }
  if (c == 'm') { mirrorText = !mirrorText; Serial.println(mirrorText ? F("Text mirror ON.") : F("Text mirror OFF.")); return; }
  if (c == 'v') { flipText = !flipText; Serial.println(flipText ? F("Text turned 180.") : F("Text normal.")); return; }
  if (c == 'h') {
    float z = (paperSet ? paperZ : 0) + HOVER;
    if (!armOn) powerOn(NOTE_X, NOTE_Y, z);
    else lineTo(NOTE_X, NOTE_Y, z);
    report();
    return;
  }
  if (!armOn) { Serial.println(F("Arm is off. Send h first.")); return; }
  if ((c == 'q' || c == 'c' || c == 's' || c == 'w') && !paperSet) { Serial.println(F("Do t first.")); return; }

  switch (c) {
    case 'd': lineTo(px, py, pz - 1); break;
    case 'D': lineTo(px, py, pz - 5); break;
    case 'u': lineTo(px, py, pz + 1); break;
    case 'U': lineTo(px, py, pz + 5); break;
    case 't':
      paperZ = pz; paperSet = true;
      Serial.println(F("Paper height saved."));
      lineTo(px, py, pz + LIFT);
      break;
    case 'q': square(); break;
    case 'c': circle(); break;
    case 's': star(); break;
    case 'w': writeText(cmd.substring(1)); break;
    case 'l': case 'r': {
      float old = baseTrim;
      baseTrim += (c == 'l') ? -1 : 1;
      if (!lineTo(px, py, pz)) baseTrim = old;
      break;
    }
    case '?': break;
    default: Serial.println(F("Commands: h d u D U t q c s wTEXT m v l r ? o")); return;
  }
  report();
}
