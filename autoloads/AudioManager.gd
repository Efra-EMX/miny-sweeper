@tool
extends Node

@export_dir var bgm_folder: String = "res://assets/audio/bgm/"
@export_dir var sfx_folder: String = "res://assets/audio/sfx/"
const audio_formats: PackedStringArray = ["wav", "ogg", "mp3", "sfxr"]
@export var bgm_list: Dictionary
@export var sfx_list: Dictionary
var sfx_nodes: Dictionary
@onready var bgm: AudioStreamPlayer = $BGM

@export var load_button: bool = true:
	set(value):
		if Engine.is_editor_hint():
			load_bgm(bgm_folder)
			load_sfx(sfx_folder)
			print_debug("Loaded")
			return
		print_debug("Not loaded")

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for sfx in $SFX.get_children():
		sfx_nodes[sfx.name] = sfx
		#print_debug(sfx)
	process_mode = PROCESS_MODE_ALWAYS

func play(audio_name: StringName, randomize_pitch: bool = false) -> void:
	if sfx_nodes.has(audio_name):
		if randomize_pitch:
			sfx_nodes[audio_name].pitch_scale = randf_range(0.9, 1)
		sfx_nodes[audio_name].play()

func play_bgm(audio_name: StringName) -> void:
	if bgm_list.has(audio_name):
		if bgm.stream == bgm_list[audio_name]:
			return
		bgm.stream = bgm_list[audio_name]
		bgm.play()

func is_playing(audio_name: StringName) -> bool:
	if sfx_nodes.has(audio_name):
		return sfx_nodes[audio_name].playing
	return false

func is_playing_bgm(audio_name: StringName) -> bool:
	if bgm_list.has(audio_name) && bgm.stream:
		return bgm.stream == bgm_list[audio_name]
	return false

func load_sfx(path: String) -> void:
	sfx_list.clear()
#	var sfx_node: Node = $SFX
#	if sfx_node:
#		sfx_node.free()
#	sfx_node = Node.new()
#	add_child(sfx_node)
#	sfx_node.owner = get_tree().edited_scene_root
#	sfx_node.name = "SFX"
	
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				load_sfx(path+"/"+file_name)
			if file_name.get_extension() == "import":
				file_name = file_name.replace(".import", "")
			if audio_formats.has(file_name.get_extension()):
				sfx_list[file_name.get_basename()] = load(path+"/"+file_name)
			file_name = dir.get_next()
		
		for sfx_name in sfx_list.keys():
			var sfx_node: AudioStreamPlayer = find_child(sfx_name)
			if !sfx_node:
				sfx_node = AudioStreamPlayer.new()
				$SFX.add_child(sfx_node)
				sfx_node.owner = get_tree().edited_scene_root
				sfx_node.name = sfx_name
				sfx_node.max_polyphony = 4
				sfx_node.bus = "sfx"
				print_debug("Created new AudioStreamPlayer: " + sfx_node.name)
			sfx_node.stream = sfx_list[sfx_name]
		return
	print_debug("An error occurred when trying to access SFX path.")

func load_bgm(path: String) -> void:
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				load_bgm(path+"/"+file_name)
			if file_name.get_extension() == "import":
				file_name = file_name.replace(".import", "")
			if audio_formats.has(file_name.get_extension()):
				bgm_list[file_name.get_basename()] = load(path+"/"+file_name)
			file_name = dir.get_next()
		return
	print_debug("An error occurred when trying to access BGM path.")
