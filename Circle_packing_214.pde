// Circle Spawning with No Intersection by Michael Pinn
// https://www.openprocessing.org/sketch/157175
// Fork by Rupert Russell 18/09/2018
// https://github.com/rupertrussell/Circle-Packing-206
// http://colorbrewer2.org/?type=qualitative&scheme=Set1&n=7

color[] rainbow = {#000000, #e41a1c, #377eb8, #4daf4a, #984ea3, #ff7f00, #ffff33, #a65628};
ArrayList<Circle> circles = new ArrayList<Circle>();

float subtract = .2;

int counter = 0;
int saveCount = 0;
int sizeOfColourArray = 8;
int margin = 500;
int min = 10;
float max = 1800;


boolean first = true;
boolean detectCollision = false;
boolean detectIntercetionWithBoundary = false;
boolean detectIntercetionWithExistingCircles = false;

/* Our object */
Circle c = new Circle(new PVector(0, 0), 20);

void setup() {
  size(8800, 8800);
  circles.add(c);
  background(rainbow[0]);
  smooth();
}

void draw() {

  if (max > min) {
    max = max - subtract; // get pregressively smaller 
    println(max);
  } else {
    println("Saving last");
    save("last.png");
    exit();
  }
  c.draw();

  /* Make a random location and diameter */
  PVector newLoc = new PVector(random(width - margin) + margin/2, random(height - margin) + margin/2);
  int newD = (int) random(min, max);
  /* Detect whether if we use these these values if it will intersect the other objects. */
  while (detectAnyCollision (circles, newLoc, newD)) {
    /* If the values do interect make new values. */
    newLoc = new PVector(random(width - margin) + margin/2, random(height - margin) + margin/2);
    newD = (int) random(min, max);
  }

  /* Once we have our values that do not intersect, add a circle. */
  c = new Circle(newLoc, newD);
  circles.add(c);

  /* You can add an "if" statement to prevent the simulation going on forever */

  if (counter == 6000) {
    save("save_" + saveCount + ".png");
    println("saving " + saveCount);
    saveCount ++;
    counter = 0;
  }
  counter ++;
}

static boolean detectAnyCollision(ArrayList<Circle> circles, PVector newLoc, int newR) {
  for (Circle c : circles) {
    if (c.detectCollision(newLoc, newR)) {

      return true;
    }
  }
  return false;
}


class Circle {
  PVector loc;
  int d;

  Circle(PVector loc, int d) {
    this.loc = loc;
    this.d = d;
  } 

  void draw() {

    /* Random color to add some spice */
    // noStroke();
    fill(rainbow[int(random(1, sizeOfColourArray))]);
    if (first == false) {
      ellipse(loc.x, loc.y, d, d);
    }
    first = false;
  }

  boolean detectCollision(PVector newLoc, int newD) {
    detectCollision = false;
    detectIntercetionWithExistingCircles = false;
    detectIntercetionWithBoundary = false; // assume the new circle is not going to collide with the boundary

    /* 
     We must divide d + newD because they are both diameters. We want to find what both radius's values are added on. 
     However without it gives the balls a cool forcefeild type gap.
     
     Returns true if there is a collsions with any existing ellipse or the boundary
     
     */
    // look for intercection with left boundary
    if (newLoc.x - newD/2 <= margin ) {
      detectIntercetionWithBoundary = true;
    }


    // look for intercection with right boundary
    if (newLoc.x + newD/2 >= width - margin ) {
      detectIntercetionWithBoundary = true;
    }


    // look for intercection with top boundary
    if (newLoc.y - newD/2 <= margin ) {
      detectIntercetionWithBoundary = true;
    }


    // look for intercection with bottom boundary
    if (newLoc.y + newD/2 >= height - margin ) {
      detectIntercetionWithBoundary = true;
    }


    if (dist(loc.x, loc.y, newLoc.x, newLoc.y) < ((d + newD)* 0.55)) {

      detectIntercetionWithExistingCircles = true;
      //     println("Intercetion With Existing Circles = true");
    }

    if (( detectIntercetionWithExistingCircles == true) | (detectIntercetionWithBoundary == true)) {
      //    println("detectCollision = true");
      detectCollision = true;
    }

    //  detectCollision = false;

    return detectCollision;
  }
}


void mouseClicked() {
  save("clicked.png");
  //  exit();
}
