
/*

 Textured Sphere by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a textured sphere by subdividing an icosahedron.
 Using the GLGraphics' GLModel to store and display the shape.
 
 The benefits of the current creation method are:
 1. Even distribution of vertices over the sphere
 2. No seam or pole problems in the texture coordinates
 
 MOUSE CLICK + DRAG = arcball around the sphere

 +/- = zoom out / zoom in
 w = toggle wireframe or textured view

 Built with Processing 1.5.1 + GLGraphics 1.0.0

*/

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

GLGraphics renderer; // the main GLGraphics renderer
GLModel earth; // GLModel to hold the geometry, textures, texture coordinates etc.
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float zoom = 250; // scale factor aka zoom
boolean useWireframe; // boolean to toggle wireframe of textured view

PVector rotation = new PVector(); // vector to store the rotation
PVector velocity = new PVector(); // vector to store the change in rotation
float rotationSpeed = 0.02; // the rotation speed

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS); // use the GLGraphics renderer
  renderer = (GLGraphics) g; // create a hook to the main renderer
  earth = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron GLModel (see custom creation method) and put it in the global earth reference
}

void draw() {      
  renderer.beginGL(); // place draw calls between the begin/endGL() calls

  GL gl = renderer.gl; // get gl instance for direct opengl calls

  // toggle wireframe or textured view
  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  background(0); // black background
  perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
  translate(width/2, height/2); // translate to center of the screen

  // set rotation velocity with mouse drag
  if (mousePressed) {
    velocity.x -= (mouseY-pmouseY) * 0.01;
    velocity.y += (mouseX-pmouseX) * 0.01;
  }

  rotation.add(velocity); // add rotation velocity to rotation
  velocity.mult(0.95); // diminish the rotation velocity on each draw()

  rotateX(rotation.x*rotationSpeed); // rotation over the X axis
  rotateY(rotation.y*rotationSpeed); // rotation over the Y axis

  // zoom out/in with the -/+ keys
  if (keyPressed) {
    if (key == '-') { zoom -= 3; }
    if (key == '+') { zoom += 3; }
  }
  scale(zoom); // set the scale/zoom level
  
  renderer.model(earth); // render the GLModel

  renderer.endGL(); // place draw calls between the begin/endGL() calls

  // write the fps in the top-left of the window
  frame.setTitle(" " + int(frameRate));
}

void keyPressed() {
  if (key == 'w') { useWireframe = !useWireframe; } // toggle wireframe or textured view
}

