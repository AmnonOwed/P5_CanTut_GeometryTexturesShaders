
/*

 Noise-Based GLSL Heightmap by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a GLSL heightmap running on shader-based procedural noise.

 c = cycle through the color maps
 w = toggle wireframe or textured view

 Built with Processing 1.5.1 + GLGraphics 1.0.0

 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.

*/

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

int dim = 300; // the grid dimensions of the heightmap
int blurFactor = 3; // the blur for the displacement map (to make it smoother)
float resizeFactor = 0.25; // the resize factor for the displacement map (to make it smoother)
float displaceStrength = 0.25; // the displace strength of the GLSL shader displacement effect
boolean useWireframe = true; // boolean to toggle wireframe of textured view

GLGraphics renderer; // the main GLGraphics renderer
GLModel heightMap; // GLModel to hold the geometry, textures, texture coordinates etc.
GLModelEffect displace; // GLSL shader that can be applied to a GLModel

PImage[] images = new PImage[2]; // array to hold 2 input images
GLTexture texColorMap; // the colorMap GLTexture
int currentColorMap; // variables to keep track of the current colorMap

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS); // use the GLGraphics renderer

  // load the images from the _Images folder (relative path from this sketch's folder)
  images[0] = loadImage("../_Images/Texture01.jpg");
  images[1] = loadImage("../_Images/Texture02.jpg");

  renderer = (GLGraphics) g; // create a hook to the main renderer
  heightMap = createPlane(dim, dim); // create the heightmap GLModel (see custom creation method) and put it in the global heightMap reference
  displace = new GLModelEffect(this, "displace.xml"); // load the GLSL shader from xml (pointing to frag and vert shaders)
  displace.setParameterValue("displaceStrength", displaceStrength); // set the displaceStrength
}

void draw() {
  translate(width/2, height/2); // translate to center of the screen
  rotateX(radians(60)); // fixed rotation of 60 degrees over the X axis
  rotateZ(frameCount*0.005); // dynamic frameCount-based rotation over the Z axis

  renderer.beginGL(); // place draw calls between the begin/endGL() calls

  GL gl = renderer.gl; // get gl instance for direct opengl calls

  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  scale(750); // scale by 750 (the model itself is unit length

  // toggle wireframe or textured view
  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  displace.setParameterValue("time", millis()/5000.0); // feed time to the GLSL shader
  renderer.model(heightMap, displace); // render the GLModel and apply the GLSL shader to it

  renderer.endGL(); // place draw calls between the begin/endGL() calls

  // write the fps and the current colorMap in the top-left of the window
  frame.setTitle(" " + int(frameRate) + " | colorMap: " + currentColorMap);
}

// custom method to create a GLModel plane with certain xy dimensions
GLModel createPlane(int xsegs, int ysegs) {

  // STEP 1: create all the relevant data
  
  ArrayList <PVector> positions = new ArrayList <PVector> (); // arrayList to hold positions
  ArrayList <PVector> texCoords = new ArrayList <PVector> (); // arrayList to hold texture coordinates

  float usegsize = 1 / (float) xsegs; // horizontal stepsize
  float vsegsize = 1 / (float) ysegs; // vertical stepsize

  for (int x=0; x<xsegs; x++) {
    for (int y=0; y<ysegs; y++) {
      float u = x / (float) xsegs;
      float v = y / (float) ysegs;

      // generate positions for the vertices of each cell (-0.5 to center the shape around the origin)
      positions.add( new PVector(u-0.5, v-0.5, 0) );
      positions.add( new PVector(u+usegsize-0.5, v-0.5, 0) );
      positions.add( new PVector(u+usegsize-0.5, v+vsegsize-0.5, 0) );
      positions.add( new PVector(u-0.5, v+vsegsize-0.5, 0) );

      // generate texture coordinates for the vertices of each cell
      texCoords.add( new PVector(u, v) );
      texCoords.add( new PVector(u+usegsize, v) );
      texCoords.add( new PVector(u+usegsize, v+vsegsize) );
      texCoords.add( new PVector(u, v+vsegsize) );
    }
  }

  // STEP 2: put all the relevant data into the GLModel
  
  // create GLModel with positions.size() vertices of type QUADS and make it static (the vertices don't change)
  GLModel mesh = new GLModel(this, positions.size(), QUADS, GLModel.STATIC);

  mesh.updateVertices(positions); // put the arrayList of positions into the mesh

  // prepare all the settings with regard to textures and texture coordinates
  mesh.initTextures(1); // initialize 1 texture (colorMap), since displacement is noise-driven
  mesh.updateTexCoords(0, texCoords); // load the texture coordinates for texture 0
  texColorMap = new GLTexture(this); // initialize GLTexture
  mesh.setTexture(0, texColorMap); // connect colorMap to the first texture slot
  setColorMap(currentColorMap); // set the colorMap (see custom method)

  // no displacementMap is set, because displacement is 100% noise-driven in the vertex shader

  return mesh; // our work is done here, return DA MESH! ;-)
}

// a separate setColorMap method, so the image can be change dynamically
void setColorMap(int num) {
  texColorMap.putImage(images[num]); // put the image in the GLTexture
}

void keyPressed() {
  if (key == 'c') { currentColorMap = ++currentColorMap%images.length; setColorMap(currentColorMap); } // cycle through colorMaps (set variable and call setColormap method)
  if (key == 'w') { useWireframe = !useWireframe; } // toggle wireframe or textured view
}

