shader_type canvas_item;

uniform vec2 direction = vec2(0.0);

void vertex(){
	UV = (VERTEX + TIME * (direction * vec2(-1,1))) * TEXTURE_PIXEL_SIZE;
}