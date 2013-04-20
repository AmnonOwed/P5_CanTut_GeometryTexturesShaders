
/*

 GLSL Sphere Displacement by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a sphere by subdividing an icosahedron. Storing it in a GLGraphics' GLModel.
 Displacing it outwards with GLSL (fragment and vertex) shaders based on input textures.
 The input textures for both the color and the displacement can be changed in realtime.

 c = cycle through the color maps
 d = cycle through the displacement maps
 w = toggle wireframe or textured view

 Built with Processing 1.5.1 + GLGraphics 1.0.0

 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.

*/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;

int subdivisionLevel = 8;
int dim = 300;
int blurFactor = 3;
float resizeFactor = 0.2;
float displaceStrength = 3.5;
boolean useWireframe = true;

GLGraphics renderer;
GLModel sphere;
GLModelEffect displace;

PImage[] images = new PImage[3];
GLTexture texColorMap, texDisplacementMap;
int currentColorMap, currentDisplacementMap = 2;

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS);

  images[0] = loadImage("Texture01.jpg");
  images[1] = loadImage("Texture02.jpg");
  images[2] = loadImage("Texture03.jpg");

  renderer = (GLGraphics) g;
  sphere = createIcosahedron(subdivisionLevel);
  displace = new GLModelEffect(this, "displace.xml");
}

void draw() {
  lights();
  translate(width/2, height/2, 0);
  rotateX(radians(60));
  rotateZ(frameCount*0.01);

  renderer.beginGL();

  GL gl = renderer.gl;

  background(0);
  perspective(PI/3.0, (float) width/height, 0.1, 1000000);
  scale(100);

  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  displace.setParameterValue("displaceStrength", displaceStrength);
  renderer.model(sphere, displace);

  renderer.endGL();

  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap + " | displacementMap: " + currentDisplacementMap);
}

void setColorMap(int num) {
  texColorMap.putImage(images[num]);
}

void setDisplacementMap(int num) {
  PImage imgCopy = images[num].get();
  imgCopy.resize(int(imgCopy.width*resizeFactor), int(imgCopy.height*resizeFactor));
  if (blurFactor >= 1) { imgCopy.filter(BLUR, blurFactor); }
  imgCopy.resize(images[num].width, images[num].height);
  texDisplacementMap.putImage(imgCopy);
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%images.length; setColorMap(currentColorMap); }
  if (key == 'd') { currentDisplacementMap = ++currentDisplacementMap%images.length; setDisplacementMap(currentDisplacementMap); }
  if (key == 'w') { useWireframe = !useWireframe; }
}

