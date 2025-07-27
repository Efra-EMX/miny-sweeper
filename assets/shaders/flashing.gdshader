shader_type canvas_item;

void fragment() {
	float a = (sin(TIME*10.0) + 1.0) / 10.0;

	COLOR = texture(TEXTURE, UV);
	COLOR += vec4(a,a,a,0);
}
