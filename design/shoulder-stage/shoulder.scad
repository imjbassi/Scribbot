// Shoulder stage: MG996R carrier on the rotating platform + load-test lever.
// Frame: origin = base axis at the platform top. Arm plane = XZ (y=0). Shoulder axis runs along Y.
// Millimeters. Accepted fits: MG996R body +0.6, tab holes 49 x 10, bearing pocket 16.3.
use <../shoulder-horn-fit/shoulder_hub.scad>

part="assembly";
lever_angle=45;          // degrees above horizontal, preview only
$fn=64;

H=47.6;                  // shoulder axis above platform top (115 mm above the board)
// MG996R envelope. Shaft is the origin of the servo; body runs back along -X.
shaft_to_front=10.35;    // shaft center to front end face (photo estimate ~9-10)
body=[40.7,19.7];        // length (X), width (Z)
fit=0.6;                 // accepted total clearance
yb=-11.25;               // servo bottom face (Y)
d_tab=28.5;              // servo bottom to underside of mounting tabs (estimate)
case_h=37;               // servo bottom to case top (estimate)
spline_top=42.9;         // published overall height
hub_bot=44.5;            // servo bottom to horn top face (estimate)
body_cx=shaft_to_front-body[0]/2;   // body center X relative to shaft (-10)
tab_dx=24.5; tab_dz=5;   // accepted S2 pattern 49 x 10

// Carrier walls
tab_t=5;  y_tab_top=yb+d_tab; y_tab_bot=y_tab_top-tab_t;
back_gap=3; back_t=8; y_back_in=yb-back_gap; y_back_out=y_back_in-back_t;
plate_t=6;
// Bearing stack (tested 34 x 34 housing geometry)
hsg_t=9; y_hsg_out=y_back_out-hsg_t;
cap_t=2; y_cap_out=y_hsg_out-cap_t;
// Lever
y_a_in=yb+hub_bot+7;     // cheek A sits on the hub top face
y_b_in=-y_a_in;          // cheek B mirrors it about the arm plane
cheek_t=5;
rung_r=[45,82,120];
rung_s=12;
span=y_a_in-y_b_in;

module rrect(x0,x1,y0,y1,h,r=3){ linear_extrude(h) hull() for(x=[x0+r,x1-r],y=[y0+r,y1-r]) translate([x,y]) circle(r=r); }
// XZ-plane helpers: a solid occupying y in [y0,y1]
module yslab(y0,y1){ translate([0,y1,0]) rotate([90,0,0]) linear_extrude(y1-y0) children(); }
module yhole(x,z,d,y0,y1){ translate([x,y1+1,z]) rotate([90,0,0]) cylinder(d=d,h=y1-y0+2); }

// ---------------- Carrier (one print, base plate down) ----------------
module carrier(){
  difference(){
    union(){
      // Base plate bolted to the platform's four outer holes.
      rrect(-42,24,-31,31,plate_t);
      // Tab wall: servo body passes through, tabs bolt to its +Y face.
      yslab(y_tab_bot,y_tab_top) translate([-42,0]) square([64,H+18]);
      // Back wall: carries the bearing housing on its -Y face.
      yslab(y_back_out,y_back_in) translate([-24,0]) square([48,H+20]);
      // Gussets (kept low: clear of nuts, servo body and cable).
      for(x=[-42,19]) translate([x,y_back_in,0]) cube([3,y_tab_bot-y_back_in,24]);
      for(x=[-24,21]) translate([x,-31,0]) hull(){ cube([3,31+y_back_out,plate_t]); translate([0,31+y_back_out-1,0]) cube([3,1,26]); }
    }
    // Platform: M3 screws down through the plate, nuts under the platform.
    for(x=[-16,16],y=[-26,26]) translate([x,y,-1]) cylinder(d=3.4,h=plate_t+2);
    // Turntable bolt heads (pockets from below) and the axle nut stack.
    for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=10,h=4+1);
    translate([0,0,-1]) cylinder(d=16,h=plate_t+2);
    // Servo window and tab holes.
    translate([body_cx-(body[0]+fit)/2,y_tab_bot-1,H-(body[1]+fit)/2]) cube([body[0]+fit,tab_t+2,body[1]+fit]);
    for(sx=[-1,1],sz=[-1,1]) yhole(body_cx+sx*tab_dx,H+sz*tab_dz,3.4,y_tab_bot,y_tab_top);
    // Back wall: clearance for the stub bolt head, pilot holes for the housing screws.
    yhole(0,H,16,y_back_out,y_back_in);
    for(sx=[-1,1],sz=[-1,1]) yhole(sx*12,H+sz*12,2.8,y_back_out,y_back_in);
  }
}

