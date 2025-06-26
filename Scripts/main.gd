#extends Node
#
#func switch_to_level2():
	#var level1 = get_node("Level1")
	#if level1:
		#level1.queue_free()
	#var level2 = preload("res://Scenes/level_2.tscn").instantiate()
	#level2.name = "Level2"
	#add_child(level2)
#
#func switch_to_level3():
	#var level2 = get_node("Level2")
	#if level2:
		#level2.queue_free()
	#var level3 = preload("res://Scenes/level_3.tscn").instantiate()
	#level3.name = "Level3"
	#add_child(level3)
#
#func switch_to_level4():
	#var level3 = get_node("Level3")
	#if level3:
		#level3.queue_free()
	#var level4 = preload("res://Scenes/level_4.tscn").instantiate()
	#level4.name = "Level4"
	#add_child(level4)




extends Node

@onready var minimap = $Minimap/SubViewportContainer/SubViewport
@onready var player = $StudentPlayer

func _ready():
	minimap.set_player(player)
	# If Level1 is already loaded in the scene tree, get professors
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

	# Give some time for level to load and spawn professors (1 frame delay)
	await get_tree().process_frame
	_update_minimap_professors(next_level)

func _update_minimap_professors(level):
	if level.has_method("get_professors"):
		var profs = level.get_professors()
		minimap.set_professors(profs)
