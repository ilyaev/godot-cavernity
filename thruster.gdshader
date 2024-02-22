shader_type spatial;

varying vec4 col;

void vertex() {
	col = COLOR;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.);
	
	float d = length(UV-.5);
	
	ALBEDO = (1. - smoothstep(.2, .2, d)) * col.rgb;
	ALPHA = ALBEDO.r;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