// ---------------- Bearing housing + cap (print flat) ----------------
// Same pocket as the tested carrier, but 5.4 mm screw holes let it shift ~1 mm to line up with the servo shaft.
module housing_flat(){
  difference(){
    rrect(-17,17,-17,17,hsg_t);
    translate([0,0,-1]) cylinder(d=14.6,h=hsg_t+2);
    translate([0,0,hsg_t-5.2]) cylinder(d=16.3,h=6);
    for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=5.4,h=hsg_t+2);
  }
}
module cap_flat(){
  difference(){
    rrect(-17,17,-17,17,cap_t);
    translate([0,0,-1]) cylinder(d=14.6,h=cap_t+2);
    for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=5.4,h=cap_t+2);
  }
}

// ---------------- Test lever ----------------
module cheek_a_flat(){
  difference(){
    hull(){ circle_(24); translate([120,0,0]) circle_(8); }
    translate([0,0,-1]) cylinder(d=10,h=cheek_t+2);                          // center-screw access
    for(a=[45,135,225,315]) rotate([0,0,a]) translate([17,0,-1]) cylinder(d=3.4,h=cheek_t+2);
    for(r=rung_r) translate([r,0,-1]) cylinder(d=3.4,h=cheek_t+2);
  }
}
module cheek_b_flat(){
  difference(){
    hull(){ circle_(9); translate([120,0,0]) circle_(8); }
    translate([0,0,-1]) cylinder(d=5.4,h=cheek_t+2);                         // M5 stub bolt
    for(r=rung_r) translate([r,0,-1]) cylinder(d=3.4,h=cheek_t+2);
  }
}
module circle_(r){ cylinder(r=r,h=cheek_t); }
module rung_flat(){
  // Lies along X for printing. Axial M3 + side nut slot at each end. Hook hole in the middle.
  difference(){
    translate([0,-rung_s/2,0]) cube([span,rung_s,rung_s]);
    for(e=[0,1]) {
      translate([e*span,0,rung_s/2]) rotate([0,90,0]) cylinder(d=3.4,h=30,center=true);
      translate([e==0?7:span-7-2.8,-3.1,rung_s/2-3.1]) cube([2.8,6.2,20]);
    }
    translate([span/2,0,-1]) cylinder(d=5,h=rung_s+2);
  }
}
module spacers_flat(){
  // Stub-axle spacers: touch only the bearing inner ring (8 mm OD).
  hs=[8,1,1,2,2,4];
  for(i=[0:len(hs)-1]) translate([i*11,0,0]) difference(){ cylinder(d=8,h=hs[i]); translate([0,0,-1]) cylinder(d=5.4,h=hs[i]+2); }
}

// ---------------- Assembly placement ----------------
module housing_placed(){ translate([0,y_back_out,H]) rotate([90,0,0]) housing_flat(); }
module cap_placed(){ translate([0,y_hsg_out,H]) rotate([90,0,0]) cap_flat(); }
module lever(angle){
  translate([0,0,H]) rotate([0,-angle,0]) {
    translate([0,y_a_in+cheek_t,0]) rotate([90,0,0]) cheek_a_flat();
    translate([0,y_b_in,0]) rotate([90,0,0]) cheek_b_flat();
    for(r=rung_r) translate([r,y_b_in,-rung_s/2]) rotate([0,0,90]) rung_flat();
  }
}

module servo_env(gold=false){
  color([.15,.15,.15]) {
    translate([body_cx-body[0]/2,yb,H-body[1]/2]) cube([body[0],case_h,body[1]]);
    translate([body_cx-27,y_tab_top,H-body[1]/2]) cube([54,2.5,body[1]]);
  }
  // Output boss + splined shaft. Gold in the placement diagram so it stands out.
  color(gold?"gold":[.15,.15,.15]) translate([0,yb+case_h,H]) rotate([-90,0,0]) cylinder(d=13,h=2.5);
  color(gold?"gold":[.15,.15,.15]) translate([0,yb,H]) rotate([-90,0,0]) cylinder(d=6,h=spline_top);
}
module hub_placed(angle){ translate([0,yb+hub_bot,H]) rotate([0,-angle,0]) rotate([-90,0,0]) color("orange") hub(); }
module static_parts(){ carrier(); housing_placed(); cap_placed(); servo_env();
  for(sx=[-1,1],sz=[-1,1]) translate([sx*12,y_cap_out,H+sz*12]) rotate([90,0,0]) cylinder(d=5.5,h=3); }

