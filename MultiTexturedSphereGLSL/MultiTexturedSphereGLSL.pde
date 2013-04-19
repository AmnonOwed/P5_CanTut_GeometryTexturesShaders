
/*

 Multi-textured Sphere GLSL by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon

 Creating a multi-textured sphere by subdividing an icosahedron.
 Using the GLGraphics' GLModel to store and display the shape.
 Using a GLSL shader to display the shape using multiple textures.
 
 MOUSE CLICK + DRAG = arcball around the sphere

 +/- = zoom out / zoom in
 w = toggle wireframe or textured view
 c = toggle clouds texture layer
 l = toggle rotating light source

 Built with Processing 1.5.1 + GLGraphics 1.0.0

 Free low-resolution earth textures (day, night, specular, clouds) courtesy of:
 http://planetpixelemporium.com/earth.html
 For higher quality visuals, higher resolution textures are advised.

*/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;

GLGraphics renderer;
GLModel earth;
float zoom = 250;
boolean useWireframe = false;
boolean useClouds = true;
boolean useLight = true;

PVector rotation = new PVector();
PVector velocity = new PVector();
float rotationSpeed = 0.02;
float timeSpeed = 0.00025;

GLModelEffect shader;

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS);
  renderer = (GLGraphics) g;
  earth = createIcosahedron(6);
  shader = new GLModelEffect(this, "shader.xml");
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
  
  if (!useWireframe) { gl.glPolygonMode( GL.GL_FRONT_AND_BACK, GL.GL_FILL ); }
  else { gl.glPolygonMode(GL.GL_FRONT_AND_BACK, GL.GL_LINE); }

  shader.setParameterValue("LightPosition", new  float[] { useLight?sin(frameCount*0.01)*800:0, 0, useLight?cos(frameCount*0.01)*800:-1000 } );
  shader.setParameterValue("Time", frameCount * timeSpeed );
  shader.setParameterValue("useClouds", useClouds?1.0:0.0 );
  renderer.model(earth, shader);

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
  if (key == 'w') { useWireframe = !useWireframe; }
  if (key == 'c') { useClouds = !useClouds; }
  if (key == 'l') { useLight = !useLight; }
}

