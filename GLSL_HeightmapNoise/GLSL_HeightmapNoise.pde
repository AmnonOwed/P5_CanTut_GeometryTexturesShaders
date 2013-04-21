
/*

 Noise-Based GLSL Heightmap by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a GLSL heightmap running on shader-based procedural noise.

 c = cycle through the color maps
 w = toggle wireframe or textured view

 Built with Processing 1.5.1 + GLGraphics 1.0.0

 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.

*/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;

int dim = 300;
int blurFactor = 3;
float resizeFactor = 0.25;
float displaceStrength = 0.25;
boolean useWireframe = true;

GLGraphics renderer;
GLModel heightMap;
GLModelEffect displace;

PImage[] images = new PImage[2];
GLTexture texColorMap;
int currentColorMap;

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS);

  images[0] = loadImage("Texture01.jpg");
  images[1] = loadImage("Texture02.jpg");

  renderer = (GLGraphics) g;
  heightMap = createPlane(dim, dim);
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
  scale(750);

  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  displace.setParameterValue("displaceStrength", displaceStrength);
  displace.setParameterValue("time", millis()/5000.0);
  renderer.model(heightMap, displace);

  renderer.endGL();

  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap);
}

GLModel createPlane(int xsegs, int ysegs) {
  ArrayList <PVector> positions = new ArrayList <PVector> ();
  ArrayList <PVector> texCoords = new ArrayList <PVector> ();

  float usegsize = 1 / (float) xsegs;
  float vsegsize = 1 / (float) ysegs;

  for (int x=0; x<xsegs; x++) {
    for (int y=0; y<ysegs; y++) {
      float u = x / (float) xsegs;
      float v = y / (float) ysegs;

      positions.add( new PVector(u-0.5f, v-0.5f, 0) );
      positions.add( new PVector(u+usegsize-0.5f, v-0.5f, 0) );
      positions.add( new PVector(u+usegsize-0.5f, v+vsegsize-0.5f, 0) );
      positions.add( new PVector(u-0.5f, v+vsegsize-0.5f, 0) );

      texCoords.add( new PVector(u, v) );
      texCoords.add( new PVector(u+usegsize, v) );
      texCoords.add( new PVector(u+usegsize, v+vsegsize) );
      texCoords.add( new PVector(u, v+vsegsize) );
    }
  }

  GLModel mesh = new GLModel(this, positions.size(), QUADS, GLModel.STATIC);

  // positions
  mesh.updateVertices(positions);

  // texCoords + textures
  mesh.initTextures(1);
  mesh.updateTexCoords(0, texCoords);
  texColorMap = new GLTexture(this);
  mesh.setTexture(0, texColorMap);
  setColorMap(currentColorMap);

  return mesh;
}

void setColorMap(int num) {
  texColorMap.putImage(images[num]);
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%images.length; setColorMap(currentColorMap); }
  if (key == 'w') { useWireframe = !useWireframe; }
}

