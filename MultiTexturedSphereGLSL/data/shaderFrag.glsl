// Fragment shader for drawing the earth with multiple textures

uniform sampler2D EarthDay;
uniform sampler2D EarthNight;
uniform sampler2D EarthGloss;
uniform sampler2D EarthClouds;
uniform float Time;
uniform float useClouds;

varying float Diffuse;
varying vec3  Specular;
varying vec2  TexCoord;

void main() {
	float gloss	   = texture2D(EarthGloss, TexCoord).r;
	float clouds   = texture2D(EarthClouds, vec2(TexCoord.x+Time, TexCoord.y)).r;
	clouds *= useClouds;
	
    vec3 daytime   = (texture2D(EarthDay, TexCoord).rgb * Diffuse + Specular * gloss) * (1.0 - clouds) + clouds * Diffuse;
    vec3 nighttime = texture2D(EarthNight, TexCoord).rgb * (1.0 - clouds) * 2.0;

    vec3 color = daytime;

    if (Diffuse < 0.1)
        color = mix(nighttime, daytime, (Diffuse + 0.1) * 5.0);

    gl_FragColor = vec4(color, 1.0);
}
