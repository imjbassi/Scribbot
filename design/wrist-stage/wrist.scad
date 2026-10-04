// Wrist stage: new lighter forearm, MG90S wrist-pitch bracket, and a gravity pen holder (tool).
// Frames (all millimeters):
//   forearm frame: origin on the ELBOW axis, x' along the forearm toward the wrist, y = joint-axis direction, z' across.
//   wrist frame:   forearm frame shifted by L2 along x' (origin on the WRIST axis).
//   tool frame:    rotates with the wrist servo; u = pen direction (toward the tip), v = pen offset direction.
// Pen: Sharpie, accepted bore 12.4 mm (pen-fit coupon). Tip 80 mm along u from the axis, axis offset 25 mm along v.
// Drawing keeps the pen vertical: shoulder + elbow + wrist = -90 degrees.
use <../shoulder-stage/shoulder.scad>
use <../shoulder-horn-fit/shoulder_hub.scad>
use <../elbow-stage/elbow.scad>

part="assembly";
sa=45; ea=-105; wa=-30;   // preview pose (degrees)
show=""; ex=22;
$fn=64;

L1=120; L2=120; H_s=47.6;
y_a_in=40.25; y_b_in=-40.25; cheek_t=5; span=y_a_in-y_b_in;
pen_d=12.4; pen_len=125; tip_u=80; off_v=25;

// MG90S (accepted: body +0.6, tab holes 27 mm). Shaft along +y. Body runs back along -x' from the shaft.
m_body=[22.8,12.2]; m_fit=0.6; m_shaft_to_front=6.0; m_case=22.7; m_tab=15.75; m_horn_top=30;
m_cx=m_shaft_to_front-m_body[0]/2;          // body center x' relative to the shaft (-5.4)
ys0=-20;                                    // servo bottom (y)
y_tw0=ys0+m_tab-4; y_tw1=ys0+m_tab;         // tab wall
y_bw1=ys0-4; y_bw0=y_bw1-4;                 // back wall (4 mm gap to the servo bottom)
y_hA=ys0+m_horn_top;                        // horn top face = arm A inner face
y_aA=y_hA+4;                                // arm A outer face (4 mm plate)
y_bB1=y_bw0-2; y_bB0=y_bB1-5;               // arm B (2 mm gap to the back wall)
sleeve_len=9;                               // pivot sleeve: back wall -> past arm B

// End plate (joins the two forearm cheeks), wrist frame
ep=[-40,-28]; ep_z=[-17,3]; ep_hz=[-12,-2];

module xz(y0,y1){ translate([0,y1,0]) rotate([90,0,0]) linear_extrude(y1-y0) children(); }
module yhole(x,z,d,y0,y1){ translate([x,y1+1,z]) rotate([90,0,0]) cylinder(d=d,h=y1-y0+2); }
module slot2d(r0,r1,w){ hull(){ translate([r0,0]) circle(d=w); translate([r1,0]) circle(d=w); } }

// ---------------- Wrist bracket (wrist frame). Prints with the end plate on the bed. ----------------
module wall2d(){ polygon([[ep[1]-1,ep_z[0]],[ep[1]-1,ep_z[1]],[-18,10],[13,10],[13,-10],[-8,-10],[-16,ep_z[0]]]); }
module wrist_bracket(){
  difference(){
    union(){
      translate([ep[0],y_b_in,ep_z[0]]) cube([ep[1]-ep[0],span,ep_z[1]-ep_z[0]]);
      xz(y_tw0,y_tw1) wall2d();
      xz(y_bw0,y_bw1) wall2d();
      translate([ep[1]-1,y_bw1-1,ep_z[0]]) cube([12,y_tw0-y_bw1+2,4]);            // floor rib between the walls
    }
    // MG90S window + 2 pilot holes for the servo's own tab screws
    translate([m_cx-(m_body[0]+m_fit)/2,y_tw0-1,-(m_body[1]+m_fit)/2]) cube([m_body[0]+m_fit,6,m_body[1]+m_fit]);
    for(s=[-1,1]) yhole(m_cx+s*13.5,0,2.0,y_tw0,y_tw1);
    // Pivot: slot along x' (+/-1.5) so it can line up with the real shaft, nut trap on the servo side
    xz(y_bw0-1,y_bw1+1) slot2d(-1.5,1.5,3.4);
    translate([0,y_bw1-2.6,0]) rotate([90,0,0]) translate([0,0,-2.6]) linear_extrude(2.7) hull(){ for(x=[-1.5,1.5]) translate([x,0]) circle(d=6.7,$fn=6); }
    // End plate: M3 into each end with nut slots open toward the elbow
    for(z=ep_hz,e=[-1,1]){
      translate([(ep[0]+ep[1])/2,e*y_a_in,z]) rotate([90,0,0]) cylinder(d=3.4,h=30,center=true);
      translate([ep[0]-1,(e>0?y_a_in-9.8:y_b_in+7),z-3.1]) cube([(ep[0]+ep[1])/2-ep[0]+1+3.1,2.8,6.2]);
    }
    translate([ep[0]-1,-6,ep_z[0]+4]) cube([14,12,10]);   // cable pass-through
  }
}

