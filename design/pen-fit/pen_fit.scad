// Pen fit coupon: five rings for a Sharpie Fine Point. Find the smallest ring the pen slides
// through freely under its own weight without rocking. Print flat, PLA, 0.12 mm layers, no supports.
$fn=96;
sizes=[11.6,12.0,12.4,12.8,13.2];
pitch=22;
difference(){
  union(){
    translate([-11,-11,0]) cube([pitch*(len(sizes)-1)+22,22,2]);        // base strip
    for(i=[0:len(sizes)-1]) translate([i*pitch,0,0]) cylinder(d=sizes[i]+5,h=10);
  }
  for(i=[0:len(sizes)-1]) translate([i*pitch,0,-1]) cylinder(d=sizes[i],h=12);
  for(i=[0:len(sizes)-1]) translate([i*pitch,-9.3,1.4]) linear_extrude(1)
    text(str(sizes[i]),size=3.2,halign="center",font="Liberation Sans:style=Bold");
}
