
/*

 GLSL Texture Mix by Amnon Owed (April 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Creating a smooth mix between multiple textures in the fragment shader.
 
 Note: This can also be done using a GLTextureFilter, but I wanted to create an effect that can be applied to a GLModel.
 
 MOUSE PRESS = toggle between three mix types (Subtle, Regular, Obvious)
 
 Built with Processing 1.5.1 + GLGraphics 1.0.0
 
 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.
 
*/

import processing.opengl.*;
import codeanticode.glgraphics.*;
import javax.media.opengl.*;

GLGraphics renderer;
GLModel mesh;
GLModelEffect textureMix;
GLTexture[] images = new GLTexture[3];
int mixType, maxTypes = 3;

void setup() {
  size(1200, 850, GLConstants.GLGRAPHICS);
  renderer = (GLGraphics) g;
  images[0] = new GLTexture(this, "../_Images/Texture01.jpg");
  images[1] = new GLTexture(this, "../_Images/Texture02.jpg");
  images[2] = new GLTexture(this, "../_Images/Texture03.jpg");

  mesh = new GLModel(this, 4, QUADS, GLModel.STATIC);

  mesh.beginUpdateVertices();
  mesh.updateVertex(0, 0, 0);
  mesh.updateVertex(1, 1, 0);
  mesh.updateVertex(2, 1, 1);
  mesh.updateVertex(3, 0, 1);
  mesh.endUpdateVertices();

  mesh.initTextures(images.length);
  for (int i=0; i<images.length; i++) {
    mesh.setTexture(i, images[i]);
  }
  mesh.beginUpdateTexCoords(0);
  mesh.updateTexCoord(0, 0, 0);
  mesh.updateTexCoord(1, 1, 0);
  mesh.updateTexCoord(2, 1, 1);
  mesh.updateTexCoord(3, 0, 1);
  mesh.endUpdateTexCoords();

  textureMix = new GLModelEffect(this, "textureMix.xml");
}

void draw() {
  background(0);
  
  // the 3 original textures
  for (int i=0; i<images.length; i++) {
    pushMatrix();
    translate(900, i*275);
    image(images[i], 25, 25, 250, 250);
    popMatrix();
  }
  
  // the mixture
  renderer.beginGL();
  renderer.scale(900, 900);
  textureMix.setParameterValue("mixType", mixType);
  textureMix.setParameterValue("time", millis()/5000.0);
  renderer.model(mesh, textureMix);
  renderer.endGL();

  frame.setTitle(" " + int(frameRate) + " | mixType: " + (mixType==0?"Subtle":mixType==1?"Regular":"Obvious"));
}

void mousePressed() {
  mixType = ++mixType%maxTypes;
}

