shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = step(.5, UV.y) * vec3(.0, .5, 0.0);
	ALBEDO += step(.5, 1. - UV.y) * vec3(1.);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
