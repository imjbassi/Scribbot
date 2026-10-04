// Millimeters. Fit gauges only, NOT load-bearing servo brackets.
// Selected body clearance: +0.6 mm total, confirmed by user's PLA coupons.
// A = lengthwise mounting-hole center spacing; B = spacing across one end.
part="mg90s"; // mg90s or mg996r
$fn=48;
module plate(size,opening,A,B,hole,label) {
  difference() {
    translate([-size[0]/2,-size[1]/2,0]) cube([size[0],size[1],2]);
    translate([-opening[0]/2,-opening[1]/2,-1]) cube([opening[0],opening[1],4]);
    for(x=[-A/2,A/2]) {
      if(B==0) translate([x,0,-1]) cylinder(d=hole,h=4);
      else for(y=[-B/2,B/2]) translate([x,y,-1]) cylinder(d=hole,h=4);
    }
  }
  translate([0,size[1]/2-3.6,2]) linear_extrude(0.4)
    text(label,size=2.4,halign="center",font="Liberation Sans:style=Bold");
}
if(part=="mg90s") {
  for(i=[0:4]) translate([(i%2)*43,floor(i/2)*29,0])
    plate([39,25],[23.4,12.8],27+i*0.5,0,1.6,str("M",i+1," A",27+i*0.5));
}
if(part=="mg996r") {
  for(i=[0:8]) translate([(i%2)*66,floor(i/2)*34,0])
    plate([62,32],[41.3,20.3],49+floor(i/3),9+i%3,2,
      str("S",i+1," A",49+floor(i/3)," B",9+i%3));
}
