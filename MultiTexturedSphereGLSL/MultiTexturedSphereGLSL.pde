
/*

 Multi-textured Sphere GLSL by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a multi-textured sphere by subdividing an icosahedron.
 Using the GLGraphics' GLModel to store and display the shape.
 Using a GLSL shader to display the shape using multiple textures.
 
 MOUSE CLICK + DRAG = arcball around the sphere

 +/- = zoom out / zoom in
 w = toggle wireframe or textured view
 c = toggle clouds texture layer
 l = toggle light source or night view

 Built with Processing 1.5.1 + GLGraphics 1.0.0

 Free low-resolution earth textures (day, night, specular, clouds) courtesy of:
 http://planetpixelemporium.com/earth.html
 For higher quality visuals, higher resolution textures are advised.

*/

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

GLGraphics renderer; // the main GLGraphics renderer
GLModel earth; // GLModel to hold the geometry, textures, texture coordinates etc.
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float zoom = 250; // scale factor aka zoom
boolean useWireframe = false; // boolean to toggle wireframe of textured view
boolean useClouds = true; // boolean to toggle clouds texture layer
boolean useLight = true; // toggle light source or night view

PVector rotation = new PVector(); // vector to store the rotation
PVector velocity = new PVector(); // vector to store the change in rotation
float rotationSpeed = 0.02; // the rotation speed
float timeSpeed = 0.00025; // the speed of time (relevant for the movement of the clouds)

GLModelEffect shader; // GLSL shader that can be applied to a GLModel

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS); // use the GLGraphics renderer
  renderer = (GLGraphics) g; // create a hook to the main renderer
  earth = createIcosahedron(subdivisionLevel); // create the subdivided icosahedron GLModel (see custom creation method) and put it in the global earth reference
  shader = new GLModelEffect(this, "shader.xml"); // load the GLSL shader from xml (pointing to frag and vert shaders)
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

  // set the lightPosition according to sin/cos or set it to something far away
  shader.setParameterValue("LightPosition", new  float[] { useLight?sin(frameCount*0.01)*800:0, 0, useLight?cos(frameCount*0.01)*800:-10000 } );
  shader.setParameterValue("Time", frameCount * timeSpeed ); // feed time to the shader (for the movement of the clouds)
  shader.setParameterValue("useClouds", useClouds?1.0:0.0 ); // toggle the use of clouds through a float value (1 or 0)
  renderer.model(earth, shader); // render the GLModel and apply the shader

  renderer.endGL(); // place draw calls between the begin/endGL() calls

  // write the fps in the top-left of the window
  frame.setTitle(" " + int(frameRate));
}

void keyPressed() {
  if (key == 'w') { useWireframe = !useWireframe; } // toggle wireframe or textured view
  if (key == 'c') { useClouds = !useClouds; } // toggle clouds texture layer
  if (key == 'l') { useLight = !useLight; } // light source or night view
}

