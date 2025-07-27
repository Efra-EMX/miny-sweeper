shader_type canvas_item;

uniform vec4 color: source_color = vec4(1);

void fragment() {
	float a = (sin(TIME*10.0) + 1.0) / 5.0;

	COLOR = texture(TEXTURE, UV);
	if (COLOR.a > 0.0) {
		COLOR.a = a;
	}
}
