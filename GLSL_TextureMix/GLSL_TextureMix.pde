
/*

 GLSL Texture Mix by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Creating a smooth mix between multiple textures in the fragment shader.
 
 Note: This can also be done using a GLTextureFilter, but I wanted to create an effect that can be applied to a GLModel.
 
 MOUSE PRESS = toggle between three mix types (Subtle, Regular, Obvious)
 
 Built with Processing 1.5.1 + GLGraphics 1.0.0
 
 Photographs by Folkert Gorter (@folkertgorter / http://superfamous.com/) made available under a CC Attribution 3.0 license.
 
*/

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

GLGraphics renderer; // the main GLGraphics renderer
GLModel mesh; // GLModel to hold the mesh, here just a simple QUAD
GLModelEffect textureMix; // GLSL shader that can be applied to a GLModel
GLTexture[] images = new GLTexture[3]; // array to hold 3 GLTextures
int mixType; // variable to set the current mixType
int maxTypes = 3; // variable used to keep the sketch within the maximum number of types (defined in the shader)

void setup() {
  size(1150, 850, GLConstants.GLGRAPHICS); // use the GLGraphics renderer

  renderer = (GLGraphics) g; // create a hook to the main renderer

  // load the images from the _Images folder (relative path from this sketch's folder) into the GLTexture array
  images[0] = new GLTexture(this, "../_Images/Texture01.jpg");
  images[1] = new GLTexture(this, "../_Images/Texture02.jpg");
  images[2] = new GLTexture(this, "../_Images/Texture03.jpg");

  // create a basic GLModel with 4 vertices (a single QUAD) and make it static (the vertices don't change)
  mesh = new GLModel(this, 4, QUADS, GLModel.STATIC);

  // set the 4 vertices in the GLModel (unit length)
  mesh.beginUpdateVertices();
  mesh.updateVertex(0, 0, 0);
  mesh.updateVertex(1, 1, 0);
  mesh.updateVertex(2, 1, 1);
  mesh.updateVertex(3, 0, 1);
  mesh.endUpdateVertices();

  // initialize the textures and put them in the GLModel
  mesh.initTextures(images.length);
  for (int i=0; i<images.length; i++) {
    mesh.setTexture(i, images[i]);
  }

  // set the 4 texture coordinates in the GLModel (unit length)
  mesh.beginUpdateTexCoords(0);
  mesh.updateTexCoord(0, 0, 0);
  mesh.updateTexCoord(1, 1, 0);
  mesh.updateTexCoord(2, 1, 1);
  mesh.updateTexCoord(3, 0, 1);
  mesh.endUpdateTexCoords();

  // load the GLSL shader from xml (pointing to frag and vert shaders)
  textureMix = new GLModelEffect(this, "textureMix.xml");
}

void draw() {
  background(0); // black background
  
  // display the 3 original textures on the right
  for (int i=0; i<images.length; i++) {
    pushMatrix();
    translate(875, 25+i*275); // set the position
    image(images[i], 0, 0, 250, 250); // display the texture in thumbnail style (250x250)
    popMatrix();
  }
  
  // the GLSL-based texture mix
  renderer.beginGL(); // place GLGraphics-related draw calls between the begin/endGL() calls
  renderer.scale(850, 850); // scale by 850, since the GLModel is in unit length
  textureMix.setParameterValue("mixType", mixType); // set the mixType
  textureMix.setParameterValue("time", millis()/5000.0); // feed time to the GLSL shader
  renderer.model(mesh, textureMix); // render the GLModel and apply the GLSL shader to it
  renderer.endGL(); // place GLGraphics-related draw calls between the begin/endGL() calls

  // write the fps and the current mixType (in words through some ?: trickery) in the top-left of the window
  frame.setTitle(" " + int(frameRate) + " | mixType: " + (mixType==0?"Subtle":mixType==1?"Regular":"Obvious"));
}

void mousePressed() {
  mixType = ++mixType%maxTypes; // cycle trough mixTypes
}

