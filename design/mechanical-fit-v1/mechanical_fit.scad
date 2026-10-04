// Mechanical interface prototypes. Millimeters. No complete powered joint yet.
// User-selected fits: MG90S A27, MG996R A49/B10, body +0.6 total, bearing 16.3.
part="micro_plate";
$fn=64;
plate_t=4;
module rounded_plate(w,d,h,r=3) {
  linear_extrude(h) hull() for(x=[-w/2+r,w/2-r],y=[-d/2+r,d/2-r])
    translate([x,y]) circle(r=r);
}
module module_holes(h) {
  for(x=[-26,26],y=[-16,16]) translate([x,y,-1]) cylinder(d=3.4,h=h+2);
}
module servo_plate(standard=false) {
  opening=standard?[41.3,20.3]:[23.4,12.8];
  A=standard?49:27;
  difference() {
    rounded_plate(64,44,plate_t);
    translate([-opening[0]/2,-opening[1]/2,-1]) cube([opening[0],opening[1],plate_t+2]);
    module_holes(plate_t);
    for(x=[-A/2,A/2]) {
      if(standard) for(y=[-5,5]) translate([x,y,-1]) cylinder(d=3.4,h=plate_t+2);
      else translate([x,0,-1]) cylinder(d=2.2,h=plate_t+2);
    }
  }
  translate([0,18,plate_t]) linear_extrude(.4)
    text(standard?"MG996R A49 B10":"MG90S A27",size=2.5,halign="center");
}
module base() {
  difference() {
    rounded_plate(150,150,7,8);
    module_holes(7);
    // Underside recesses for M3 socket heads and thin washers.
    for(x=[-26,26],y=[-16,16]) translate([x,y,-1]) cylinder(d=7,h=4.6);
    // Board mounting, outside the removable servo module footprint.
    for(x=[-62,62],y=[-62,62]) translate([x,y,-1]) cylinder(d=4.5,h=9);
    // Access window; module feet at x=+/-26 remain supported.
    translate([-19,-11,-1]) cube([38,22,9]);
  }
  translate([0,-65,7]) linear_extrude(.4) text("BASE FIT V1",size=4,halign="center");
}
module spacer(h) {difference(){cylinder(d=10,h=h);translate([0,0,-1]) cylinder(d=3.4,h=h+2);}}
module spacers(h) {for(x=[0,14],y=[0,14]) translate([x,y,0]) spacer(h);}
module bearing_holes(h) {for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=3.4,h=h+2);}
module bearing_carrier() {
  difference() {
    rounded_plate(34,34,9,3);
    translate([0,0,-1]) cylinder(d=14.6,h=11);
    // 625 bearing: 16.3 mm selected pocket, 5.2 mm deep for nominal 5 mm width.
    translate([0,0,3.8]) cylinder(d=16.3,h=6.2);
    bearing_holes(9);
  }
}
module bearing_cap() {
  difference() {
    rounded_plate(34,34,2,3);
    translate([0,0,-1]) cylinder(d=14.6,h=4);
    bearing_holes(2);
  }
}
module layout() {
  translate([-43,30,0]) servo_plate(false);
  translate([30,30,0]) servo_plate(true);
  translate([-57,-10,0]) spacers(20);
  translate([-21,-10,0]) spacers(35);
  translate([25,-12,0]) bearing_carrier();
  translate([64,-12,0]) bearing_cap();
}
module pedestal_assembly(standard=false,exploded=false) {
  // Preview only. Gray body is a nominal envelope, NOT printable servo geometry.
  h=standard?35:20;
  gap=exploded?10:0;
  color("lightgray") base();
  color("lightblue") for(x=[-26,26],y=[-16,16]) translate([x,y,7+gap]) spacer(h);
  color("steelblue") translate([0,0,7+h+2*gap]) servo_plate(standard);
  dims=standard?[40.7,19.7,29]:[22.8,12.2,16];
  // Body top here denotes underside of mounting ears, not full servo height.
  color([.2,.2,.2,.5]) translate([-dims[0]/2,-dims[1]/2,7+h+4+3*gap-dims[2]]) cube(dims);
}
if(part=="micro_plate") servo_plate(false);
else if(part=="standard_plate") servo_plate(true);
else if(part=="base") base();
else if(part=="micro_spacers") spacers(20);
else if(part=="standard_spacers") spacers(35);
else if(part=="bearing_carrier") bearing_carrier();
else if(part=="bearing_cap") bearing_cap();
else if(part=="layout") layout();
else if(part=="assembly_micro") pedestal_assembly(false,false);
else if(part=="assembly_standard") pedestal_assembly(true,false);
else if(part=="exploded_standard") pedestal_assembly(true,true);
