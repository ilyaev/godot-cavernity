shader_type spatial;

varying float height;
varying float n;

instance uniform float offset;

uniform sampler2D noise;

void vertex() {
	n = 0.;
	if (VERTEX.z > 0.) {
		float x = VERTEX.x + offset;
		n = texture(noise, vec2(x/300., .3)).r;
		VERTEX.z += n - .5;
		// VERTEX.z += sin(x) + (n-.5);
	}
	height = 1./VERTEX.z;
	// UV.y *= height;
	COLOR.xyz = vec3(1. - smoothstep(-1., 1., VERTEX.z));
}

void fragment() {
	ALBEDO = COLOR.xyz * vec3(.9, .3, .1);
	ALBEDO = max(ALBEDO, abs(UV.y-.7) * vec3(0.3,.6,0.1));
	ALBEDO *= step(UV.y, .99) * .2;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
