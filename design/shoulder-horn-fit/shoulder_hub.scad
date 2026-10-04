// Shoulder drive hub: bolts onto the MG996R's supplied horn with the horn's own small screws.
// Later, the upper arm bolts to this hub with four M3 screws into captured nuts.
// Print flat as exported (horn side down): PLA, 0.12 mm layers, 4 walls, 40% infill, no supports.
$fn=64;
hub_d=44;
hub_h=7;
floor_h=2.5;      // material under the horn-screw heads (short supplied screws)

module slot(r0,r1,w,h){
  hull(){ translate([r0,0,0]) cylinder(d=w,h=h); translate([r1,0,0]) cylinder(d=w,h=h); }
}

module hub(){
difference(){
  cylinder(d=hub_d,h=hub_h);
  // Center: access to the horn's center screw.
  translate([0,0,-1]) cylinder(d=9,h=hub_h+2);
  // Four radial slots: line any two opposite ones up with horn holes.
  for(a=[0,90,180,270]) rotate([0,0,a]){
    translate([0,0,-1]) slot(7,17,2.2,hub_h+2);           // screw clearance
    translate([0,0,floor_h]) slot(7,17,4.8,hub_h);        // head counterbore
  }
  // Four M3 holes for the future upper-arm yoke, with hex nut traps on the horn side.
  for(a=[45,135,225,315]) rotate([0,0,a]) translate([17,0,0]){
    translate([0,0,-1]) cylinder(d=3.4,h=hub_h+2);
    translate([0,0,-1]) cylinder(d=6.7,h=3.6,$fn=6);      // M3 nut (5.8 across flats), 2.6 deep
  }
  // Orientation mark on the top face.
  rotate([0,0,22.5]) translate([hub_d/2-3.5,0,hub_h-0.6]) cylinder(d=2,h=1);
}
}

hub();
