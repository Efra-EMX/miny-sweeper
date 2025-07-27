shader_type canvas_item;
uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	COLOR = texture(TEXTURE, UV);

	if (COLOR == vec4(1.0, 1.0, 1.0, 1.0)) {
		COLOR = color1;
	}

	if (COLOR == vec4(0.0, 0.0, 0.0, 1.0)) {
		COLOR = color2;
	}
}