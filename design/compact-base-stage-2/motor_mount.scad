// Unloaded motor-mount prototype; millimeters.
part="posts";
$fn=64;
module post(){difference(){cylinder(d=14,h=10);translate([0,0,-1])cylinder(d=3.4,h=12);}}
module shoe(){difference(){translate([-5.2,-9,0])cube([10.4,18,1]);translate([0,0,-1])cylinder(d=3.4,h=3);}}
if(part=="posts")for(x=[-10,10],y=[-10,10])translate([x,y,0])post();
if(part=="shoes")for(x=[-8,8],y=[-12,12])translate([x,y,0])shoe();
