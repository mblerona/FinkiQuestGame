#extends Node2D
#
#@onready var professor_scene = preload("res://Scenes/Professor.tscn")
#@onready var banner = $LevelBanner
#@onready var retries_label = $UI/Retries
#@onready var passed_label = $UI/Passed
#
#var subjects = ["Calculus", "OOP", "ComputerScience", "WebDesign", "SP"]
#var retries_left = 4
#var passed_count = 0
#var completed_subjects: Array[String] = []
#
#func _ready():
	#print("=== LEVEL 1 INITIALIZED ===")
	#update_ui()
	#banner.show_banner("Level 1\nFind all 5 Professors and complete exams")
	#await get_tree().create_timer(2).timeout
	#spawn_new_professor()
#
#func update_ui():
	#retries_label.text = "Retries left: %d" % retries_left
	#passed_label.text = "Exams passed: %d" % passed_count
	#print("UI UPDATED | Retries:", retries_left, " Passed:", passed_count)
#
#func _on_quiz_result(subject: String, passed: bool) -> void:
	#print("📊 Quiz Result Received | Subject:", subject, " | Passed:", passed)
	#
	#if passed:
		#if !completed_subjects.has(subject):
			#completed_subjects.append(subject)
			#passed_count += 1
			#
			#print("✅ Passed:", subject)
			#await get_tree().create_timer(0.5).timeout
			#spawn_new_professor()
		#else:
			#print("⚠️ Already passed:", subject)
	#else:
		#retries_left -= 1
		#
		#print("❌ Failed:", subject)
	#
#
	#
	#if retries_left == 0:
		#banner.show_banner("❌ Game Over")
		#await get_tree().create_timer(2).timeout
		#get_tree().reload_current_scene()
	#elif completed_subjects.size() == 5:
		#banner.show_banner("🎉 Level Complete!")
#
#func spawn_new_professor():
	#var available_subjects = subjects.filter(func(s): return !completed_subjects.has(s))
	#
	#if available_subjects.is_empty():
		#print("🎓 No more subjects left to assign.")
		#return
	#
	#var chosen_subject = available_subjects[randi() % available_subjects.size()]
	#var professor = professor_scene.instantiate()
	#
	#
	#professor.subject = chosen_subject
	#
	#
	#var player = null
	#
	## Method 1: Direct child
	#player = get_node_or_null("StudentPlayer")
	#if not player:
		## Method 2: Search recursively
		#player = find_child("StudentPlayer", true, false)
	#if not player:
		## Method 3: Search in current scene
		#player = get_tree().current_scene.find_child("StudentPlayer", true, false)
	#if not player:
		## Method 4: Get all nodes and filter
		#var all_nodes = get_tree().get_nodes_in_group("player")  # If player is in a group
		#if all_nodes.size() > 0:
			#player = all_nodes[0]
	#
	#print("🔍 Searching for player...")
	#print("🔍 Level1 children:", get_children().map(func(child): return child.name))
	#print("🔍 Current scene children:", get_tree().current_scene.get_children().map(func(child): return child.name))
	#
	#
	#var existing_bounds = professor.get_node_or_null("MovementBounds")
	#if existing_bounds:
		#existing_bounds.queue_free()
	#
	#
	#var bounds = ReferenceRect.new()
	#bounds.name = "MovementBounds"
	#bounds.size = Vector2(200, 100)
	#bounds.border_color = Color.BLUE
	#bounds.border_width = 2.0
	#bounds.visible = false
	##bounds.position = Vector2.ZERO  # Always local to professor
	#bounds.global_position = professor.global_position - Vector2(100, 50)
#
	#
	## Set professor position
	#if player:
		#professor.global_position = player.global_position + Vector2(100, 0)
  #
		#print("🧑‍🏫 Spawned professor at player position:", professor.position)
		#print("👤 Player found at position:", player.global_position)
	#else:
		#\
		#professor.position = Vector2(500, 300)  
		#print("⚠️ Player not found, using center position:", professor.position)
	#
	#
	#professor.add_child(bounds)
	#get_tree().current_scene.add_child(professor)
	#professor.quiz_result.connect(_on_quiz_result)
	#
	#await get_tree().process_frame
	#