// ---------------- Forearm cheeks (print flat). Same elbow interfaces as the test arm. ----------------
fe_x=L2+(ep[0]+ep[1])/2;   // end-plate screw line, forearm frame (86)
module fa_end2d(){ translate([L2+ep[0]-2,ep_z[0]-2]) square([ep[1]-ep[0]+4,ep_z[1]-ep_z[0]+4]); }
module forearm_cheek_a_flat(){
  linear_extrude(cheek_t) difference(){
    hull(){ circle(r=24); fa_end2d(); }
    circle(d=10);
    for(a=[45,135,225,315]) rotate(a) translate([17,0]) circle(d=3.4);
    translate([45,0]) circle(d=3.4);
    for(z=ep_hz) translate([fe_x,z]) circle(d=3.4);
    offset(r=3) polygon([[58,-10],[72,-12],[72,0],[58,3]]);    // lightening window
  }
}
module forearm_cheek_b_flat(){
  linear_extrude(cheek_t) difference(){
    hull(){ circle(r=9); fa_end2d(); }
    circle(d=5.4);
    translate([45,0]) circle(d=3.4);
    for(z=ep_hz) translate([fe_x,z]) circle(d=3.4);
  }
}

// ---------------- Tool (pen holder) ----------------
blk_u=[28,52]; blk_v=[12,38];
module tool_arm_a_flat(){
  // On the MG90S horn: 4 radial slots (same pattern as the base gear) + center-screw access.
  difference(){
    linear_extrude(4) hull(){ circle(r=13); translate([blk_u[0],blk_v[0]]) square([blk_u[1]-blk_u[0],blk_v[1]-blk_v[0]]); }
    translate([0,0,-1]) cylinder(d=8,h=6);
    for(a=[0,90,180,270]) rotate([0,0,a]) {
      translate([0,0,-1]) linear_extrude(6) slot2d(7,11,2.2);
      translate([0,0,-1]) linear_extrude(3.5) slot2d(7,11,4.4);      // screw-head counterbore, open on the outer face
    }
    for(v=[15,35]) translate([40,v,-1]) cylinder(d=3.4,h=6);
  }
}
module teardrop(d,h){ linear_extrude(h,center=true) union(){ circle(d=d); rotate(135) square(d/2); } }   // teardrop point faces up when printed
module tool_body_flat(){
  // Arm B (on the bed) + pen block. Print with arm B down. Here: XY = (u,v), Z = -y measured from arm B outer face.
  zb=y_bB1-y_bB0; zh=y_hA-y_bB1;
  difference(){
    union(){
      linear_extrude(zb) hull(){ circle(r=8); translate([blk_u[0],blk_v[0]]) square([blk_u[1]-blk_u[0],blk_v[1]-blk_v[0]]); }
      translate([blk_u[0],blk_v[0],zb-0.01]) cube([blk_u[1]-blk_u[0],blk_v[1]-blk_v[0],zh+0.01]);
    }
    translate([0,0,-1]) cylinder(d=5.3,h=zb+2);                                   // rides on the pivot sleeve
    // Pen bore along u at v=off_v, y=0  ->  Z = -y_bB0 (distance from arm B outer face to y=0)
    translate([(blk_u[0]+blk_u[1])/2,off_v,-y_bB0]) rotate([0,90,0]) rotate([0,0,0]) teardrop(pen_d,blk_u[1]-blk_u[0]+2);
    // Arm A screws down into the block top, nut slots open to the long sides
    for(v=[15,35]) translate([40,v,zb+zh-12]) cylinder(d=3.4,h=13);
    for(v=[15,35]) translate([40-3.1,(v<25?blk_v[0]-1:v-3.2),zb+zh-7]) cube([6.2,(v<25?v-blk_v[0]+4.2:blk_v[1]-v+4.2),2.8]);
  }
}
module collar_flat(){
  difference(){
    union(){ cylinder(d=22,h=8); translate([9,-5,0]) cube([8,10,8]); }
    translate([0,0,-1]) cylinder(d=12.6,h=10);
    translate([0,0,4]) rotate([0,90,0]) cylinder(d=3.4,h=20);
    translate([12,-3.1,1.5]) cube([2.8,6.2,8]);
  }
}
module pivot_sleeve_flat(){ difference(){ cylinder(d=5,h=sleeve_len); translate([0,0,-1]) cylinder(d=3.4,h=sleeve_len+2); } }

