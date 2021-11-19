# 3D_Bolts
Hex Bolt library made by Blake Caldwell. By including into your program you can make your own bolts, nuts, and washers.
Math for threads was found analyzing code by Aubenc and Mike Thompson on Thingaverse.

For extra strength in your prints, it is advised for bolts that you print them sideways and a gap of 0.3mm between the bolt and nut.
For vertical printing, a gap between the bolt and nut of 0.1mm.

# Print A Bolt
Call the module: hexBolt(bolt)
    Takes a bolt, array of nums as defined below..
    
# Print A Nut
Call the module: hexNut(nut)
    Takes a nut, array of nums as defined below or by calling: makeNut(bolt). makeNut() takes a bolt and makes a standard hex nut from the bolt information.
    
# Print a Washer/Spacer
Call the module: washer(wash)
    Takes a washer, array of nums as defined below or by calling: makeWasher(bolt). makeWasher() takes a bolt and makes a standard washer from the given bolt. You can also use washers to create a taller spacer.

# Bolt Definition

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
     
# Nut Definition

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
      Unused spacer
[8] NONE
      Unused spacer
[9] counterSink
      -2
      
# Washer Definition

[0] threadDiameter
      Outer diameter of bolt threads
[1] washerOuterDiameter
      Outer diameter of wahser
[2] washerHeight
      Height of washer
