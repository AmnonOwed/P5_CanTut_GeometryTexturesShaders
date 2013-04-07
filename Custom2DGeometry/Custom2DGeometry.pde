
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
 
int NUMSEGMENTS = 21;
float DIAM_INNER = 100;
float DIAM_OUTER = 250;
 
color[] colsInner = new color[NUMSEGMENTS];
color[] colsOuter = new color[NUMSEGMENTS];
float[] tx = new float[NUMSEGMENTS];
float[] ty = new float[NUMSEGMENTS];
 
void setup() {
  size(700, 700, OPENGL);
  float step = TWO_PI/NUMSEGMENTS;
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
  for (int i=0; i<NUMSEGMENTS+1; i++) {
    int im = i%NUMSEGMENTS;
    fill(colsInner[im]);
    float dynamicInner = 0.5 + noise(frameCount*0.01+im);
    vertex(tx[im]*DIAM_INNER*dynamicInner, ty[im]*DIAM_INNER*dynamicInner);
    fill(colsOuter[im]);
    float dynamicOuter = 0.5 + noise(frameCount*0.02+im);
    vertex(tx[im]*DIAM_OUTER*dynamicOuter, ty[im]*DIAM_OUTER*dynamicOuter);
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

