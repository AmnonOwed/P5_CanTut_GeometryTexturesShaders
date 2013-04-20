	
uniform sampler2D displacementMap;
uniform float displaceStrength;

void main(void) {
	vec4 newVertexPos;
	vec4 dv;
	float df;
	
	gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
	
	dv = texture2D( displacementMap, gl_MultiTexCoord0.xy );
	
	df = 0.30*dv.x + 0.59*dv.y + 0.11*dv.z;
	
	newVertexPos = vec4(gl_Normal * df * displaceStrength, 0.0) + gl_Vertex;
	
	gl_Position = gl_ModelViewProjectionMatrix * newVertexPos;
}
