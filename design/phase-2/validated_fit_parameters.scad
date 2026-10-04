// Physical coupon results 2026-09-24; Generic PLA, A1 mini profile,
// 0.4 mm nozzle, 0.12 mm layers, 0.20 mm first layer.
// These are fit parameters, not a complete or validated assembly.
servo_body_extra_total = 0.6;
mg90s_reference_body_xy = [22.8, 12.2];
mg996r_reference_body_xy = [40.7, 19.7];
mg90s_opening_xy = mg90s_reference_body_xy + [servo_body_extra_total,servo_body_extra_total];
mg996r_opening_xy = mg996r_reference_body_xy + [servo_body_extra_total,servo_body_extra_total];
bearing_625_bore_d = 16.3;
slider_clearance_per_side = 0.3; // user-selected coupon fit; validate final loaded guide
note_nominal_xy = [76.2,76.2]; // holder fit accepted; actual note size unmeasured
// User-selected mounting templates; nominal center spacings, not caliper precision.
mg90s_mount_pitch_a = 27; // M1
mg996r_mount_pitch_a = 49; // S2, lengthwise
mg996r_mount_pitch_b = 10; // S2, across each end tab

