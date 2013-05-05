
/*

 Textured Sphere GLSL by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a textured sphere by subdividing an icosahedron.
 Using the GLGraphics' GLModel to store and display the shape.
 Using a GLSL shader to display the shape with dynamic lighting.
 
 MOUSE CLICK + DRAG = arcball around the sphere
 MOUSE MOVE = change the lighting position

 +/- = zoom out / zoom in
 w = toggle wireframe or textured view
 s = toggle shader (dynamic lighting) or default view

 Built with Processing 1.5.1 + GLGraphics 1.0.0

 For higher quality visuals, higher resolution textures are advised.

*/

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

GLGraphics renderer; // the main GLGraphics renderer
GLModel earth; // GLModel to hold the geometry, textures, texture coordinates etc.
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float zoom = 250; // scale factor aka zoom
boolean useWireframe; // boolean to toggle wireframe of textured view
boolean useShader = true; // boolean to toggle shader of regular view

PVector rotation = new PVector(); // vector to store the rotation
PVector velocity = new PVector(); // vector to store the change in rotation
float rotationSpeed = 0.02; // the rotation speed

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

  // render the GLModel with or without the shader
  if (useShader) {
    // set the lightPosition according to the mouse position
    shader.setParameterValue("LightPosition", new  float[] { 2*float(mouseX-width/2), 2*float(height/2-mouseY), 0 } );
    renderer.model(earth, shader);
  } else {
    renderer.model(earth);
  }

  renderer.endGL(); // place draw calls between the begin/endGL() calls

  // write the fps in the top-left of the window
  frame.setTitle(" " + int(frameRate));
}

void keyPressed() {
  if (key == 'w') { useWireframe = !useWireframe; } // toggle wireframe or textured view
  if (key == 's') { useShader = !useShader; } // toggle shader or regular view
}

