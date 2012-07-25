import processing.opengl.*; 
/*
This code was copied from http://processing.org/discourse/beta/num_1194442962.html
and demonstrates how to use a mouse in 3d space. it is perfect
for what we are trying to do. 
*/

final int grille = 80; 		// space between spheres 
int zoom = -1000; 			// initial zoom - mouse wheel  
int ledSize = 15; 			// size of LED
int ledDetail = 1; 			// detail of LED, default 6, lower value offers better performance.
int h,i,j;  				// LED x y z position variables
int cubeSize = 16;  		// Number of LEDs on one axis
int framesPerSecond = 30;  	// Specifies the number of frames/second

float rotBuffX = 0;  		// angle of rotation X
float rotBuffY = 0;  		// angle of rotation Y
final float rotVit = 0.01; 	// step of rotation 
float threshhold = 8;  		// Hover tolerance - lower number means you must be more precise in your clicking of the LEDs

boolean rotateMode = false; // mouse rotation 
boolean ledHasBeenClicked;  // Value for if the LED is on or off
String ledColor = "blue";	// Color of LED (Red, Green, Yellow, Blue, White, Orange, Purple)
boolean locked;  			// for Button class
boolean ledIsHoveredOver = false;  	// hover variable
boolean debug = false;  	// turn debugging on and off

// coordinates from matrix 
float x[] = new float[cubeSize*cubeSize*cubeSize]; 
float y[] = new float[cubeSize*cubeSize*cubeSize]; 
float z[] = new float[cubeSize*cubeSize*cubeSize];

Map<String, String> ledList = new HashMap<String, String>(cubeSize*cubeSize*cubeSize);  // hashmap for whether LED is on or off
RectButton rect1, rect2;  	// Button objects (may not be used).



void setup() { 
	size(screen.width, screen.height, OPENGL); 
	frameRate(framesPerSecond);
	sphereDetail(ledDetail);
	noStroke(); 
	// mouse Wheel 
	addMouseWheelListener(new java.awt.event.MouseWheelListener() {  
		public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
			if (evt.getWheelRotation()<0){ zoom+=evt.getScrollAmount()+grille;}  // number of grid elements to move per mouse wheel rotation 
			else{ zoom-=evt.getScrollAmount()+grille; } 
		 redraw(); 
		} 
	}
	); 
 
	color buttoncolor = color(153);
	color highlight = color(103);
	rect1 = new RectButton(200, 200, 50, buttoncolor, highlight);
	clearHashMap();  // Sets all the values in the hashMap to false
} 


void draw() { 
 background(0); 
lights(); 
 // rotate mode 
 if (rotateMode) { 
   rotBuffX= mouseY*rotVit; 
   rotBuffY= -1*mouseX*rotVit; // the speed that the mouse rotates the screen
 } 

 translate(screen.width/2,screen.height/2,zoom); // center cube on the screen 
 rotateX(rotBuffX); 
 rotateY(rotBuffY); 
 pushMatrix(); 
 /// show center of rotation 
 fill(255,0,0); // make LED in center red
 sphere(ledSize);  // draw red LED in center of cube
 
 
 // center of rotation 
 // Offset distance from center red dot
 translate(-((grille*cubeSize/2)-(grille/2)),-((grille*cubeSize/2)-(grille/2)),-((grille*cubeSize/2)-(grille/2)));   
 int cnt = 0; // count 0-125 
 for (h=0; h<cubeSize; h++) { 
   for (i=0; i<cubeSize; i++) { 
    for (j=0; j<cubeSize; j++) { 
      pushMatrix(); 
      translate(i*grille, j*grille, h*grille); 
      x[cnt] = screenX(0, 0, 0); // This code lights up surrounding leds (doesnt actually work right now)
      y[cnt] = screenY(0, 0, 0); 
      z[cnt] = screenZ(0, 0, 0); 
      ledIsHoveredOver = checkDist(x[cnt],y[cnt],z[cnt]);  // threshold is fourth value, default is 15 - We deleted the hover over code...
          
      if (ledIsHoveredOver) { // LED is being hovered over
            if (debug){ println("ledIsHoveredOver = true, led " + +h+"-"+i+"-"+j +" is hovered over");}
            
            if (ledHasBeenClicked == true){  // LED has been hovered and clicked
				if (debug){ println("ledHasBeenClicked = true, led " + +h+"-"+i+"-"+j +" is marked as clicked");}
				if (debug){ println("Clicked LED "+h+"-"+i+"-"+j);}
                  
				if(ledList.get(h+"-"+i+"-"+j).equals("off")) { 		// LED has been hovered, clicked, and is turned off
					ledList.put(h+"-"+i+"-"+j,ledColor); 			// assigns true value to ledList hashmap to turn the LED on.
				}
				else {  										// LED has been hovered, clicked and is currently on
					ledList.put(h+"-"+i+"-"+j,"off");  			// assigns off value to ledList hashmap.
				}
            }
            ledHasBeenClicked = false; 							// user didn't click anything
      }
    
    
	if(ledList.get(h+"-"+i+"-"+j).equals("red")){  // turns LED on from ledList value
       fill(255,0,0);  // LED is red
    }
	else if (ledList.get(h+"-"+i+"-"+j).equals("green")){
		fill(0,255,0);  // LED is green
	}
	else if (ledList.get(h+"-"+i+"-"+j).equals("blue")){
		fill(0,0,255);  // LED is blue
	}
	else if (ledList.get(h+"-"+i+"-"+j).equals("yellow")){
		fill(255,255,0);  // LED is yellow
	}
	else if (ledList.get(h+"-"+i+"-"+j).equals("orange")){
		fill(255,100,0);  // LED is orange
	}
	else if (ledList.get(h+"-"+i+"-"+j).equals("purple")){
		fill(255,0,255);  // LED is green
	}
	else if (ledList.get(h+"-"+i+"-"+j).equals("white")){
		fill(255,255,255);  // LED is green
	}
    else {  // led is off and should stay off
       fill(90,90,90);  // LED is gray (off)
    }
      
    sphere(5); 
    popMatrix(); 
    cnt++; 

    }   // end for (j=0; j<cubeSize; j++) 
   }  // end for (i=0; i<cubeSize; i++)  
 }// end for (h=0; h<cubeSize; h++)  

 popMatrix(); 
 //rect1.display(); // show button object
} 

