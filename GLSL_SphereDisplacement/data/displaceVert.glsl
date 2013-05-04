	
uniform sampler2D displacementMap;
uniform float displaceStrength;

void main(void) {
	gl_TexCoord[0].xy = gl_MultiTexCoord0.xy; // pass texture coordinates to the fragment shader
	
	vec4 dv = texture2D( displacementMap, gl_MultiTexCoord0.xy ); // rgba color of displacement map

	float df = 0.30*dv.r + 0.59*dv.g + 0.11*dv.b; // brightness calculation to create displacement float from rgb values

	vec4 newVertexPos = gl_Vertex + vec4(gl_Normal * df * displaceStrength, 0.0); // regular vertex position + direction * displacementMap * displaceStrength
	
	gl_Position = gl_ModelViewProjectionMatrix * newVertexPos; // apply modelViewProjection matrix to determine final position
}
