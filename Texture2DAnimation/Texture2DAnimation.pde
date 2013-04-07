
/*

 Texture 2D Animation by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating an animation by using texture coordinates to read from a spritesheet.
 An individual offset can be used to differentiate the current frame for each instance.
 
 MOUSE MOVE = change the scale of individual instances based on the distance from the mouse
              (note that a negative scale is possible, this will scale AND invert the shape!)

 Built with Processing 1.5.1
 Spritesheet created by Amnon Owed using Illustrator's blend mode (not recommended! ;-)

*/

import processing.opengl.*;

PImage spritesheet;
int DIM = 6;
int NUMSHAPES = 300;
int W, H;

void setup() {
  size(1280, 720, OPENGL);
  spritesheet = loadImage("animation.png");
  W = spritesheet.width/DIM;
  H = spritesheet.height/DIM;
  textureMode(IMAGE);
  noStroke();
}

void draw() {
  int dmod = frameCount%510;
  int col = dmod<255?dmod:510-dmod;

  beginShape();
  fill(255, col, 0);
  vertex(0, 0);
  vertex(width, 0);
  fill(0, 255, 255-col);
  vertex(width, height);
  vertex(0, height);
  endShape();

  randomSeed(0);
  for (int i=0; i<NUMSHAPES; i++) {
    pushMatrix();
    float px = random(width);
    float py = random(height);
    translate(px, py);
    scale(map(dist(px, py, mouseX, mouseY), 0, width/2, 150, 15));
    int fi = frameCount+i;
    int x = fi%DIM*W;
    int y = fi/DIM%DIM*H;
    beginShape();
    texture(spritesheet);
    vertex(0, 0, x, y);
    vertex(1, 0, x+W, y);
    vertex(1, 1, x+W, y+H);
    vertex(0, 1, x, y+H);
    endShape();
    popMatrix();
  }

  frame.setTitle(int(frameRate) + " fps");
}

