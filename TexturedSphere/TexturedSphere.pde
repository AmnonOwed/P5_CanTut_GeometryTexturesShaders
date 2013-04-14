
/*

 Textured Sphere by Amnon Owed (April 2013)
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

import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;

GLGraphics renderer;
GLModel earth;
float zoom = 250;
boolean wireframe;

PVector rotation = new PVector();
PVector velocity = new PVector();
float rotationSpeed = 0.02;

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS);
  renderer = (GLGraphics) g;
  earth = createIcosahedron(6);
}

void draw() {      
  renderer.beginGL();

  GL gl = renderer.gl;

  background(0);
  translate(width/2, height/2);

  rotateX(rotation.x*rotationSpeed);
  rotateY(rotation.y*rotationSpeed);

  if (keyPressed) {
    if (key == '-') { zoom -= 3; }
    if (key == '+') { zoom += 3; }
  }
  scale(zoom);
  
  if (!wireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  renderer.model(earth);

  renderer.endGL();  

  rotation.add(velocity);
  velocity.mult(0.95);

  if (mousePressed) {
    velocity.x -= (mouseY-pmouseY) * 0.01;
    velocity.y += (mouseX-pmouseX) * 0.01;
  }

  frame.setTitle(" " + int(frameRate));
}

void keyPressed() {
  if (key == 'w') { wireframe = !wireframe; }
}

