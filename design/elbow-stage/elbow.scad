// Elbow stage: short upper arm (two cheeks) + elbow bracket carrying the second MG996R.
// The existing 120 mm test lever becomes the forearm.
// Frame: origin on the SHOULDER axis. X runs along the upper arm, Y is the joint-axis direction,
// Z is across the arm. The elbow axis is at X = L1, parallel to Y. Millimeters.
// The elbow repeats the shoulder's Y stack: tab wall, servo, horn, hub on +Y; back wall, bearing, cap on -Y.
use <../shoulder-stage/shoulder.scad>
use <../shoulder-horn-fit/shoulder_hub.scad>

part="assembly";
shoulder_angle=45;       // upper arm above horizontal, preview only
elbow_angle=-90;         // forearm relative to the upper arm (0 = straight), preview only
show="";                 // exploded view: "" = everything, or one part name
ex=22;
$fn=64;

L1=120;                  // shoulder axis to elbow axis
H_s=47.6;                // shoulder axis above the platform (from shoulder.scad)
// Y stack, same numbers as shoulder.scad
yb=-11.25; case_h=37; d_tab=28.5; hub_bot=44.5; spline_top=42.9;
body=[40.7,19.7]; fit=0.6; shaft_to_front=10.35;
body_cx=shaft_to_front-body[0]/2;
tab_t=5; y_tab_top=yb+d_tab; y_tab_bot=y_tab_top-tab_t;
y_back_in=yb-3; back_t=8; y_back_out=y_back_in-back_t;
hsg_t=9; cap_t=2; y_hsg_out=y_back_out-hsg_t; y_cap_out=y_hsg_out-cap_t;
y_a_in=yb+hub_bot+7; y_b_in=-y_a_in; cheek_t=5; span=y_a_in-y_b_in;
// Bracket
wall_h=17.5;             // half height of the walls and end plate (Z)
ep_x0=57; ep_x1=69;      // end plate, 12 mm thick, bolts between the two upper-arm cheeks
ep_xc=(ep_x0+ep_x1)/2; ep_hole_z=10;

module e_hole(x,z,d,y0,y1){ translate([x,y1+1,z]) rotate([90,0,0]) cylinder(d=d,h=y1-y0+2); }

// ---------------- Elbow bracket (one print, end plate flat on the bed, walls standing up) ----------------
module bracket(){
  difference(){
    union(){
      translate([ep_x0,y_b_in,-wall_h]) cube([ep_x1-ep_x0,span,2*wall_h]);                         // end plate
      translate([ep_x1-1,y_tab_bot,-wall_h]) cube([L1+22-ep_x1+1,tab_t,2*wall_h]);                // tab wall
      translate([ep_x1-1,y_back_out,-wall_h]) cube([L1+19-ep_x1+1,back_t,2*wall_h]);              // back wall
      translate([ep_x1-1,y_back_in-1,-wall_h]) cube([L1+19-ep_x1+1,y_tab_bot-y_back_in+2,3]);     // floor
    }
    // Servo window and tab holes (accepted fits: body +0.6, tab holes 49 x 10)
    translate([L1+body_cx-(body[0]+fit)/2,y_tab_bot-1,-(body[1]+fit)/2]) cube([body[0]+fit,tab_t+2,body[1]+fit]);
    for(sx=[-1,1],sz=[-1,1]) e_hole(L1+body_cx+sx*24.5,sz*5,3.4,y_tab_bot,y_tab_top);
    // Back wall: clearance for the M5 head, pilot holes for the housing screws
    e_hole(L1,0,16,y_back_out,y_back_in);
    for(sx=[-1,1],sz=[-1,1]) e_hole(L1+sx*12,sz*12,2.8,y_back_out,y_back_in);
    // End plate: M3 into each end (15 deep) with a nut slot open to the elbow-side face
    for(sz=[-1,1],e=[-1,1]) {
      translate([ep_xc,e*y_a_in,sz*ep_hole_z]) rotate([90,0,0]) cylinder(d=3.4,h=30,center=true);
      translate([ep_xc-3.1,(e>0?y_a_in-9.8:y_b_in+7),sz*ep_hole_z-3.1]) cube([20,2.8,6.2]);
    }
    // Lightening / cable window through the end plate, between the walls
    translate([ep_x0-1,-11,-10]) cube([ep_x1-ep_x0+2,20,22]);
  }
}

