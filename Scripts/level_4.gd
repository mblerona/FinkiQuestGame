
extends Node2D

@onready var professor_scene = preload("res://Scenes/Professor.tscn")
@onready var banner = $LevelBanner
@onready var retries_label = $UI/Retries
@onready var passed_label = $UI/Passed
@onready var level_timer = $UI/Timer
@onready var timer_label = $UI/TimerLabel
@onready var level_won: AudioStreamPlayer = $level_won
@onready var game_over: AudioStreamPlayer = $game_over

var subjects = ["AdvancedProgramming", "IntegratedSystems", "ICTProject", "DiplomaThesis", "WebProgramming"]
var retries_left = 2
var passed_count = 0
var completed_subjects: Array[String] = []
var game_ended = false

var used_spawn_points: Array[Node2D] = []
var all_spawn_points: Array[Node2D] = []

func _ready():
	print("=== LEVEL 4 INITIALIZED ===")
	update_ui()


	for child in $ProfessorSpawnPoints.get_children():
		if child is Node2D:
			all_spawn_points.append(child)

	banner.show_banner("Level 4\nLast year of studies. Finish 5 exams to Graduate!")
	await get_tree().create_timer(5).timeout
	start_timer(420)
	spawn_new_professor()

func update_ui():
	retries_label.text = "Retries left: %d" % retries_left
	passed_label.text = "Exams passed: %d / 5" % passed_count
	print("UI UPDATED | Retries:", retries_left, " Passed:", passed_count)

func start_timer(seconds: int):
	level_timer.wait_time = seconds
	level_timer.one_shot = true
	level_timer.start()
	set_process(true)
	timer_label.text = format_time(seconds)

func _process(_delta):
	if game_ended:
		return

	var time_left = round(level_timer.time_left)

	if time_left > 0:
		timer_label.text = format_time(time_left)

		if time_left <= 10:
			timer_label.add_theme_color_override("font_color", Color.RED)
			var blink = int(Time.get_ticks_usec() / 250000) % 2 == 0
			timer_label.modulate.a = 1.0 if blink else 0.3
		else:
			timer_label.add_theme_color_override("font_color", Color.WHITE)
			timer_label.modulate.a = 1.0

func format_time(seconds: int) -> String:
	var mins = seconds / 60
	var secs = seconds % 60
	return "Timer: %02d:%02d" % [mins, secs]

func _on_timer_timeout():
	if game_ended:
		return
	game_ended = true
	banner.show_banner("Time's Up!")
	await get_tree().create_timer(2).timeout
	BgMusic.stop()
	game_over.play()
	banner.show_banner("You have to start all over again! :( ")
	await get_tree().create_timer(3).timeout
	BgMusic.play()
	get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")

func _on_quiz_result(subject: String, passed: bool) -> void:
	print("📊 Quiz Result Received | Subject:", subject, " | Passed:", passed)

	if game_ended:
		return

	if passed:
		if !completed_subjects.has(subject):
			completed_subjects.append(subject)
			passed_count += 1
			#Bonus time added here ????
			#add_time_bonus()
			
			print("✅ Passed:", subject)
			update_ui()

			if completed_subjects.size() >= 5:
				game_ended = true
				banner.show_banner(" Level 4 Complete!")
				level_won.play()
				await get_tree().create_timer(3).timeout
				BgMusic.stop()
				get_tree().change_scene_to_file("res://Scenes/GraduateMenu.tscn")
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
			BgMusic.stop()
			game_over.play()
			banner.show_banner("You have to start all over again! :( ")
			await get_tree().create_timer(3).timeout
			BgMusic.play()
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


	var available_spawns = all_spawn_points.filter(func(p): return !used_spawn_points.has(p))
	if available_spawns.is_empty():
		used_spawn_points.clear()
		available_spawns = all_spawn_points.duplicate()

	available_spawns.shuffle()
	var spawn_point = available_spawns[0]
	used_spawn_points.append(spawn_point)

	professor.global_position = spawn_point.global_position

	
	var existing_bounds = professor.get_node_or_null("MovementBounds")
	if existing_bounds:
		existing_bounds.queue_free()

	var bounds = ReferenceRect.new()
	bounds.name = "MovementBounds"
	bounds.size = Vector2(200, 100)
	bounds.border_color = Color.ORANGE
	bounds.border_width = 2.0
	bounds.visible = false
	bounds.global_position = professor.global_position - Vector2(100, 50)
	professor.add_child(bounds)

	get_tree().current_scene.add_child(professor)
	professor.quiz_result.connect(_on_quiz_result)

	await get_tree().process_frame
	professor.z_index = 1000


#func _on_add_time_label_timer_timeout() -> void:
	#$AddTimeLabel.hide()
	#
#func add_time_bonus():
	#level_timer.time_left += 20
#
	#$AddTimeLabel.text = "+20s"
	#$AddTimeLabel.show()
	#$AddTimeLabelTimer.start()





