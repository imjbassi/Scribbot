// COMPACT BASE DESIGN REVIEW. Not released for printing or purchasing.
// Horn and fastener envelopes must be checked against actual hardware first.
include <gear_profiles.scad>
part="assembly";
base_angle=0; // output angle, deg; planned range -35 to +35
explode=0;
$fn=72;
motor_x=46.875;
motor_body_y=6.5; // assumed shaft offset; adjustable mount, NOT a measured value
motor_plate_z=19;
function gear_z()=39;
module plate(w,d,h,r=3) {linear_extrude(h) hull() for(x=[-w/2+r,w/2-r],y=[-d/2+r,d/2-r]) translate([x,y]) circle(r=r);}
module oblong(len,w,h) {linear_extrude(h) hull() for(x=[-(len-w)/2,(len-w)/2]) translate([x,0]) circle(d=w);}
module rotor_holes(h) {for(x=[-12,12],y=[-12,12]) translate([x,y,-1]) cylinder(d=3.4,h=h+2);}
module base() {
  difference(){
    plate(150,150,9,8);
    translate([0,0,-1]) cylinder(d=5.4,h=11);
    translate([0,0,-1]) cylinder(d=9.6,h=6.5); // axle head recess, depth 5.5
    for(x=[-62,62],y=[-62,62]) translate([x,y,-1]) cylinder(d=4.5,h=11);
    // Two-axis adjustment for actual servo output position / gear mesh.
    for(x=[motor_x-16,motor_x+16],y=[motor_body_y-26,motor_body_y+26]) {
      translate([x,y,-1]) rotate([0,0,90]) oblong(15,8,11);
      translate([x,y,-1]) rotate([0,0,90]) oblong(19,11,4.6);
    }
    translate([motor_x-8,motor_body_y-14,-1]) cube([16,28,11]);
  }
}
module fixed_pedestal() {
  difference(){
    union(){cylinder(d=22,h=15.2);translate([0,0,15.2]) cylinder(d=9,h=5);}
    translate([0,0,-1]) cylinder(d=5.4,h=23);
  }
}
module inner_spacer(h=18) {difference(){cylinder(d=9,h=h);translate([0,0,-1]) cylinder(d=5.4,h=h+2);}}
module rotor_block(h) {difference(){plate(34,34,h);translate([0,0,-1]) cylinder(d=16.3,h=h+2);rotor_holes(h);}}
module cap(){difference(){plate(34,34,2);translate([0,0,-1]) cylinder(d=14.6,h=4);rotor_holes(2);}}
module main_gear(){difference(){gear_50(6);translate([0,0,-1]) cylinder(d=16.3,h=8);rotor_holes(6);}}
module platform(){difference(){cylinder(d=80,h=5);translate([0,0,-1]) cylinder(d=18,h=7);rotor_holes(5);for(x=[-26,26],y=[-16,16]) translate([x,y,-1]) cylinder(d=3.4,h=7);}}
module motor_gear(){
  // Four radial slots are a candidate universal attachment to the supplied horn.
  // Need >=2 compatible horn holes and fastener clearance; do not force a match.
  difference(){
    gear_25(6);
    translate([0,0,-1]) cylinder(d=8,h=8); // access to original horn center screw
    for(a=[0,90,180,270]) rotate([0,0,a]) translate([9,0,-1]) oblong(6.2,2.2,8);
  }
}
module motor_plate(){difference(){plate(44,64,4);translate([-6.4,-11.7,-1]) cube([12.8,23.4,6]);for(y=[-13.5,13.5]) translate([0,y,-1]) cylinder(d=2.2,h=6);for(x=[-16,16],y=[-26,26]) translate([x,y,-1]) cylinder(d=3.4,h=6);}}
module motor_post(h=10){difference(){cylinder(d=14,h=h);translate([0,0,-1]) cylinder(d=3.4,h=h+2);}}
module annulus(od,id,h){difference(){cylinder(d=od,h=h);translate([0,0,-1]) cylinder(d=id,h=h+2);}}
module bearing(){color("silver") annulus(16,5,5);}
module screw_ref(d,len,head_d,head_h){color("silver") union(){cylinder(d=d,h=len);translate([0,0,-head_h]) cylinder(d=head_d,h=head_h);}}
module assembly(){
  color("lightgray") base();
  color("gray") translate([0,0,9]) fixed_pedestal();
  // Fixed M5 x 80 axle: start of shank Z=5.5; end Z=85.5.
  translate([0,0,5.5]) screw_ref(5,80,8.5,5);
  color("silver") translate([0,0,29.2]) annulus(9,5.3,1);
  translate([0,0,30.2]) bearing();
  color("silver") translate([0,0,35.2]) annulus(9,5.3,1);
  color("gray") translate([0,0,36.2]) inner_spacer(18);
  color("silver") translate([0,0,54.2]) annulus(9,5.3,1);
  translate([0,0,55.2]) bearing();
  color("silver") translate([0,0,60.2]) annulus(9,5.3,1);
  color("gray") translate([0,0,61.2]) inner_spacer(10);
  color("silver") translate([0,0,71.2]) annulus(9,5.3,1);
  color("silver") for(z=[72.2,76.2]) translate([0,0,z]) cylinder(d=9.24,h=4,$fn=6);
  rotate([0,0,base_angle]) {
    color("steelblue") translate([0,0,28]) cap();
    color("lightblue") translate([0,0,30+explode]) rotor_block(9);
    color("teal") translate([0,0,39+explode*2]) main_gear();
    color("lightblue") translate([0,0,45+explode*3]) rotor_block(15.4);
    color("steelblue") translate([0,0,60.4+explode*4]) cap();
    color("teal") translate([0,0,62.4+explode*5]) platform();
  }
  for(x=[motor_x-16,motor_x+16],y=[motor_body_y-26,motor_body_y+26]) color("lightblue") translate([x,y,9]) motor_post();
  color("steelblue") translate([motor_x,motor_body_y,motor_plate_z]) motor_plate();
  // Nominal MG90S body/shaft/horn shown ONLY to assess packaging.
  color([.2,.2,.2,.6]) translate([motor_x-6.1,motor_body_y-11.4,7]) cube([12.2,22.8,26]);
  color("silver") translate([motor_x,0,33]) cylinder(d=4.8,h=5.5);
  translate([motor_x,0,37]) rotate([0,0,-2*base_angle]) color("gray") difference(){oblong(26,6,2);translate([0,0,-1]) cylinder(d=2,h=4);for(x=[-9,9]) translate([x,0,-1]) cylinder(d=2,h=4);}
  color("orange") translate([motor_x,0,39]) rotate([0,0,-2*base_angle]) motor_gear();
}
if(part=="assembly") assembly();
else if(part=="base") base();
else if(part=="pedestal") fixed_pedestal();
else if(part=="lower_rotor") rotor_block(9);
else if(part=="upper_rotor") rotor_block(15.4);
else if(part=="cap") cap();
else if(part=="main_gear") main_gear();
else if(part=="motor_gear") motor_gear();
else if(part=="platform") platform();
else if(part=="motor_plate") motor_plate();
else if(part=="motor_post") motor_post();
else if(part=="inner_spacer") inner_spacer(18);
else if(part=="top_spacer") inner_spacer(10);
