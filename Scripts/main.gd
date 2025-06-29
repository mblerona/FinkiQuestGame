extends Node

@onready var minimap = $Minimap/SubViewportContainer/SubViewport
@onready var player = $StudentPlayer

func _ready():
	minimap.set_player(player)
	
	var level1 = get_node_or_null("Level1")
	if level1:
		_update_minimap_professors(level1)

func switch_to_level2():
	_switch_level("Level1", "res://Scenes/level_2.tscn", "Level2")

func switch_to_level3():
	_switch_level("Level2", "res://Scenes/level_3.tscn", "Level3")

func switch_to_level4():
	_switch_level("Level3", "res://Scenes/level_4.tscn", "Level4")

func _switch_level(current_name: String, next_scene_path: String, next_name: String):
	var current = get_node_or_null(current_name)
	if current:
		current.queue_free()
	var next_level = load(next_scene_path).instantiate()

	next_level.name = next_name
	add_child(next_level)

	var spawn_point = next_level.get_node_or_null("PlayerSpawn")
	if spawn_point:
		player.global_position = spawn_point.global_position
	
	await get_tree().process_frame
	_update_minimap_professors(next_level)

func _update_minimap_professors(level):
	if level.has_method("get_professors"):
		var profs = level.get_professors()
		minimap.set_professors(profs)