// ---------------- Placement ----------------
module m_servo(gold=false){
  color([.12,.12,.12]) {
    translate([m_cx-m_body[0]/2,ys0,-m_body[1]/2]) cube([m_body[0],m_case,m_body[1]]);
    translate([m_cx-16,ys0+m_tab,-m_body[1]/2]) cube([32,2,m_body[1]]);
  }
  color(gold?"gold":[.12,.12,.12]) translate([0,ys0,0]) rotate([-90,0,0]) cylinder(d=4.8,h=m_horn_top-1.5);
  color("#eeeeee") translate([0,y_hA-1.55,0]) rotate([-90,0,0]) linear_extrude(1.5) hull(){ for(x=[-15,15]) translate([x,0]) circle(d=5); }
}
// tool frame -> wrist frame: u along x' rotated by wa; v = u + 90 deg
module in_tool(w){ rotate([0,-w,0]) children(); }
module uv_slab(y0,y1){ xz(y0,y1) children(); }   // 2D (u,v) -> (x',z')
module tool(w){
  in_tool(w){
    color("#5dade2") translate([0,y_aA,0]) rotate([90,0,0]) tool_arm_a_flat();
    color("#2e86c1") translate([0,y_bB0,0]) rotate([-90,0,0]) tool_body_print();   // rotation only: the printed part
  }
}
// The printable body. Its (u,v) layout is flipped in v so that a pure rotation puts it in place.
module tool_body_print(){ mirror([0,1,0]) tool_body_flat(); }
module pen_model(w){
  in_tool(w) translate([tip_u,0,off_v]) rotate([0,-90,0]) {
    color("#9aa0a6") translate([0,0,18]) cylinder(d=12.0,h=pen_len-18);
    color("#555") cylinder(d1=2,d2=12,h=18);
  }
}
module collar_placed(w){ in_tool(w) translate([blk_u[0]-8-0.5,0,off_v]) rotate([0,90,0]) color("#f4d03f") collar_flat(); }
module sleeve_placed(){ color("#f6c27a") translate([0,y_bw0,0]) rotate([90,0,0]) pivot_sleeve_flat(); }

module forearm2(w){
  color("#e08a12") {
    translate([0,y_a_in+cheek_t,0]) rotate([90,0,0]) forearm_cheek_a_flat();
    translate([0,y_b_in,0]) rotate([90,0,0]) forearm_cheek_b_flat();
  }
  color("#f8b45a") translate([45,y_b_in,-6]) rotate([0,0,90]) rung_flat();
  translate([L2,0,0]) {
    color("#c0504d") wrist_bracket();
    m_servo();
    sleeve_placed();
    tool(w);
    pen_model(w);
    collar_placed(w);
  }
}
module upper_arm(){ cheek_a_placed(); cheek_b_placed(); color("#c0504d") bracket(); color("lightblue") { e_housing(); e_cap(); } e_servo(); }
module arm2(s,e,w){
  translate([0,0,H_s]) rotate([0,-s,0]) {
    color("#e08a12") upper_arm();
    translate([L1,0,-H_s]) hub_placed(e);
    translate([L1,0,0]) rotate([0,-e,0]) forearm2(w);
  }
}

// Collision sets
module wrist_fixed(){ wrist_bracket(); m_servo(); sleeve_placed(); }
module tool_and_pen(w){ tool(w); pen_model(w); collar_placed(w); }
module forearm_body(){ translate([0,y_a_in+cheek_t,0]) rotate([90,0,0]) forearm_cheek_a_flat(); translate([0,y_b_in,0]) rotate([90,0,0]) forearm_cheek_b_flat();
  translate([45,y_b_in,-6]) rotate([0,0,90]) rung_flat(); translate([L2,0,0]) wrist_fixed(); }

