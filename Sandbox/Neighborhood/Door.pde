class Door{
  //door properties
  int x;
  int y;
  int w;
  int h;

  // for knob
  int knobLoc = 1;
  //constants
  final static int RT = 0;
  final static int LFT = 1;

  // constructor
  Door(int w, int h){
    this.w = w;
    this.h = h;
  }

  // draw the door
  void drawDoor(int x, int y) {
    rect(x, y, w, h);
    int knobsize = w/10;
    if (knobLoc == 0){
      //right side
      ellipse(x+w-knobsize, y+h/2, knobsize, knobsize);
    }
    else {
      //left side
      ellipse(x+knobsize, y+h/2, knobsize, knobsize);
    }
  }

  // set knob position
  void setKnob(int knobLoc){
    this. knobLoc = knobLoc;
  }
}