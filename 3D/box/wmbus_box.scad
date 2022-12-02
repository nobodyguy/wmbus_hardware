//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for MBUS
//
//  Version 0.2
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator_v14.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

printBaseShell      = true;
printLidShell       = true;

// Edit these parameters for your own board dimensions
wallThickness       = 2.0;
basePlaneThickness  = 2.0;
lidPlaneThickness   = 2.0;

baseWallHeight      = 6;
lidWallHeight       = 2;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight         = 2.8;
ridgeSlack          = 0.2;
roundRadius         = 0.5;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight      = 2.0;
pinDiameter         = 2.0;
pinHoleSlack        = 0.1;
standoffDiameter    = 4.0;

// Total height of box = basePlaneThickness + lidPlaneThickness 
//                     + baseWallHeight + lidWallHeight
pcbLength           = 56.63;
pcbWidth            = 20.05;
pcbThickness        = 1.6;
                            
// padding between pcb and inside wall
paddingFront        = 0.2;
paddingBack         = 0.2;
paddingRight        = 0.2;
paddingLeft         = 0.2;


//-- D E B U G -------------------
showSideBySide      = true;
hideLidWalls        = false;
onLidGap            = 0;
shiftLid            = 0;
colorLid            = "yellow";
hideBaseWalls       = false;
colorBase           = "white";
showPCB             = false;
showMarkers         = false;
inspectX            = 0;  // 0=none, >0 from front, <0 from back
inspectY            = 0;  // 0=none, >0 from left, <0 from right

labelsPlane = [];
//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = { yappBoth | yappLidOnly | yappBaseOnly }
// (3) = { yappHole, YappPin }
pcbStands = [
                [3,  3, yappBoth, yappPin],
                [pcbLength-6.80,  pcbWidth-3, yappBoth, yappPin],
                [pcbLength-8.32,  3, yappBoth, yappPin],
                [3, pcbWidth-3, yappBoth, yappPin],
             ];
  

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
/*
cutoutsLid =  [
                  [pcbLength+1, pcbWidth/2, 12, 3, 0, yappRectangle, yappCenter]
              ];
    
  */            

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
//cutoutsBase =   [
//[2.60,  2.53, 2, 0, 0,yappCircle, yappCenter]
//                    [10, 10, 20, 10, 45, yappRectangle]
//                  , [30, 10, 15, 10, 45, yappRectangle, yappCenter]
//                  , [20, pcbWidth-20, 15, 0, 0, yappCircle]
//                  , [pcbLength-15, 5, 10, 2, 0, yappCircle]
//                ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront =  [
[pcbWidth/2-0.2, 3.6, 12.4, 5.2, 0, yappRectangle, yappCenter]
//                 [25, 3, 10, 10, 0, yappRectangle, yappCenter]  // center
                ];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBack =   [
                    [pcbWidth/2-3.5, -3.2, 7.4, 7.4, 0, yappRectangle]                // org
                  
                ];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
//cutoutsLeft =   [
//                    [25, 0, 6, 20, 0, yappRectangle]                        // org
//                  , [pcbLength-35, 0, 20, 6, 0, yappRectangle, yappCenter] // center
//                  , [pcbLength/2, 10, 20, 6, 0, yappCircle]                // circle
//                ];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
//cutoutsRight =  [
//                    [10, 0, 9, 5, 0, yappRectangle]                // org
//                  , [40, 0, 9, 5, 0, yappRectangle, yappCenter]    // center
//                  , [60, 0, 9, 5, 0, yappCircle]                   // circle
//                ];

//-- connectors -- origen = box[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = insertDiameter
// (4) = outsideDiameter
// (5) = { yappAllCorners }
//connectors   =  [
//                    [8, 8, 2.5, 3.8, 5, yappAllCorners]
//                  , [30, 8, 5, 5, 5]
//                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
//baseMounts   = [
//                    [-5, 3.5, 10, 3, yappRight, yappCenter]
//                  , [0, 3.5, shellLength, 3, yappLeft, yappCenter]
//                  , [0, 3.5, 33, 3, yappLeft]
//                  , [shellLength, 3.5, 33, 3, yappLeft]
//                  , [shellLength/2, 3.5, 30, 3, yappLeft, yappCenter]
//                  , [10, 3.5, 15, 3, yappBack, yappFront]
//                  , [shellWidth-10, 3.5, 15, 3, yappBack, yappFront]
//               ];
               
//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }

/*snapJoins   =     [
                    [2, 10, yappLeft, yappRight, yappSymmetric]
              //    [5, 10, yappLeft]
              //  , [shellLength-2, 10, yappLeft]
               //   , [30,  10, yappFront, yappBack]
              //  , [2.5, 3, 5, yappBack, yappFront, yappSymmetric]
                ];
*/               
//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
//labelsPlane =  [
//                    [10,  10,   0, "lid",   "Liberation Mono:style=bold", 7, "YAPP" ]
//                  , [100, 90, 180, "base",  "Liberation Mono:style=bold", 7, "Base" ]
//                  , [8,    8,   0, "left",  "Liberation Mono:style=bold", 7, "Left" ]
//                  , [10,   5,   0, "right", "Liberation Mono:style=bold", 7, "Right" ]
//                  , [40,  23,   0, "front", "Liberation Mono:style=bold", 7, "Front" ]
//                  , [5,    5,   0, "back",  "Liberation Mono:style=bold", 7, "Back" ]
//               ];



//---- This is where the magic happens ----
difference(){
    YAPPgenerate();
           
   /* 
        translate([pcbX+2.60,pcbY+2.55,0]){
            color("green",0.5) cylinder(h=1,d=4, center=false, $fn=20); 
        }  
      
      translate([pcbX+pcbLength-2.60,pcbY+pcbWidth-2.55,0]){
            color("green",0.5) cylinder(h=1,d=4, center=false, $fn=20); 
        }
     
     translate([pcbX+pcbLength-2.60,pcbY+2.55,0]){
            color("green",0.5) cylinder(h=1,d=4, center=false, $fn=20); 
        } 
    translate([pcbX+2.55,pcbY+pcbWidth-2.40,0]){
            color("green",0.5) cylinder(h=1,d=4, center=false, $fn=20); 
        } 
       
               translate([pcbX+2.60,pcbY+2.55,0]){
            color("green",0.5) cylinder(h=3,d=2, center=false, $fn=20); 
        }  
      
      translate([pcbX+pcbLength-2.60,pcbY+pcbWidth-2.55,0]){
            color("green",0.5) cylinder(h=3,d=2, center=false, $fn=20); 
        }
     
     translate([pcbX+pcbLength-2.60,pcbY+2.55,0]){
            color("green",0.5) cylinder(h=3,d=2, center=false, $fn=20); 
        } 
    translate([pcbX+2.55,pcbY+pcbWidth-2.40,0]){
            color("green",0.5) cylinder(h=3,d=2, center=false, $fn=20); 
        }  
        */
}
//translate([pcbX+pcbLength/2, pcbY+pcbWidth/2, basePlaneThickness+standoffHeight]) rotate([90,0,0]) color("grey", 0.6) import("./wmbus_pcb.stl");
