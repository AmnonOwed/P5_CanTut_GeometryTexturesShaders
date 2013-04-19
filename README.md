Geometry, Textures & Shaders Tutorial for CAN
===================================

Examples for an upcoming tutorial I'm preparing for [CreativeApplications.net](http://www.creativeapplications.net/).
This is work-in-progress source code! Still searching for the exact focus of the blog post.
All code examples built with [Processing 1.5.1.](http://processing.org/download/) and in some cases [GLGraphics 1.0.0](http://glgraphics.sourceforge.net/).
Once Processing 2.0 final is out, I'll port these code examples to the new & improved OpenGL renderer.
Code tested & working under Windows (XP SP3 x32 / 7 x64) for both Radeon (HD 4800) and NVIDIA (GTX 570M).

####Custom2DGeometry
Creating a custom 2D shape with interpolated colors using beginShape-vertex-endShape

####DynamicTextures2D
Creating textured QUADS with dynamically generated texture coordinates

####MultiTexturedSphereGLSL
Applying a GLSL shader with multiple input textures to the TexturedSphere example.

####Texture2DAnimation
Creating an animation by using texture coordinates to read from a spritesheet

####TexturedSphere
Creating a correctly textured sphere by subdividing an icosahedron. Using GLGraphics to store / display the shape.

####TexturedSphereGLSL
Adding a basic GLSL shader for dynamic lighting to the TexturedSphere example. Shows how to apply shaders to a GLModel.

####Shaders
(TBD) Applying shaders to 3D geometry using the GLGraphics library
