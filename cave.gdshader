shader_type spatial;

varying float height;
varying float n;
varying vec3 vertex_position;

instance uniform float offset;

uniform sampler2D noise;

void vertex() {
    vertex_position = VERTEX.xyz;// (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float d = 1. - UV.y* NORMAL.z - 1.*abs(NORMAL.y) - 1.*abs(NORMAL.x);
	ALBEDO = (1. - pow(.1/d,2.)) * vec3(.9, .3, .1);
	//ALBEDO = vec3(0.);
	//ALBEDO.r = vertex_position.x/20.;
	
	vec2 uv = fract(vertex_position.xy/vec2(20., 5)*vec2(1.));
	//ALBEDO.r = uv.x;

	//float stripe = step(.45, abs(UV.x-.5));
	//if (abs(stripe) > 0.) {
		//ALBEDO *= stripe * vec3(1.,0.,0.);
	//}
	//ALBEDO.r = 2./pow(d,2.3);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