void keyPressed() {
	if (keyCode == SHIFT){ // activate rotation mode when Shift key is pressed
		rotateMode = true; 
		loop(); 
	}
 
	if (keyCode == ALT){  // Print hashMap
		for (Map.Entry entry : ledList.entrySet()) {
			println(entry.getKey() + ", " + entry.getValue());
		}
	}
	
	if (keyCode == DELETE){  // clear hashMap
		clearHashMap();  // Calls clearHashMap function - This should be renamed
	}
	
	if (key == 'd'){  // turn debug mode on and off
		if (debug == true){ debug = false; }  // turns debug off if it was on
		else { debug = true; }  // turns debug on if it was off
	}
	
	if (key == 'b'){ledColor = "blue"; } // Sets LED color
	if (key == 'r'){ledColor = "red"; } // Sets LED color
	if (key == 'g'){ledColor = "green"; } // Sets LED color
	if (key == 'y'){ledColor = "yellow"; } // Sets LED color
	if (key == 'o'){ledColor = "orange"; } // Sets LED color
	if (key == 'w'){ledColor = "white"; } // Sets LED color
	if (key == 'p'){ledColor = "purple"; } // Sets LED color
	if (key == 'i'){importHashMap(); } // import file
	
	if (key == 't'){  // timestamp
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");  // Converts date into human readable
		Date date = new Date();  // Creates new date object
		println(dateFormat.format(date));  // Prints current timestamp to console/terminal
	}
	
	if (keyCode == CONTROL){ // user pushed CTL key on keyboard
		exportHashMap();
	}
} 

void keyReleased()   { 
	if (keyCode == SHIFT){ // deactivate rotation mode 
		rotateMode = false; 
		loop(); 
	} 
} 

void mouseReleased() {
	if (debug){ println("mouse has been clicked, fyi led is currently" +h+"-"+i+"-"+j );}
	ledHasBeenClicked = true;  // Sets current clicked LED to true on next loop iteration.
}

boolean checkDist(float x1,float y1,float z1) { // check distance between mouse & object
 float theDist = dist(mouseX,mouseY,0,x1,y1,z1);
   if (theDist< threshhold) {
     return true;
   } else {
       return false;
   }
}

void clearHashMap () {  // Function to set all hashmap values to off
	for (h=0; h<cubeSize; h++) { 
		for (i=0; i<cubeSize; i++) { 
			for (j=0; j<cubeSize; j++) { 
				ledList.put(h+"-"+i+"-"+j,"off");  // Sets all hashmap values to off
			}
		}
	}
}

void importHashMap () {  // Function to import hashmap from file
	String importStringArray[] = loadStrings(selectInput());  // Load text file into String array
	for (int s=0; s<importStringArray.length; s++)
	{
		String[] tempList = split(importStringArray[s]," ");  // Split strings using " " as a delimeter
		ledList.put(tempList[0],tempList[1]);  // Turns LED on
	}
	println("Finished import");
}

void exportHashMap() {  // Function to export hashmap into file
	// Loop through hashmap & export
	Iterator loopdaloop = ledList.entrySet().iterator();
	String[] outputStringArray = new String[cubeSize*cubeSize*cubeSize];
	int arrayLoop = 0;
	while (loopdaloop.hasNext()){
		Map.Entry entry = (Map.Entry) loopdaloop.next();
		String key = (String)entry.getKey();
		String value = (String)entry.getValue();
		outputStringArray[arrayLoop]=key+" "+value;
		arrayLoop++;
	}
	DateFormat dateFormat = new SimpleDateFormat("MM-dd-yyyy_HH-mm-ss");  // Sets timestamp to human readable
	Date date = new Date();  // Creates new timestamp for filename
	saveStrings(selectInput(),outputStringArray);
	//saveStrings("output/"+dateFormat.format(date)+".txt",outputStringArray);  // Exports file as txt names as current time
	println("File has been saved to "+dateFormat.format(date)+".txt");
}
