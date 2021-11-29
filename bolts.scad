/*
bolts.scad
Hex Bolt library made by Blake Caldwell. By including into your program you can make your own bolts, nuts, and washers.

***Print A Bolt***
Call the module: hexBolt(bolt)
    Takes an array of nums as defined below.
    
***Print A Nut***
Call the module: hexNut(nut)
    Takes an array of nums as defined below.
    
***Print a Washer/Spacer***
Call the module: washer(wash)
    Takes an array of nums as defined below.

************Bolt Definition************

[0] threadOuterDiameter
      Outer diameter of the threads
[1] threadStep
      M6=1, M8=1.25, M10=1.5, M12=1.75, M16=2
[2] stepShapeDegrees
      Normally 30 degrees, for printing might want greater
[3] threadLength
      Lengh of threaded part of bolt
[4] resolution
      Higher resolution for displaying bolt due to its complexity
[5] headDiameter
      Distance between two faces of the head
[6] headHeight
      Heigt of hex head
[7] nonThreadLength
      Length of non-threaded part of bolt
[8] nonThreadDiameter
      -1 for inner diameter of threads, 0 for outer diameter of threads, other input is custom diameter
[9] counterSink
      Counter sink at both ends of bolt [-1:2]
      
************Nut Definition************

[0] threadOuterDiameter
      Outer diameter of the threads but for nuts normally you want it about one mm larger than bolt
[1] threadStep
      M6=1, M8=1.25, M10=1.5, M12=1.75, M16=2
[2] stepShapeDegrees
      Normally 30 degrees, for printing might want greater
[3] threadLength
      Must be greater than the headHeight
[4] resolution
      Lower number means higher resolution for displaying threads due to its complexity
[5] headDiameter
      Distance between two faces of the nut
[6] headHeight
      Height of nut
[7] NONE
      
[8] NONE
      
[9] counterSink
      -2
      
************Washer Definition************

[0] threadDiameter
      Outer diameter of bolt threads
[1] washerOuterDiameter
      Outer diameter of wahser
[2] washerHeight
      Height of washer
      
*/

//This is an example of how to define a bolt.
basicBolt = [8,2,45,25,.5,12,5,10,-1,2];

function makeNut(bolt) = [getThreadOuterDiameter(bolt)+.1,
                          getThreadStep(bolt),
                          getStepShapeDegrees(bolt),
                          getThreadLength(bolt),
                          getResolution(bolt),
                          getHeadDiameter(bolt),
                          6,
                          0,
                          0,
                          -2
                          ];
                          
function makeWasher(bolt) = [getThreadOuterDiameter(bolt)+.5,
                             getThreadOuterDiameter(bolt)+15,
                             3
                             ];
                          
function getThreadOuterDiameter(bolt) = bolt[0];
function getThreadStep(bolt) = bolt[1];
function getStepShapeDegrees(bolt) = bolt[2];
function getThreadLength(bolt) = bolt[3];
function getResolution(bolt) = bolt [4];
function getHeadDiameter(bolt) = bolt[5];
function getHeadHeight(bolt) = bolt[6];
function getNonThreadLength(bolt) = bolt[7];
function getNonThreadDiameter(bolt) = bolt[8];
function getCounterSink(bolt) = bolt[9];

function getWasherInnerDiameter(washer) = washer[0];
function getWasherOuterDiameter(washer) = washer[1];
function getWasherHeight(washer) = washer[2];

module hexBolt(bolt){
    
    nonThreadRadius = getThreadOuterDiameter(bolt) / 2 - (getThreadStep(bolt) / 2)  * cos(getStepShapeDegrees(bolt))/sin(getStepShapeDegrees(bolt));
    
    union(){
        hexHead(bolt);
        
        translate([0,0,getHeadHeight(bolt)]){
            if (getNonThreadLength(bolt) == 0){
                cylinder(h=0.1, r=nonThreadRadius, center=true);
            }
            else{
                if(getNonThreadDiameter(bolt) == -1){
                    cylinder(h=getNonThreadLength(bolt), r=nonThreadRadius, $fn=floor(getThreadOuterDiameter(bolt)*PI / getResolution(bolt)));
                }
                else if (getNonThreadDiameter(bolt) == 0){
                    union(){
                        cylinder(h=getNonThreadLength(bolt)-getThreadStep(bolt)/2, r=getThreadOuterDiameter(bolt)/2, 
                                 $fn=floor(getThreadOuterDiameter(bolt)*PI / getResolution(bolt)));
                        
                        translate([0,0,getNonThreadLength(bolt)-getThreadStep(bolt)/2])
                            cylinder(h=getThreadStep(bolt)/2, r1=getThreadOuterDiameter(bolt)/2, 
                                     r2=nonThreadRadius,$fn=floor(getThreadOuterDiameter(bolt)*PI / getResolution(bolt)));
                    }
                }
                else{
                    cylinder(h=getNonThreadLength(bolt), r=getNonThreadDiameter(bolt)/2,$fn=floor(getThreadOuterDiameter(bolt)*PI / getResolution(bolt)));
                }
                
            }
        }
        
        translate([0,0,getNonThreadLength(bolt)+getHeadHeight(bolt)])
            thread(bolt);
    }
}

module hexNut(nut){
    difference(){
        hexHead(nut);
        
        counterSinkEnds(nut);
        
        thread(nut);
    }
}

module washer(wash){
    difference(){
        cylinder(h=getWasherHeight(wash),r=getWasherOuterDiameter(wash)/2, center=true);
        
        cylinder(h=getWasherHeight(wash)+1,r=getWasherInnerDiameter(wash)/2, center=true);
    }
}

