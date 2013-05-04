
void main()
{
 	gl_TexCoord[0].xy = gl_MultiTexCoord0.xy; // pass texture coordinates to the fragment shader

    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; // apply modelViewProjection matrix to vertex to determine final position
}