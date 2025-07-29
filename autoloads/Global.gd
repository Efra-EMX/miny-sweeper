extends Node

const direction_vectors: Dictionary[StringName, Vector2i] = {
	&"right"		: Vector2i.RIGHT,
	&"left"			: Vector2i.LEFT,
	&"up"			: Vector2i.UP,
	&"down"			: Vector2i.DOWN,
	&"upLeft"		: Vector2i(-1, -1),
	&"upRight"		: Vector2i(1, -1),
	&"downLeft"		: Vector2i(-1, 1),
	&"downRight"	: Vector2i(1, 1)
}

var terrain: Terrain
var player: Character
var stage: Stage
