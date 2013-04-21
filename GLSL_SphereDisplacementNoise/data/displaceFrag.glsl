
uniform sampler2D colorMap;

void main(void) {
	gl_FragColor = texture2D(colorMap, gl_TexCoord[0].xy);
}
