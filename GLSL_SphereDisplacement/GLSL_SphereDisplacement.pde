
/*

 GLSL Sphere Displacement by Amnon Owed (May 2013)
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

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

int subdivisionLevel = 8; // number of times the icosahedron will be subdivided
int dim = 300; // the grid dimensions of the heightmap
int blurFactor = 3; // the blur for the displacement map (to make it smoother)
float resizeFactor = 0.2; // the resize factor for the displacement map (to make it smoother)
float displaceStrength = 3.5; // the displace strength of the GLSL shader displacement effect
boolean useWireframe = true; // boolean to toggle wireframe of textured view

GLGraphics renderer; // the main GLGraphics renderer
GLModel sphere; // GLModel to hold the geometry, textures, texture coordinates etc.
GLModelEffect displace; // GLSL shader that can be applied to a GLModel

PImage[] images = new PImage[3]; // array to hold 3 input images
GLTexture texColorMap, texDisplacementMap; // the two GLTextures: colorMap and displacementMap
int currentColorMap, currentDisplacementMap = 2; // variables to keep track of the current maps (also used for setting them)

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS); // use the GLGraphics renderer

  // load the images from the _Images folder (relative path from this sketch's folder)
  images[0] = loadImage("../_Images/Texture01.jpg");
  images[1] = loadImage("../_Images/Texture02.jpg");
  images[2] = loadImage("../_Images/Texture03.jpg");

  renderer = (GLGraphics) g; // create a hook to the main renderer
  sphere = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron GLModel (see custom creation method) and put it in the global sphere reference
  displace = new GLModelEffect(this, "displace.xml"); // load the GLSL shader from xml (pointing to frag and vert shaders)
  displace.setParameterValue("displaceStrength", displaceStrength); // set the displaceStrength
}

void draw() {
  translate(width/2, height/2); // translate to center of the screen
  rotateX(radians(60)); // fixed rotation of 60 degrees over the X axis
  rotateZ(frameCount*0.01); // dynamic frameCount-based rotation over the Z axis

  renderer.beginGL(); // place draw calls between the begin/endGL() calls

  GL gl = renderer.gl; // get gl instance for direct opengl calls

  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  scale(100); // scale by 100

  // toggle wireframe or textured view
  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  renderer.model(sphere, displace); // render the GLModel and apply the GLSL shader to it

  renderer.endGL(); // place draw calls between the begin/endGL() calls

  // write the fps, the current colorMap and the current displacementMap in the top-left of the window
  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap + " | displacementMap: " + currentDisplacementMap);
}

// separate setColorMap and setDisplacementMap methods, so the images can be change dynamically

// method to set the colorMap used in the GLSL shader
void setColorMap(int num) {
  texColorMap.putImage(images[num]); // put the image in the GLTexture
}

// method to set the displacementMap used in the GLSL shader
void setDisplacementMap(int num) {
  PImage imgCopy = images[num].get(); // get a copy so the original remains intact
  imgCopy.resize(int(imgCopy.width*resizeFactor), int(imgCopy.height*resizeFactor)); // resize
  if (blurFactor >= 1) { imgCopy.filter(BLUR, blurFactor); } // apply blur
  imgCopy.resize(images[num].width, images[num].height); // resize
  texDisplacementMap.putImage(imgCopy); // put the image in the GLTexture
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%images.length; setColorMap(currentColorMap); } // cycle through colorMaps (set variable and call setColormap method)
  if (key == 'd') { currentDisplacementMap = ++currentDisplacementMap%images.length; setDisplacementMap(currentDisplacementMap); } // cycle through displacementMaps (set variable and call setDisplacement method)
  if (key == 'w') { useWireframe = !useWireframe; } // toggle wireframe or textured view
}

