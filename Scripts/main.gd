extends Node

func switch_to_level2():
	var level1 = get_node("Level1")
	if level1:
		level1.queue_free()
	var level2 = preload("res://Scenes/level_2.tscn").instantiate()
	level2.name = "Level2"
	add_child(level2)

func switch_to_level3():
	var level2 = get_node("Level2")
	if level2:
		level2.queue_free()
	var level3 = preload("res://Scenes/level_3.tscn").instantiate()
	level3.name = "Level3"
	add_child(level3)

func switch_to_level4():
	var level3 = get_node("Level3")
	if level3:
		level3.queue_free()
	var level4 = preload("res://Scenes/level_4.tscn").instantiate()
	level4.name = "Level4"
	add_child(level4)
