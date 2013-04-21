
/*

 GLSL Sphere Displacement by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a sphere by subdividing an icosahedron. Storing it in a GLGraphics' GLModel.
 Displacing it outwards through GLSL with shader-based procedural noise.

 c = cycle through the color maps
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
float displaceStrength = 0.75;
boolean useWireframe = true;

GLGraphics renderer;
GLModel sphere;
GLModelEffect displace;

PImage[] images = new PImage[2];
GLTexture texColorMap;
int currentColorMap = 1;

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS);

  images[0] = loadImage("../_Images/Texture01.jpg");
  images[1] = loadImage("../_Images/Texture02.jpg");

  renderer = (GLGraphics) g;
  sphere = createIcosahedron(subdivisionLevel);
  displace = new GLModelEffect(this, "displace.xml");
}

void draw() {
  lights();
  translate(width/2, height/2, 0);
  rotateX(radians(60));
  rotateZ(frameCount*0.005);

  renderer.beginGL();

  GL gl = renderer.gl;

  background(0);
  perspective(PI/3.0, (float) width/height, 0.1, 1000000);
  scale(200);

  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  displace.setParameterValue("displaceStrength", displaceStrength);
  displace.setParameterValue("time", millis()/5000.0);
  renderer.model(sphere, displace);

  renderer.endGL();

  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap);
}

void setColorMap(int num) {
  texColorMap.putImage(images[num]);
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%images.length; setColorMap(currentColorMap); }
  if (key == 'w') { useWireframe = !useWireframe; }
}

