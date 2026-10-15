// Scribbot camera stand: holds a webcam (Logitech Brio 101) about 19 cm above a sticky note.
// The webcam's own monitor clip grips the end of the top arm. The camera hangs underneath, looking down.
// Parts (print one of each, no supports):
//   21 foot      note pocket + socket for the column (print flat)
//   22 column    lower column (print standing up)
//   23 coupler   joins the column to the top arm (print standing up)
//   24 top_arm   upright + arm, printed lying on its side
// Hardware: 4 x M3 x 12 screws (same as the arm) screwed into the printed columns, 2 zip ties.
part="assembly";
$fn=40;

C=24;          // column square
FIT=0.4;       // socket clearance
NOTE=78;       // pocket for a 76 mm note
COL_Y=92;      // column center, behind the note center
LOW_H=110;     // lower column
SOCK=20;       // socket depth
UP_H=120;      // upright of the top arm
ARM_T=10;      // the "monitor edge" thickness the clip grips
ARM_END=-15;   // arm end edge (y). The camera hangs between here and about y = +15, lens near y = 0.

// Through the socket wall from the -x side (clearance)...
module m3_cross(z){ translate([-C/2-7,0,z]) rotate([0,90,0]) cylinder(d=3.4,h=7.5); }
// ...and into the column (pilot hole, the screw cuts its own thread).
module m3_pilot(z){ translate([-C/2-1,0,z]) rotate([0,90,0]) cylinder(d=2.6,h=10); }

module socket_block(h){
  difference(){
    translate([-C/2-6,-C/2-6,0]) cube([C+12,C+12,h]);
    translate([-(C+FIT)/2,-(C+FIT)/2,-1]) cube([C+FIT,C+FIT,h+2]);
  }
}

module foot(){
  difference(){
    union(){
      translate([-70,-55,0]) cube([140,170,6]);
      translate([0,COL_Y,0]) socket_block(6+SOCK);
    }
    translate([-NOTE/2,-NOTE/2,5]) cube([NOTE,NOTE,2]);              // 1 mm deep note pocket
    translate([-NOTE/2-6,-8,4.6]) cube([7,16,2]);                    // finger notch to lift the note
    translate([0,COL_Y,6+SOCK/2]) m3_cross(0);
  }
  translate([0,COL_Y,0]) translate([-C/2-6,-C/2-6,0]) cube([C+12,C+12,6]);   // socket floor
}

module column(){            // standing, centered, z = 0 at the bottom
  difference(){
    translate([-C/2,-C/2,0]) cube([C,C,LOW_H]);
    m3_pilot(SOCK/2);
    m3_pilot(LOW_H-SOCK/2);
  }
}

module coupler(){ difference(){ socket_block(2*SOCK); m3_cross(SOCK/2); m3_cross(1.5*SOCK); } }

module top_arm_standing(){  // column axis at (0,0), bottom at z = 0
  L=COL_Y-ARM_END;
  difference(){
    union(){
      translate([-C/2,-C/2,0]) cube([C,C,UP_H]);
      translate([-C/2,-L,UP_H-ARM_T]) cube([C,L+C/2,ARM_T]);              // arm toward the note
      hull(){                                                            // gusset
        translate([-C/2,-C/2,UP_H-ARM_T-35]) cube([C,1,35]);
        translate([-C/2,-C/2-35,UP_H-ARM_T-1]) cube([C,35,1]);
      }
    }
    m3_pilot(SOCK/2);
    for(x=[-C/2+3,C/2-7]) translate([x,-L+8,UP_H-ARM_T-1]) cube([4,9,ARM_T+2]);   // zip-tie slots
  }
}

// Lying on its side: standing x becomes print z. All parts of it are C wide, so it sits flat.
module top_arm_print(){ translate([0,0,C/2]) rotate([0,90,0]) top_arm_standing(); }

Z_TOP=6+LOW_H;                                  // top of the lower column
module assembly(){
  color("white") foot();
  color("lightgray") translate([0,COL_Y,6]) column();
  color("silver") translate([0,COL_Y,Z_TOP-SOCK]) coupler();
  color("gainsboro") translate([0,COL_Y,Z_TOP]) top_arm_standing();
  color("#f6e27a") translate([-38,-38,5]) cube([76,76,0.3]);           // sticky note
  // webcam stand-in: hangs under the arm end, lens down
  color("#222") translate([-40,ARM_END,Z_TOP+UP_H-ARM_T-28]) cube([80,30,28]);
  color("#555") translate([0,ARM_END+15,Z_TOP+UP_H-ARM_T-29]) cylinder(d=12,h=2);
}

if(part=="assembly") assembly();
if(part=="foot") foot();
if(part=="column") column();
if(part=="coupler") coupler();
if(part=="top_arm") top_arm_print();
