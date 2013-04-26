
/*

 Fixed Moving Textures 2D by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 1. FIXED texture on a MOVING shape
 2. MOVING texture on a MOVING shape
 
 MOUSE RELEASED = display BOTH shapes
 MOUSE PRESSED LEFT = only display MOVING texture on a MOVING shape
 MOUSE PRESSED RIGHT = only display FIXED texture on a MOVING shape
 KEY PRESS = change texture
 
 Built with Processing 1.5.1
 
 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.
 
*/
 
import processing.opengl.*;
 
int NUMSEGMENTS = 21;
float DIAM_FIXED = 350;
float DIAM_INNER = 100;
float DIAM_OUTER = 250;
 
float[] tx = new float[NUMSEGMENTS];
float[] ty = new float[NUMSEGMENTS];
 
PImage[] images = new PImage[3];
int currentImage;
float x, y;
 
void setup() {
  size(800, 800, OPENGL);
  
  images[0] = loadImage("../_Images/Texture01.jpg");
  images[1] = loadImage("../_Images/Texture02.jpg");
  images[2] = loadImage("../_Images/Texture03.jpg");
  currentImage = int(random(images.length));
  
  float step = TWO_PI/NUMSEGMENTS;
  for (int i=0; i<tx.length; i++) {
    float theta = step * i;
    tx[i] = sin(theta);
    ty[i] = cos(theta);
  }
  
  noStroke();
  smooth();
}
 
void draw() {
  background(0);
  image(images[currentImage], 0, 0);
  fill(255, 125+sin(frameCount*0.01)*125);
  rect(0, 0, width, height);
  
  // 1. FIXED texture on a MOVING shape
  if (!mousePressed||mouseButton==RIGHT) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(frameCount*0.01);
    noStroke();
    beginShape(TRIANGLE_FAN);
    texture(images[currentImage]);
    vertex(0, 0, width/2, height/2);
    for (int i=0; i<NUMSEGMENTS+1; i++) {
      int im = i%NUMSEGMENTS;
      x = tx[im]*DIAM_FIXED;
      y = ty[im]*DIAM_FIXED;
      vertex(x, y, x+width/2, y+height/2);
    }
    endShape();
    popMatrix();
  }
  
  // 2. MOVING texture on a MOVING shape
  if (!mousePressed||mouseButton==LEFT) {
    stroke(255);
    beginShape(TRIANGLE_STRIP);
    texture(images[currentImage]);
    for (int i=0; i<NUMSEGMENTS+1; i++) {
      int im = i%NUMSEGMENTS;
      float dynamicInner = 0.5 + noise(frameCount*0.01+im);
      x = width/2+tx[im]*DIAM_INNER*dynamicInner;
      y = height/2+ty[im]*DIAM_INNER*dynamicInner;
      vertex(x, y, x, y);
      float dynamicOuter = 0.5 + noise(frameCount*0.02+im);
      x = width/2+tx[im]*DIAM_OUTER*dynamicOuter;
      y = height/2+ty[im]*DIAM_OUTER*dynamicOuter;
      vertex(x, y, x, y);
    }
    endShape();
  }
}
 
void keyPressed() {
  currentImage = ++currentImage%images.length;
}

