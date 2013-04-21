Geometry, Textures & Shaders Tutorial for CAN
===================================

Examples for an upcoming tutorial I'm preparing for [CreativeApplications.net](http://www.creativeapplications.net/).
This is work-in-progress source code! Still searching for the exact focus of the blog post.
All code examples built with [Processing 1.5.1.](http://processing.org/download/) and in most cases [GLGraphics 1.0.0](http://glgraphics.sourceforge.net/).
Once Processing 2.0 final is out, I'll port these code examples to the new & improved OpenGL renderer.
Code tested & working under Windows (7 x64 and XP SP3 x32) for both NVIDIA (GTX 570M) and Radeon (HD 4800).

####Custom2DGeometry
Creating a custom 2D shape with interpolated colors using beginShape-vertex-endShape.

####DynamicTextures2D
Creating textured QUADS with dynamically generated texture coordinates.

####GLSL_Heightmap
Creating a heightmap through GLSL with separate color and displacement maps that can be changed in realtime.

####GLSL_HeightmapNoise
Creating a GLSL heightmap running on shader-based procedural noise instead of a displacement map texture.

####GLSL_SphereDisplacement
Displacing a sphere outwards through GLSL with separate color and displacement maps that can be changed in realtime.

####MultiTexturedSphereGLSL
Applying a GLSL shader with multiple input textures to the TexturedSphere example.

####Texture2DAnimation
Creating an animation by using texture coordinates to read from a spritesheet.

####TexturedSphere
Creating a correctly textured sphere by subdividing an icosahedron. Using GLGraphics to store / display the shape.

####TexturedSphereGLSL
Adding a basic GLSL shader for dynamic lighting to the TexturedSphere example. Shows how to apply shaders to a GLModel.