// ---------------- Upper-arm cheeks (print flat) ----------------
module cheek_end2d(){ translate([ep_xc,0]) offset(r=3) square([12,2*wall_h-9],center=true); }
module upper_cheek_a_flat(){
  linear_extrude(cheek_t) difference(){
    hull(){ circle(r=24); cheek_end2d(); }
    circle(d=10);                                                     // center-screw access
    for(a=[45,135,225,315]) rotate(a) translate([17,0]) circle(d=3.4); // hub screws
    for(sz=[-1,1]) translate([ep_xc,sz*ep_hole_z]) circle(d=3.4);     // end plate screws
  }
}
module upper_cheek_b_flat(){
  linear_extrude(cheek_t) difference(){
    hull(){ circle(r=9); cheek_end2d(); }
    circle(d=5.4);                                                    // M5 stub axle
    for(sz=[-1,1]) translate([ep_xc,sz*ep_hole_z]) circle(d=3.4);
  }
}

// ---------------- Placement ----------------
module e_servo(gold=false){
  color([.15,.15,.15]) {
    translate([L1+body_cx-body[0]/2,yb,-body[1]/2]) cube([body[0],case_h,body[1]]);
    translate([L1+body_cx-27,y_tab_top,-body[1]/2]) cube([54,2.5,body[1]]);
  }
  color(gold?"gold":[.15,.15,.15]) translate([L1,yb,0]) rotate([-90,0,0]) cylinder(d=6,h=spline_top);
}
module cheek_a_placed(){ translate([0,y_a_in+cheek_t,0]) rotate([90,0,0]) upper_cheek_a_flat(); }
module cheek_b_placed(){ translate([0,y_b_in,0]) rotate([90,0,0]) upper_cheek_b_flat(); }
module e_housing(){ translate([L1,y_back_out,0]) rotate([90,0,0]) housing_flat(); }
module e_cap(){ translate([L1,y_hsg_out,0]) rotate([90,0,0]) cap_flat(); }
module upper_arm_fixed(){ cheek_a_placed(); cheek_b_placed(); bracket(); e_housing(); e_cap(); e_servo(); }
module forearm(e){ translate([L1,0,-H_s]) lever(e); }                 // the existing test lever
module e_hub(e){ translate([L1,0,-H_s]) hub_placed(e); }

module arm(sa,e){
  translate([0,0,H_s]) rotate([0,-sa,0]) {
    color("#e08a12") { cheek_a_placed(); cheek_b_placed(); }
    color("#c0504d") bracket();
    color("lightblue") { e_housing(); e_cap(); }
    e_servo();
    e_hub(e);
    color("#f4a236") forearm(e);
  }
}