// ---------------- Exploded construction view (forearm frame, forearm level, pen pointing down) ----------------
module vis3(n){ if(show==""||show==n) children(); }
module exploded(){
  w=-90;
  vis3("elbow") color("#c9d3dd") { translate([0,-H_s*0,0]) translate([0,0,-H_s]) hub_placed(0); }
  vis3("cheek_a") color("#e08a12") translate([0,ex*1.6,0]) translate([0,y_a_in+cheek_t,0]) rotate([90,0,0]) forearm_cheek_a_flat();
  vis3("cheek_b") color("#e08a12") translate([0,-ex*1.8,0]) translate([0,y_b_in,0]) rotate([90,0,0]) forearm_cheek_b_flat();
  vis3("rung") color("#f8b45a") translate([45,y_b_in,-6]) rotate([0,0,90]) rung_flat();
  translate([L2,0,0]) {
    vis3("bracket") color("#c0504d") wrist_bracket();
    vis3("servo") translate([0,ex*0.9,0]) m_servo(true);
    vis3("arm_a") color("#5dade2") translate([0,ex*2.7,0]) in_tool(w) translate([0,y_aA,0]) rotate([90,0,0]) tool_arm_a_flat();
    vis3("body") color("#2e86c1") translate([0,-ex*0.9,0]) in_tool(w) translate([0,y_bB0,0]) rotate([-90,0,0]) tool_body_print();
    vis3("sleeve") translate([0,-ex*2.6,0]) sleeve_placed();
    vis3("pivot_screw") color("#9aa3ad") translate([0,-ex*3.6,0]) translate([0,y_bw0-sleeve_len-0.5,0]) rotate([90,0,0]) { translate([0,0,-16]) cylinder(d=3,h=16); cylinder(d=5.5,h=3); }
    vis3("collar") translate([0,0,30]) collar_placed(w);
    vis3("pen") translate([0,0,62]) pen_model(w);
  }
}

if(part=="assembly"){
  color("#dfe7ef") translate([0,0,-5]) cylinder(r=40,h=5);
  color("steelblue") carrier(); color("lightblue") { housing_placed(); cap_placed(); }
  servo_env(); hub_placed(sa);
  arm2(sa,ea,wa);
}
else if(part=="wrist_closeup"){ wrist_fixed(); tool(wa); pen_model(wa); collar_placed(wa); }
else if(part=="collide_tool") intersection(){ wrist_fixed(); union(){ tool(wa); collar_placed(wa); } }
else if(part=="collide_pen") intersection(){ forearm_body(); translate([L2,0,0]) pen_model(wa); }
else if(part=="collide_forearm") intersection(){ upper_arm(); translate([L1,0,0]) rotate([0,-ea,0]) forearm_body(); }
else if(part=="collide_shoulder") intersection(){ static_parts(); translate([0,0,H_s]) rotate([0,-sa,0]) { upper_arm(); translate([L1,0,0]) rotate([0,-ea,0]) { forearm_body(); translate([L2,0,0]) { tool(wa); pen_model(wa); collar_placed(wa); } } } }
else if(part=="collide_table") intersection(){
  translate([-500,-500,-1000]) cube([1000,1000,1000-67.4+(-0.5)]);   // everything below the table top (platform frame: table at z=-67.4)
  translate([0,0,H_s]) rotate([0,-sa,0]) { upper_arm(); translate([L1,0,0]) rotate([0,-ea,0]) { forearm_body(); translate([L2,0,0]) { tool(wa); collar_placed(wa); } } }
}
else if(part=="exploded") exploded();
else if(part=="after") {
  color("#e9e2d0") translate([-95,-115,-71.4]) cube([330,230,4]);
  color("#f7e36b") translate([127,-38,-67.4]) cube([76,76,0.6]);
  color("#dfe7ef") translate([0,0,-5]) cylinder(r=40,h=5);
  color("steelblue") carrier(); color("lightblue") { housing_placed(); cap_placed(); }
  servo_env(); hub_placed(sa);
  arm2(sa,ea,wa);
}

else if(part=="wrist_bracket") rotate([0,-90,0]) translate([-ep[0],0,0]) wrist_bracket();   // end plate on the bed
else if(part=="forearm_cheek_a") forearm_cheek_a_flat();
else if(part=="forearm_cheek_b") forearm_cheek_b_flat();
else if(part=="tool_arm_a") translate([0,0,4]) rotate([180,0,0]) tool_arm_a_flat();   // counterbores face up
else if(part=="tool_body") tool_body_print();
else if(part=="tool_body_old") tool_body_flat();
else if(part=="collar") collar_flat();
else if(part=="pivot_sleeve") pivot_sleeve_flat();
