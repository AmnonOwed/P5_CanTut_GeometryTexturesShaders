
/*

 Custom 3D Geometry by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Creating custom 3D shapes (pyramids) using vertices, beginShape & endShape.
 This example also displays OpenGL's automatic color interpolation between vertices.

 MOUSE PRESS = toggle between black/white background
 
 Built with Processing 1.5.1
 
*/

import processing.opengl.*;

int NUMSHAPES = 150;
float MAXSPEED = 50;

ArrayList <Pyramid> shapes = new ArrayList <Pyramid> ();
int bg;

void setup() {
  size(1280, 720, OPENGL);
  noStroke();
  smooth();
  for (int i=0; i<NUMSHAPES; i++) {
    float r = random(25, 200);
    float f = random(2, 5);
    shapes.add( new Pyramid(f*r, r) );
  }
}

void draw() {
  background(bg);
  perspective(PI/3.0, (float) width/height, 1, 1000000);
  for (Pyramid p : shapes) {
    p.update();
    p.display();
  }
}

void mousePressed() {
  bg = 255-bg;
}