module hexHead(bolt){
    radius = getHeadDiameter(bolt)/2/sin(60);
    x0=0; x1=getHeadDiameter(bolt)/2; x2=x1+getHeadHeight(bolt)/2;
    y0=0; y1=getHeadHeight(bolt)/2; y2=getHeadHeight(bolt);
    
    intersection(){
        cylinder(h=getHeadHeight(bolt), r=radius, $fn=6);
        
        rotate_extrude(convexity=10, $fn=6*round(getHeadDiameter(bolt)*PI/6/0.5))
        polygon([[x0,y0],[x1,y0],[x2,y1],[x1,y2],[x0,y2]]);
    }
}

module thread(bolt){
    outsideThreadRadius=getThreadOuterDiameter(bolt)/2;
    insideThreadRadius=outsideThreadRadius-getThreadStep(bolt)/2*cos(getStepShapeDegrees(bolt))/sin(getStepShapeDegrees(bolt));
    circumference=2*PI*outsideThreadRadius;
    circumferenceResolution=floor(circumference/getResolution(bolt));
    degreesStep=360/circumferenceResolution;
    threadsPerStep=round(getThreadLength(bolt)/getThreadStep(bolt)+1);
    stepPerResolution=getThreadStep(bolt)/circumferenceResolution;
    
    intersection(){
        
        if(getCounterSink(bolt) >= -1){
            if(getCounterSink(bolt) == 0){
                cylinder(h=getThreadLength(bolt), r=outsideThreadRadius, $fn=circumferenceResolution);
            }
            else{
                union(){
                    translate([0,0,getThreadStep(bolt)/2])
                        cylinder(h=getThreadLength(bolt)-getThreadStep(bolt), r=outsideThreadRadius, $fn=circumferenceResolution);

                    if ( getCounterSink(bolt) == -1 || getCounterSink(bolt) == 2 ){
                        cylinder(h=getThreadStep(bolt)/2, r1=insideThreadRadius, r2=outsideThreadRadius, $fn=circumferenceResolution);
                    }
                    else{
                        cylinder(h=getThreadStep(bolt)/2, r=outsideThreadRadius, $fn=circumferenceResolution);
                    }

                    translate([0,0,getThreadLength(bolt)-getThreadStep(bolt)/2])
                        if ( getCounterSink(bolt) == 1 || getCounterSink(bolt) == 2 ){
                            cylinder(h=getThreadStep(bolt)/2, r1=outsideThreadRadius, r2=insideThreadRadius, $fn=circumferenceResolution);
                        }
                        else{
                            cylinder(h=getThreadStep(bolt)/2, r=outsideThreadRadius, $fn=circumferenceResolution);
                        }
                }
            }
        }
        
        if(insideThreadRadius >= 0.2){
            for(i=[0:threadsPerStep-1]){
                for(j=[0:circumferenceResolution-1]){
                    pt = [
                         [0,0,i*getThreadStep(bolt)-getThreadStep(bolt)],
                         [insideThreadRadius*cos(j*degreesStep),insideThreadRadius*sin(j*degreesStep),i*getThreadStep(bolt)+j*stepPerResolution-getThreadStep(bolt)],
                         [insideThreadRadius*cos((j+1)*degreesStep),insideThreadRadius*sin((j+1)*degreesStep),i*getThreadStep(bolt)+(j+1)*stepPerResolution-getThreadStep(bolt)],
                         [0,0,i*getThreadStep(bolt)],
                         [outsideThreadRadius*cos(j*degreesStep),outsideThreadRadius*sin(j*degreesStep),i*getThreadStep(bolt)+j*stepPerResolution-getThreadStep(bolt)/2],
                         [outsideThreadRadius*cos((j+1)*degreesStep),outsideThreadRadius*sin((j+1)*degreesStep),i*getThreadStep(bolt)+(j+1)*stepPerResolution-getThreadStep(bolt)/2],
                         [insideThreadRadius*cos(j*degreesStep),insideThreadRadius*sin(j*degreesStep),i*getThreadStep(bolt)+j*stepPerResolution],
                         [insideThreadRadius*cos((j+1)*degreesStep),insideThreadRadius*sin((j+1)*degreesStep),i*getThreadStep(bolt)+(j+1)*stepPerResolution],
                         [0,0,i*getThreadStep(bolt)+getThreadStep(bolt)]
                         ];
                    
                    polyhedron(points=pt, faces=[[1,0,3],[1,3,6],[6,3,8],[1,6,4],[0,1,2],[1,4,2],[2,4,5],
                                                 [5,4,6],[5,6,7],[7,6,8],[7,8,3],[0,2,3],[3,2,7],[7,2,5]]);
                }
            }
        }
    }
}

module counterSinkEnds(nut){
    translate([0,0,-.1])
        cylinder(h=getThreadStep(nut)/2, 
                 r1=getThreadOuterDiameter(nut)/2, 
                 r2=getThreadOuterDiameter(nut)/2-(getThreadStep(nut)/2+.1)*cos(getStepShapeDegrees(nut))/sin(getStepShapeDegrees(nut)), 
                 $fn=floor(getThreadOuterDiameter(nut)*PI/getResolution(nut)));
    
    translate([0,0,getHeadHeight(nut)-(getThreadStep(nut)/2)+.1])
        cylinder(h=getThreadStep(nut)/2,
                 r1=getThreadOuterDiameter(nut)/2-(getThreadStep(nut)/2+.1)*cos(getStepShapeDegrees(nut))/sin(getStepShapeDegrees(nut)),
                 r2=getThreadOuterDiameter(nut)/2, 
                 $fn=floor(getThreadOuterDiameter(nut)*PI/getResolution(nut)));
}
