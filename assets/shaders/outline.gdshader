shader_type canvas_item;

const vec2 directions[4] = {
	vec2(1,0),
	vec2(-1,0),
	vec2(0,1),
	vec2(0,-1)
};
const vec2 diagonals[4] = {
	vec2(1,1),
	vec2(-1,-1),
	vec2(-1,1),
	vec2(1,-1)
};
uniform vec4 outline_color: source_color = vec4(1);
uniform bool square_mode = true;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (abs(COLOR.a) < 0.0001) {
		for (int i = 0; i < directions.length(); i++) {
			vec4 a = texture(TEXTURE, UV + (directions[i] * TEXTURE_PIXEL_SIZE));
			if (a.a > 0.0) {
				COLOR = outline_color;
				break;
			}
		}
		if (square_mode) {
			for (int i = 0; i < diagonals.length(); i++) {
				vec4 a = texture(TEXTURE, UV + (diagonals[i] * TEXTURE_PIXEL_SIZE));
				if (a.a > 0.0) {
					COLOR = outline_color;
					break;
				}
			}
		}
	}
}
