// Base calibration pointer: bolts to the rotating platform's four arm holes
// (+/-26, +/-16) and holds a pen vertically at 120 mm from the base axis.
// Origin = base axis at the platform top surface. Millimeters.
// Print flat as exported: 100% scale, PLA, 4 walls, 30% infill, no supports.
part="pointer";
tip_radius=120;
$fn=64;

module rrect(x0,x1,y0,y1,h,r=3){
  linear_extrude(h) hull() for(x=[x0+r,x1-r],y=[y0+r,y1-r]) translate([x,y]) circle(r=r);
}

module pointer(){
  difference(){
    union(){
      rrect(-32,32,-21,21,5);                              // mount plate
      translate([20,-6,0]) cube([tip_radius-20,12,5]);     // arm
      translate([30,-2,5]) cube([tip_radius-40,4,9]);      // stiffening rib
      translate([tip_radius,0,0]) cylinder(d=24,h=24);     // pen sleeve
      translate([tip_radius+8,-6,0]) cube([10,12,24]);     // set-screw boss
    }
    for(x=[-26,26],y=[-16,16]) translate([x,y,-1]) cylinder(d=3.4,h=7);   // M3 to platform
    for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=10,h=7);   // turntable bolt heads
    translate([0,0,-1]) cylinder(d=16,h=7);                               // axle nut stack
    translate([tip_radius,0,-1]) cylinder(d=16.2,h=26);                   // pen bore
    translate([tip_radius,0,14]) rotate([0,90,0]) cylinder(d=3.4,h=30);   // set screw
    translate([tip_radius+12,-3.1,10.7]) cube([2.8,6.2,20]);              // M3 nut slot
  }
}

if(part=="pointer") pointer();