#
#========================================================================
##CODE VERSION TO TEST ALL QUIZZES PROFESSOR ALWAYS RESPAWNS NEAR PLAYER
#
#extends Node2D
#
#@onready var professor_scene = preload("res://Scenes/Professor.tscn")
#@onready var banner = $LevelBanner
#@onready var retries_label = $UI/Retries
#@onready var passed_label = $UI/Passed
#@onready var level_timer = $UI/Timer
#@onready var timer_label = $UI/TimerLabel
#
#var subjects = ["AdvancedProgramming", "IntegratedSystems", "ICTProject", "DiplomaThesis", "WebProgramming"]
#var retries_left = 2
#var passed_count = 0
#var completed_subjects: Array[String] = []
#var game_ended = false
#
#func _ready():
	#print("=== LEVEL 4 INITIALIZED ===")
	#update_ui()
	#banner.show_banner("Level 4\nLast year of studies. Finish 5 exams to Graduate!")
	#await get_tree().create_timer(5).timeout
	#start_timer(240)  # ⏱️ 4 minutes
	#spawn_new_professor()
#
#func update_ui():
	#retries_label.text = "Retries left: %d" % retries_left
	#passed_label.text = "Exams passed: %d" % passed_count
	#print("UI UPDATED | Retries:", retries_left, " Passed:", passed_count)
#
#func start_timer(seconds: int):
	#level_timer.wait_time = seconds
	#level_timer.one_shot = true
	#level_timer.start()
	#set_process(true)
	#timer_label.text = format_time(seconds)
#
#func _process(_delta):
	#if game_ended:
		#return
#
	#var time_left = round(level_timer.time_left)
#
	#if time_left > 0:
		#timer_label.text = format_time(time_left)
#
		#if time_left <= 10:
			#timer_label.add_theme_color_override("font_color", Color.RED)
			#var blink = int(Time.get_ticks_usec() / 250000) % 2 == 0
			#timer_label.modulate.a = 1.0 if blink else 0.3
		#else:
			#timer_label.add_theme_color_override("font_color", Color.WHITE)
			#timer_label.modulate.a = 1.0
#
#func format_time(seconds: int) -> String:
	#var mins = seconds / 60
	#var secs = seconds % 60
	#return "Timer: %02d:%02d" % [mins, secs]
#
#func _on_timer_timeout():
	#if game_ended:
		#return
	#game_ended = true
	#banner.show_banner("⏰ Time's Up!")
	#await get_tree().create_timer(2).timeout
	#banner.show_banner("You have to start all over again! :( ")
	#await get_tree().create_timer(3).timeout
	#get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
#
#func _on_quiz_result(subject: String, passed: bool) -> void:
	#print("📊 Quiz Result Received | Subject:", subject, " | Passed:", passed)
#
	#if game_ended:
		#return
#
	#if passed:
		#if !completed_subjects.has(subject):
			#completed_subjects.append(subject)
			#passed_count += 1
			#print("✅ Passed:", subject)
			#update_ui()
#
			#if completed_subjects.size() >= 5:
				#game_ended = true
				#banner.show_banner("🎉 Level 4 Complete!")
				#await get_tree().create_timer(3).timeout
				#get_tree().change_scene_to_file("res://Scenes/GraduateMenu.tscn")
				#return
#
			#await get_tree().create_timer(0.5).timeout
			#spawn_new_professor()
		#else:
			#print("⚠️ Already passed:", subject)
	#else:
		#retries_left -= 1
		#print("❌ Failed:", subject)
		#update_ui()
#
		#if retries_left <= 0:
			#game_ended = true
			#banner.show_banner("Game Over!")
			#await get_tree().create_timer(2).timeout
			#banner.show_banner("You have to start all over again! :( ")
			#await get_tree().create_timer(3).timeout
			#get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
#
#func spawn_new_professor():
	#if game_ended:
		#return
#
	#var available_subjects = subjects.filter(func(s): return !completed_subjects.has(s))
	#if available_subjects.is_empty():
		#print("🎓 No more subjects left to assign.")
		#return
#
	#var chosen_subject = available_subjects[randi() % available_subjects.size()]
	#var professor = professor_scene.instantiate()
	#professor.subject = chosen_subject
	#professor.is_final_exam = (completed_subjects.size() >= 4)
#
	#var player = get_node_or_null("StudentPlayer")
	#if not player:
		#player = find_child("StudentPlayer", true, false)
	#if not player:
		#player = get_tree().current_scene.find_child("StudentPlayer", true, false)
	#if not player:
		#var all_nodes = get_tree().get_nodes_in_group("player")
		#if all_nodes.size() > 0:
			#player = all_nodes[0]
#
	#var existing_bounds = professor.get_node_or_null("MovementBounds")
	#if existing_bounds:
		#existing_bounds.queue_free()
#
	#var bounds = ReferenceRect.new()
	#bounds.name = "MovementBounds"
	#bounds.size = Vector2(200, 100)
	#bounds.border_color = Color.ORANGE
	#bounds.border_width = 2.0
	#bounds.visible = false
	#bounds.global_position = professor.global_position - Vector2(100, 50)
#
	#if player:
		#professor.global_position = player.global_position + Vector2(100, 0)
	#else:
		#professor.position = Vector2(500, 300)
#
	#professor.add_child(bounds)
	#get_tree().current_scene.add_child(professor)
	#professor.quiz_result.connect(_on_quiz_result)
#
	#await get_tree().process_frame
	#professor.z_index = 1000