// ---------------- Exploded construction view (upper arm horizontal, forearm straight) ----------------
module vis2(n){ if(show==""||show==n) children(); }
module ycyl2(x,y0,len,d){ translate([x,y0,0]) rotate([-90,0,0]) cylinder(d=d,h=len); }
module yann(x,y0,len,od,id){ translate([x,y0,0]) rotate([-90,0,0]) difference(){ cylinder(d=od,h=len); translate([0,0,-1]) cylinder(d=id,h=len+2); } }
module exploded(){
  vis2("context") { color("#c9d3dd") { translate([0,0,-5]) cylinder(r=40,h=5); carrier(); housing_placed(); cap_placed(); translate([0,yb+hub_bot,H_s]) rotate([-90,0,0]) hub(); } servo_env(); }
  translate([0,0,H_s]) {
    vis2("u_cheek_a") color("#e08a12") translate([0,ex*1.6,0]) cheek_a_placed();
    vis2("u_cheek_b") color("#e08a12") translate([0,-ex*1.2,0]) cheek_b_placed();
    vis2("bracket") color("#c0504d") bracket();
    vis2("e_servo") translate([0,ex*1.3,0]) e_servo(true);
    vis2("e_horn") color("#eeeeee") translate([L1,ex*2.1+yb+hub_bot-2.7,0]) rotate([-90,0,0])
      difference(){ hull(){ for(x=[-18.5,18.5]) translate([x,0,0]) cylinder(d=5,h=2.7); } translate([0,0,-1]) cylinder(d=2.5,h=5); }
    vis2("e_hub") translate([0,ex*3.0,0]) e_hub(0);
    vis2("f_cheek_a") color("#f4a236") translate([L1,ex*4.2+y_a_in+cheek_t,0]) rotate([90,0,0]) cheek_a_flat();
    vis2("f_rungs") color("#f8b45a") translate([L1,0,0]) for(r=[45,82,120]) translate([r,y_b_in,-6]) rotate([0,0,90]) rung_flat();
    vis2("e_housing") color("lightblue") translate([0,-ex*1,0]) e_housing();
    vis2("e_bearing") translate([0,-ex*1.6,0]) { color("silver") yann(L1,y_hsg_out+0.2,5,16,8.5); color("#c8ccd0") yann(L1,y_hsg_out+0.2,5,8,5); }
    vis2("e_cap") color("#7fb3cc") translate([0,-ex*2.2,0]) e_cap();
    vis2("e_screws") color("#9aa3ad") translate([0,-ex*2.6,0]) for(sx=[-1,1],sz=[-1,1]) translate([L1+sx*12,y_cap_out,sz*12]) rotate([90,0,0]) { cylinder(d=3,h=20); cylinder(d=5.5,h=3); }
    vis2("e_spacers") color("#f6c27a") translate([0,-ex*3.0,0]) { yann(L1,y_cap_out-8,8,8,5.4); yann(L1,y_cap_out-9.2,1,8,5.4); }
    vis2("f_cheek_b") color("#f4a236") translate([L1,-ex*3.6+y_b_in,0]) rotate([90,0,0]) cheek_b_flat();
    vis2("e_nut") color("#9aa3ad") translate([0,-ex*4.2,0]) { yann(L1,y_b_in-cheek_t-1,1,10,5.3); translate([L1,y_b_in-cheek_t-1,0]) rotate([90,0,0]) cylinder(d=8.5,h=4,$fn=6); }
    vis2("e_bolt") color("#9aa3ad") translate([0,-ex*5.8,0]) { ycyl2(L1,y_back_out,5,8.5); ycyl2(L1,y_back_out-30,30,5); }
  }
}

if(part=="bracket") rotate([0,-90,0]) translate([-ep_x0,0,0]) bracket();   // end plate on the bed
else if(part=="cheek_a") upper_cheek_a_flat();
else if(part=="cheek_b") upper_cheek_b_flat();
else if(part=="assembly"){
  color("#dfe7ef") translate([0,0,-5]) cylinder(r=40,h=5);
  color("steelblue") carrier(); color("lightblue") { housing_placed(); cap_placed(); }
  servo_env(); hub_placed(shoulder_angle);
  arm(shoulder_angle,elbow_angle);
}
else if(part=="exploded") exploded();
else if(part=="collide_elbow") intersection(){ upper_arm_fixed(); union(){ forearm(elbow_angle); e_hub(elbow_angle); } }
else if(part=="collide_shoulder") intersection(){ static_parts(); translate([0,0,H_s]) rotate([0,-shoulder_angle,0]) { upper_arm_fixed(); forearm(elbow_angle); } }
