// Vision draw arm: preliminary fit tests, millimeters. Export one part at a time.
// FDM defaults only. Resin dimensions require separate coupons.
part = "mg90s"; // mg90s, mg996r, bearings, slide, note_holder
$fn = 96;
mg90s_body = [22.8,12.2];
mg996r_body = [40.7,19.7];
note_size = [76.2,76.2];
// Labels denote TOTAL extra width for body openings; diametral extra for bearings.
module body_coupon(body) {
  for(i=[0:2]) translate([0,i*(body[1]+12),0]) {
    c=[0.4,0.6,0.8][i];
    difference() {
      cube([body[0]+12,body[1]+10,4]);
      translate([4,4,-1]) cube([body[0]+c,body[1]+c,6]);
    }
    translate([4,body[1]+6,4]) linear_extrude(0.5)
      text(str("+",c),size=2.4);
  }
}
module bearing_coupon() {
  for(i=[0:3]) translate([i*26,0,0]) {
    d=16+[0,0.1,0.2,0.3][i];
    difference() {
      cube([24,30,5]);
      translate([12,12,-1]) cylinder(d=d,h=7);
    }
    translate([4,25,5]) linear_extrude(0.5) text(str(d),size=2.8);
  }
}
module slide_coupon() {
  // Print slider separately; insert it into each open-ended channel after cooling.
  for(i=[0:2]) translate([i*22,0,0]) {
    c=[0.2,0.3,0.4][i]; // per-side lateral clearance
    difference() {
      cube([20,32,6]);
      translate([(20-10-2*c)/2,-1,2]) cube([10+2*c,34,5]);
    }
    translate([0.3,3,6]) linear_extrude(0.5) text(str(c),size=2);
  }
  translate([72,0,0]) cube([10,30,3]);
}
module note_holder() {
  // Flat bed; two low registration edges only, leaving other sides accessible.
  // Four external screw tabs. Reconfigure note_size after measuring actual notes.
  sx=note_size[0]+1; sy=note_size[1]+1;
  difference() {
    union() {
      cube([sx+8,sy+8,2]);
      translate([2,2,2]) cube([2,sy+2,0.6]);
      translate([2,2,2]) cube([sx+2,2,0.6]);
      for(x=[12,sx-4],y=[-5,sy+13]) translate([x,y,0]) cylinder(d=12,h=2);
      for(x=[12,sx-4],y=[-5,sy+5]) translate([x-6,y,0]) cube([12,8,2]);
    }
    for(x=[12,sx-4],y=[-5,sy+13]) translate([x,y,-1]) cylinder(d=4.5,h=4);
  }
}
if(part=="mg90s") body_coupon(mg90s_body);
else if(part=="mg996r") body_coupon(mg996r_body);
else if(part=="bearings") bearing_coupon();
else if(part=="slide") slide_coupon();
else if(part=="note_holder") note_holder();
