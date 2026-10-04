// Rotating base V1: unpowered prototype. Millimeters.
// Servo coupling is deliberately not released until actual horn is identified.
part="platform";
$fn=64;
base_t=9;
lower_post_h=55;
upper_post_h=31;
deck_t=4;
lower_deck_z=base_t+lower_post_h; // 64
upper_deck_z=lower_deck_z+deck_t+upper_post_h; // 99
platform_top_z=142;
module slab(w,d,h,r=3) {linear_extrude(h) hull() for(x=[-w/2+r,w/2-r],y=[-d/2+r,d/2-r]) translate([x,y]) circle(r=r);}
module slot(length,width,h) {linear_extrude(h) hull() for(x=[-(length-width)/2,(length-width)/2]) translate([x,0]) circle(d=width);}
module frame_holes(h,d=4.5) {for(x=[-36,36],y=[-36,36]) translate([x,y,-1]) cylinder(d=d,h=h+2);}
module bearing_holes(h) {for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=3.4,h=h+2);}
module base() {
  difference() {
    slab(150,150,base_t,8);
    frame_holes(base_t);
    // M4 socket-head + thin washer recesses on underside.
    for(x=[-36,36],y=[-36,36]) translate([x,y,-1]) cylinder(d=9,h=5.8);
    for(x=[-62,62],y=[-62,62]) translate([x,y,-1]) cylinder(d=4.5,h=base_t+2);
    // Existing 52x32 servo plate interface: 12 mm X travel for shaft alignment.
    for(x=[-26,26],y=[-16,16]) {
      translate([x,y,-1]) slot(15.4,3.4,base_t+2);
      translate([x,y,-1]) slot(19,7,4.6);
    }
    translate([0,0,-1]) slot(40,22,base_t+2);
  }
  translate([0,-65,base_t]) linear_extrude(.4) text("BASE V1 - HAND TEST",size=3,halign="center");
}
module deck() {
  difference(){
    slab(88,88,deck_t,5);
    frame_holes(deck_t);
    bearing_holes(deck_t);
    translate([0,0,-1]) cylinder(d=18,h=deck_t+2);
    // Cable windows, clear of center bearing carrier and all fasteners.
    for(x=[-27,27]) translate([x,0,-1]) slot(9,6,deck_t+2);
  }
}
module post(h) {difference(){cylinder(d=16,h=h);translate([0,0,-1]) cylinder(d=4.5,h=h+2);}}
module post_set(h) {for(x=[0,20],y=[0,20]) translate([x,y,0]) post(h);}
module carrier() {difference(){slab(34,34,9);translate([0,0,-1]) cylinder(d=14.6,h=11);translate([0,0,3.8]) cylinder(d=16.3,h=6.2);bearing_holes(9);}}
module cap() {difference(){slab(34,34,2);translate([0,0,-1]) cylinder(d=14.6,h=4);bearing_holes(2);}}
module platform() {
  // PRINT flange flat on bed. ASSEMBLE flipped, clamp block downward.
  difference() {
    union(){cylinder(d=80,h=6);translate([-12,-12,6]) cube([24,24,14]);}
    translate([0,0,-1]) cylinder(d=5.2,h=22);
    // Split clamp only in hub; flange retains shaft clearance.
    translate([0,-.6,6]) cube([13,1.2,15]);
    translate([8,-13,13]) rotate([-90,0,0]) cylinder(d=3.4,h=26);
    // Captive M3 nut accessible from one clamp side.
    translate([8,-12.1,13]) rotate([-90,0,0]) cylinder(d=6.7,h=2.8,$fn=6);
    for(x=[-18,18],y=[-18,18]) translate([x,y,-1]) cylinder(d=3.4,h=8);
  }
}
module washer5() {difference(){cylinder(d=9,h=1);translate([0,0,-1]) cylinder(d=5.3,h=3);}}
module bearing() {difference(){cylinder(d=16,h=5);translate([0,0,-1]) cylinder(d=5,h=7);}}
module collar() {difference(){cylinder(d=12,h=7);translate([0,0,-1]) cylinder(d=5,h=9);}}
module assembled(explode=0) {
  color("lightgray") base();
  for(x=[-36,36],y=[-36,36]) color("lightblue") translate([x,y,base_t]) post(lower_post_h);
  for(z=[lower_deck_z,upper_deck_z]) {
    zz=z+(z==upper_deck_z?explode*3:0);
    color("steelblue") translate([0,0,zz]) deck();
    color("lightblue") translate([0,0,zz+4+explode]) carrier();
    color("silver") translate([0,0,zz+7.8+explode*2]) bearing();
    color("steelblue") translate([0,0,zz+13+explode*3]) cap();
  }
  for(x=[-36,36],y=[-36,36]) color("lightblue") translate([x,y,68+explode]) post(upper_post_h);
  // Reference metal hardware, not printable. Shaft 5x100, lower end Z=45.
  color("silver") translate([0,0,45]) cylinder(d=5,h=100);
  // Collar positions set by measured actual washer/collar thickness during assembly.
  color("silver") translate([0,0,112.8]) collar();
  color("silver") translate([0,0,111.8]) washer5();
  color("silver") translate([0,0,63.5]) collar();
  color("silver") translate([0,0,70.5]) washer5();
  color("teal") translate([0,0,platform_top_z+explode*5]) rotate([180,0,0]) platform();
}
if(part=="base") base();
else if(part=="deck") deck();
else if(part=="lower_posts") post_set(lower_post_h);
else if(part=="upper_posts") post_set(upper_post_h);
else if(part=="platform") platform();
else if(part=="carrier") carrier();
else if(part=="cap") cap();
else if(part=="assembly") assembled();
else if(part=="exploded") assembled(12);