#
	#professor.z_index = 1000 
	#
	#
	#
	#print("🎯 Professor spawned with backup visual")
	#print("🔍 Professor final position:", professor.global_position)
	#print("🔍 Professor local position:", professor.position)
#
extends Node2D

@onready var professor_scene = preload("res://Scenes/Professor.tscn")
@onready var banner = $LevelBanner
@onready var retries_label = $UI/Retries
@onready var passed_label = $UI/Passed

var subjects = ["Calculus", "OOP", "ComputerScience", "WebDesign", "SP"]
var retries_left = 4
var passed_count = 0
var completed_subjects: Array[String] = []
var game_ended = false

func _ready():
	print("=== LEVEL 1 INITIALIZED ===")
	update_ui()
	banner.show_banner("Level 1\nFind all 5 Professors and complete exams")
	await get_tree().create_timer(2).timeout
	spawn_new_professor()

func update_ui():
	retries_label.text = "Retries left: %d" % retries_left
	passed_label.text = "Exams passed: %d" % passed_count
	print("UI UPDATED | Retries:", retries_left, " Passed:", passed_count)

func _on_quiz_result(subject: String, passed: bool) -> void:
	print("📊 Quiz Result Received | Subject:", subject, " | Passed:", passed)

	if game_ended:
		return

	if passed:
		if !completed_subjects.has(subject):
			completed_subjects.append(subject)
			passed_count += 1
			print("✅ Passed:", subject)
			update_ui()

			if completed_subjects.size() >= 5:
				game_ended = true
				banner.show_banner("🎉 Level Complete!")
				return

			await get_tree().create_timer(0.5).timeout
			spawn_new_professor()
		else:
			print("⚠️ Already passed:", subject)
	else:
		retries_left -= 1
		print("❌ Failed:", subject)
		update_ui()

		if retries_left <= 0:
			game_ended = true
			banner.show_banner("Game Over!")
			await get_tree().create_timer(2).timeout
			banner.show_banner("You have to start all over again! :( ")
			await get_tree().create_timer(3).timeout
			#get_tree().reload_current_scene()
			get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func spawn_new_professor():
	if game_ended:
		return

	var available_subjects = subjects.filter(func(s): return !completed_subjects.has(s))
	if available_subjects.is_empty():
		print("🎓 No more subjects left to assign.")
		return

	var chosen_subject = available_subjects[randi() % available_subjects.size()]
	var professor = professor_scene.instantiate()
	professor.subject = chosen_subject
	professor.is_final_exam = (completed_subjects.size() >= 4)

	var player = get_node_or_null("StudentPlayer")
	if not player:
		player = find_child("StudentPlayer", true, false)
	if not player:
		player = get_tree().current_scene.find_child("StudentPlayer", true, false)
	if not player:
		var all_nodes = get_tree().get_nodes_in_group("player")
		if all_nodes.size() > 0:
			player = all_nodes[0]

	var existing_bounds = professor.get_node_or_null("MovementBounds")
	if existing_bounds:
		existing_bounds.queue_free()

	var bounds = ReferenceRect.new()
	bounds.name = "MovementBounds"
	bounds.size = Vector2(200, 100)
	bounds.border_color = Color.BLUE
	bounds.border_width = 2.0
	bounds.visible = false
	bounds.global_position = professor.global_position - Vector2(100, 50)

	if player:
		professor.global_position = player.global_position + Vector2(100, 0)
	else:
		professor.position = Vector2(500, 300)

	professor.add_child(bounds)
	get_tree().current_scene.add_child(professor)
	professor.quiz_result.connect(_on_quiz_result)

	await get_tree().process_frame
	professor.z_index = 1000
