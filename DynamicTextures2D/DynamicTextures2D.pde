
/*

 Dynamic Textures 2D by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating textured QUADS with dynamically generated texture coordinates.
 With the OpenGL renderer this can be done at interactive framerates.

 HORIZONTAL MOUSE MOVE = change the density of the grid

 Built with Processing 1.5.1

*/

import processing.opengl.*;

int DIM, NUMQUADS;
PImage img;

void setup() {
  img = loadImage("image.jpg");
  size(img.width*2, img.height, OPENGL);
  textureMode(NORMALIZED);
  noStroke();
}

void draw() {
  background(0);
  DIM = (int) map(mouseX, 0,width, 1, 40);
  NUMQUADS = DIM*DIM;
  beginShape(QUAD);
  texture(img);
  for (int i=0; i<NUMQUADS; i++) {
    drawQuad(i, int(i+noise(i+frameCount*0.001)*NUMQUADS)%NUMQUADS);
  }
  endShape();
  image(img, width/2, 0);
  frame.setTitle(int(frameRate) + " fps");
}

void drawQuad(int indexPos, int indexTex) {
  float x1 = float(indexPos%DIM)/DIM*width/2;
  float y1 = float(indexPos/DIM)/DIM*height;
  float x2 = float(indexPos%DIM+1)/DIM*width/2;
  float y2 = float(indexPos/DIM+1)/DIM*height;

  float x1Tex = float(indexTex%DIM)/DIM;
  float y1Tex = float(indexTex/DIM)/DIM;
  float x2Tex = float(indexTex%DIM+1)/DIM;
  float y2Tex = float(indexTex/DIM+1)/DIM;

  vertex(x1, y1, x1Tex, y1Tex);
  vertex(x2, y1, x2Tex, y1Tex);
  vertex(x2, y2, x2Tex, y2Tex);
  vertex(x1, y2, x1Tex, y2Tex);
}