if(part=="carrier") carrier();
else if(part=="housing") housing_flat();
else if(part=="cap") cap_flat();
else if(part=="cheek_a") cheek_a_flat();
else if(part=="cheek_b") cheek_b_flat();
else if(part=="rung") rung_flat();
else if(part=="spacers") spacers_flat();
else if(part=="assembly"){
  color("#dfe7ef") translate([0,0,-5]) cylinder(r=40,h=5);
  color("steelblue") carrier(); color("lightblue") { housing_placed(); cap_placed(); }
  servo_env(); hub_placed(lever_angle);
  color("#f4a236") lever(lever_angle);
}
else if(part=="collide") intersection(){ static_parts(); lever(lever_angle); }
else if(part=="exploded") exploded();
else if(part=="servo_place") servo_place();
else if(part=="servo_alone") translate([0,0,0]) servo_env(true);

// Servo placement view: carrier + servo pulled out toward the hub side, red line = shoulder axis.
module servo_place(){
  color("steelblue") carrier();
  translate([0,20,0]) servo_env(true);
  color("red") translate([0,-60,H]) rotate([-90,0,0]) cylinder(d=1.6,h=150);
}

// ---------------- Exploded construction view ----------------
// Parts pulled apart along the shoulder axis (Y). show="" draws everything;
// show="<name>" draws only that part, used to locate label positions.
show="";
ex=22;                   // explosion step, mm
module vis(n){ if(show==""||show==n) children(); }
module hexnut(d,h){ cylinder(d=d,h=h,$fn=6); }
module along_y(y0,len){ translate([0,y0,0]) rotate([-90,0,0]) children(); } // cylinder from y0 toward +Y
module ycyl(y0,len,d){ translate([0,y0,H]) rotate([-90,0,0]) cylinder(d=d,h=len); }
module yannulus(y0,len,od,id){ translate([0,y0,H]) rotate([-90,0,0]) difference(){ cylinder(d=od,h=len); translate([0,0,-1]) cylinder(d=id,h=len+2); } }

module exploded(){
  a=0;  // lever horizontal
  vis("platform") color("#dfe7ef") translate([0,0,-5]) cylinder(r=40,h=5);
  vis("carrier") color("steelblue") carrier();
  // + Y side (hub side)
  vis("servo") translate([0,ex*1,0]) servo_env();
  vis("horn") color("#eeeeee") translate([0,ex*1.7,0]) translate([0,yb+hub_bot-2.7,H]) rotate([-90,0,0])
      difference(){ hull(){ for(x=[-18.5,18.5]) translate([x,0,0]) cylinder(d=5,h=2.7); } translate([0,0,-1]) cylinder(d=2.5,h=5); for(x=[-15,-11,11,15]) translate([x,0,-1]) cylinder(d=1.6,h=5); }
  vis("hub") translate([0,ex*2.4,0]) hub_placed(a);
  vis("cheek_a") color("#f4a236") translate([0,ex*3.2,0]) translate([0,0,H]) rotate([0,-a,0]) translate([0,y_a_in+cheek_t,0]) rotate([90,0,0]) cheek_a_flat();
  vis("rungs") color("#f8b45a") translate([0,0,H]) rotate([0,-a,0]) for(r=rung_r) translate([r,y_b_in,-rung_s/2]) rotate([0,0,90]) rung_flat();
  // - Y side (bearing side)
  vis("housing") color("lightblue") translate([0,-ex*1,0]) housing_placed();
  vis("bearing") color("silver") translate([0,-ex*1.6,0]) { yannulus(y_hsg_out+0.2,5,16,8.5); color("#c8ccd0") yannulus(y_hsg_out+0.2,5,8,5); }
  vis("cap") color("#7fb3cc") translate([0,-ex*2.2,0]) cap_placed();
  vis("hsg_screws") color("#9aa3ad") translate([0,-ex*2.6,0]) for(sx=[-1,1],sz=[-1,1]) translate([sx*12,y_cap_out,H+sz*12]) rotate([90,0,0]) { cylinder(d=3,h=20); cylinder(d=5.5,h=3); }
  vis("spacers") color("#f6c27a") translate([0,-ex*3.0,0]) { yannulus(y_cap_out-8,8,8,5.4); yannulus(y_cap_out-9.2,1,8,5.4); }
  vis("cheek_b") color("#f4a236") translate([0,-ex*3.6,0]) translate([0,0,H]) rotate([0,-a,0]) translate([0,y_b_in,0]) rotate([90,0,0]) cheek_b_flat();
  vis("nut") color("#9aa3ad") translate([0,-ex*4.2,0]) { yannulus(y_b_in-cheek_t-1,1,10,5.3); translate([0,y_b_in-cheek_t-1,H]) rotate([90,0,0]) hexnut(8.5,4); }
  vis("bolt") color("#9aa3ad") translate([0,-ex*5.8,0]) { ycyl(y_back_out,5,8.5); ycyl(y_back_out-30,30,5); }
}
