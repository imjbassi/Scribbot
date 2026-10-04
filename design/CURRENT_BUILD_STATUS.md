# Current build status — 3 October 2026

Elbow stage PASSED per user (3 Oct): assembled, forearm sits at a right angle on e1500, moves smoothly. Elbow direction: LOWER pulse (e1400) swings the forearm forward/up, toward straight. Base, shoulder and elbow are all built and driven by arm_test.ino.

Pen fit: Sharpie Fine slides best in the 12.4 mm ring (user, 3 Oct).

Current action: wrist-stage/START_HERE.md. New forearm (cheeks 12/13 + one old rung), MG90S wrist bracket (14) bolted between the cheek ends, pen holder (15 arm A on the horn, 16 body with a 12.4 teardrop bore riding on an M3 pivot + printed sleeve 18), collar (17). Tool geometry: pen tip 80 mm from the wrist axis along the pen, pen axis offset 25 mm forward. IK with L1=L2=120, shoulder 115 mm above the table: drawing patch (r 135-197, z 0-25) needs shoulder 32-57 deg, elbow -87 to -125, wrist -11 to -42. CAD checks: tool clear -75..+45, pen clear -75..+15, forearm vs upper arm clear +20..-125 (contact at -140), drawing poses clear of mount and table. Wrist on channel 3; arm_test.ino (wrist-stage) limits wrist to 1350-1650 and elbow to 1900 max. Power: user keeps the 3 A adapter for now; upgrade to 5 V 10 A if the terminal sags below 4.8 V or when the gripper servo is added.

Shoulder stage PASSED per user (2 Oct): assembled, moves smoothly, shoulder center (1500 us) = arm straight forward (horizontal), load test "all good" through 345 g at 120 mm (about 4.6 kgf cm with the lever). Shoulder direction: LOWER pulse raises the arm (1400 = up). arm_test.ino limits the shoulder to 700-1550 us. Servo temperature and supply voltage under load were not reported.

Current action: elbow-stage/START_HERE.md. New prints: 09 elbow bracket, 10/11 upper-arm cheeks, plus one more each of 01 hub, 03 housing, 04 cap, 08 spacers. The 120 mm test lever moves to the elbow and becomes the forearm. Elbow repeats the shoulder Y stack on a bracket bolted between two short upper-arm cheeks; elbow axis 120 mm from the shoulder axis. Elbow servo on PCA9685 channel 2. arm_test.ino drives b/s/e (channels 0/1/2); elbow limited to 950-2050 us.

CAD checks: forearm vs upper arm clear for elbow +20 to -140 deg (collision confirmed at 180 as a control); arm vs shoulder carrier clear for shoulder 0-120 deg. Not checked: base/motor/table, cables. Bracket is about 59 cm3 (roughly 35 g at 3 walls / 20 %); with the heavy test lever as forearm the shoulder torque at the working extreme is about equal to the tested load, so a lighter forearm is planned with the wrist stage.

Earlier results still stand: base calibrated (1500 us center, about 22.2 us per platform degree, +/-35 deg = 720/2280 us), supply 5.48 V unloaded, threaded M5 turntable axle kept by user choice.

Still pending: wrist pitch, wrist roll (optional), gripper, pen cartridge + dock, lighter forearm, camera stand, full-arm power supply sizing (three+ servos on a 3 A adapter is marginal), OE/startup-safety wiring, software.