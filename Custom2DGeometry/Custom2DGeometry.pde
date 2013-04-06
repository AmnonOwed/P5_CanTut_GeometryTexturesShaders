
/*

 Custom 2D Geometry by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a custom 2D shape using vertices, beginShape & endShape.
 This example also displays OpenGL's automatic color interpolation between vertices.

 MOUSE PRESS/RELEASE = switch between different shape types
 KEY PRESS = generate random colors

 Built with Processing 1.5.1

*/
 
import processing.opengl.*;
 
int numSegments = 21;
float diamInner = 100;
float diamOuter = 250;
 
color[] colsInner = new color[numSegments];
color[] colsOuter = new color[numSegments];
float[] tx = new float[numSegments];
float[] ty = new float[numSegments];
 
void setup() {
  size(700, 700, OPENGL);
  float step = TWO_PI/numSegments;
  for (int i=0; i<tx.length; i++) {
    float theta = step * i;
    tx[i] = sin(theta);
    ty[i] = cos(theta);
  }
  randomColors();
  smooth();
}
 
void draw() {
  background(0);
  translate(width/2, height/2);
  if (mousePressed) {
    noStroke();
    beginShape(TRIANGLES);
  } else {
    stroke(255);
    beginShape(TRIANGLE_STRIP);
  }
  for (int i=0; i<numSegments+1; i++) {
    int im = i%numSegments;
    fill(colsInner[im]);
    float dynamicInner = 0.5 + noise(frameCount*0.01+im);
    vertex(tx[im]*diamInner*dynamicInner, ty[im]*diamInner*dynamicInner);
    fill(colsOuter[im]);
    float dynamicOuter = 0.5 + noise(frameCount*0.02+im);
    vertex(tx[im]*diamOuter*dynamicOuter, ty[im]*diamOuter*dynamicOuter);
  }
  endShape();
}
 
void randomColors() {
  for (int i=0; i<colsInner.length; i++) {
    colsInner[i] = color(random(255),random(255),random(255));
    colsOuter[i] = color(random(255),random(255),random(255));
  }
}
 
void keyPressed() {
  randomColors();
}

