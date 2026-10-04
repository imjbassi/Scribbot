// Millimeter scale strip for reading the calibration pen tip. 0-160 mm.
// Lay flat on the table under the pen, ticks up. Print flat, no supports.
// Resin gives the crispest ticks; FDM works at 0.12 mm layers.
$fn=32;
len=160;
difference(){
  translate([-5,0,0]) cube([len+10,24,2]);
  for(i=[0:len]){
    h = (i%10==0) ? 10 : (i%5==0) ? 7 : 4;
    translate([i-0.225,24-h,1.4]) cube([0.45,h+1,1]);
  }
  for(i=[0:10:len])
    translate([i,4,1.4]) linear_extrude(1)
      text(str(i/10), size=4.5, halign="center", font="Liberation Sans:style=Bold");
}
