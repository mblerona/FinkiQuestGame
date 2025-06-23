#extends CharacterBody2D
#
#signal quiz_result(subject: String, passed: bool)
#
#@export var subject: String 
#const speed = 50
#
#var current_state = IDLE
#var dir = Vector2.RIGHT
#var is_chatting = false
#var is_roaming = true
#var player
#var player_in_chat_zone = false
#
#var movement_bound_node
#var movement_bound: Rect2
#
#var post_quiz_dialog = false
#var quiz_passed = false
#
## Store references to avoid null errors
#var animated_sprite: AnimatedSprite2D
#var dialogue_node: Control
#var timer_node: Timer
#
#enum {
	#IDLE,
	#NEW_DIR,
	#MOVE
#}
#
#func _ready():
	## Get node references safely
	#$AnimatedSprite2D.play("idle")
	#print("▶️ Is Playing?", $AnimatedSprite2D.is_playing())
	#print("▶️ Current animation:", $AnimatedSprite2D.animation)
#
#
	#animated_sprite = get_node_or_null("AnimatedSprite2D")
	#dialogue_node = get_node_or_null("Dialogue")
	#timer_node = get_node_or_null("Timer")
	#movement_bound_node = get_node_or_null("MovementBounds")
	#
	## Debug info
	#print("🎯 Professor ready with subject:", subject)
	#print("🎞️ AnimatedSprite2D found:", animated_sprite != null)
	#print("💬 Dialogue found:", dialogue_node != null)
	#print("⏰ Timer found:", timer_node != null)
	#
	## Setup movement bounds
	#if movement_bound_node:
		#movement_bound = Rect2(
			#movement_bound_node.global_position,
			#movement_bound_node.size
		#)
		#movement_bound_node.hide()
		#print("Professor bounds set:", movement_bound)
	#else:
		## Fallback bounds if no MovementBounds node
		#movement_bound = Rect2(position - Vector2(100, 50), Vector2(200, 100))
		#print("Using fallback bounds for professor")
	#
	## Start timer if it exists
	#if timer_node:
		#timer_node.start()
	#
	## Make sure we're visible
	#visible = true
	#modulate = Color.WHITE
#
#
#func _process(delta):
	## Play appropriate animation
	#if animated_sprite and animated_sprite.sprite_frames:
		#if current_state == IDLE or current_state == NEW_DIR:
			#if animated_sprite.sprite_frames.has_animation("idle"):
				#animated_sprite.play("idle")
		#elif current_state == MOVE and !is_chatting:
			#if animated_sprite.sprite_frames.has_animation("walk_e"):
				#animated_sprite.play("walk_e")
			#animated_sprite.flip_h = dir.x < 0
#
	## Handle roaming logic
	#if is_roaming:
		#match current_state:
			#IDLE:
				#pass
			#NEW_DIR:
				#dir = choose([Vector2.RIGHT, Vector2.LEFT])
				#current_state = MOVE
			#MOVE:
				#move(delta)
#
#
#func choose(array):
	#array.shuffle()
	#return array.front()
#
#
#func move(delta):
	#if !is_chatting:
		#var new_position = position + dir * speed * delta
#
		## Only move along X (horizontal), clamp Y to fixed range
		#new_position.x = clamp(new_position.x, movement_bound.position.x, movement_bound.position.x + movement_bound.size.x)
		#new_position.y = position.y  # lock vertical movement
#
		## If blocked (at boundary), change direction
		#if new_position.x == position.x:
			#current_state = NEW_DIR
		#else:
			#position = new_position
#
#func _on_chat_area_body_entered(body: Node2D) -> void:
	#if body.name == "StudentPlayer" and !is_chatting:
		#player = body
		#player_in_chat_zone = true
		#is_chatting = true
		#is_roaming = false
		#
		#if animated_sprite and is_instance_valid(animated_sprite):
			#if "frames" in animated_sprite and animated_sprite.frames != null:
				#if animated_sprite.sprite_frames.has_animation("idle"):
					#animated_sprite.play("idle")
		#
		#post_quiz_dialog = false
		#
		#if dialogue_node:
			#dialogue_node.subject = subject
			#dialogue_node.custom_dialog_path = ""
			#dialogue_node.start()
#
#func _on_chat_area_body_exited(body: Node2D) -> void:
	#if body.name == "StudentPlayer":
		#player_in_chat_zone = false
#
#func _on_timer_timeout() -> void:
	#if timer_node:
		#timer_node.wait_time = choose([0.5, 1, 1.5])
	#current_state = choose([IDLE, NEW_DIR])
#
#func _on_dialogue_dialog_done() -> void:
	#if post_quiz_dialog:
		#if quiz_passed:
			#emit_signal("quiz_result", subject, true)
			#queue_free()
		#else:
			#emit_signal("quiz_result", subject, false)
			#post_quiz_dialog = false
			#is_chatting = false
			#var quiz = preload("res://Scenes/Quiz.tscn").instantiate()
			#quiz.subject = subject
			#quiz.quiz_done.connect(_on_quiz_done)
			#
			#get_tree().current_scene.add_child(quiz)
	#else:
		#is_chatting = false
		#is_roaming = false
		#var quiz = preload("res://Scenes/Quiz.tscn").instantiate()
		#quiz.subject = subject
		#quiz.quiz_done.connect(_on_quiz_done)
		#get_tree().current_scene.add_child(quiz)
#
#func _on_quiz_done(subject: String, passed: bool) -> void:
	#print("📥 Professor received quiz result:", subject, " | Passed:", passed)
	#
	#quiz_passed = passed
	#post_quiz_dialog = true
	#var result_path = "res://Dialogue/Passed.json" if passed else "res://Dialogue/Failed.json"
	#
	#if dialogue_node:
		#dialogue_node.custom_dialog_path = result_path
		#dialogue_node.start()
#
extends CharacterBody2D

signal quiz_result(subject: String, passed: bool)

@export var subject: String 
const speed = 55

var current_state = IDLE
var dir = Vector2.RIGHT
var is_chatting = false
var is_roaming = true
var player
var player_in_chat_zone = false

var movement_bound_node
var movement_bound: Rect2

var post_quiz_dialog = false
var quiz_passed = false

var animated_sprite: AnimatedSprite2D
var dialogue_node: Control
var timer_node: Timer

# Game state
var is_final_exam = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	$AnimatedSprite2D.play("idle")
	animated_sprite = get_node_or_null("AnimatedSprite2D")
	dialogue_node = get_node_or_null("Dialogue")
	timer_node = get_node_or_null("Timer")
	movement_bound_node = get_node_or_null("MovementBounds")

	print("🎯 Professor ready:", subject)
	print("🚨 Final exam:", is_final_exam)

	if movement_bound_node:
		movement_bound = Rect2(movement_bound_node.global_position, movement_bound_node.size)
		movement_bound_node.hide()
	else:
		movement_bound = Rect2(position - Vector2(100, 50), Vector2(200, 100))

	if timer_node:
		timer_node.start()

	visible = true
	modulate = Color.WHITE

func _process(delta):
	if animated_sprite and animated_sprite.sprite_frames:
		if current_state == IDLE or current_state == NEW_DIR:
			if animated_sprite.sprite_frames.has_animation("idle"):
				animated_sprite.play("idle")
		elif current_state == MOVE and !is_chatting:
			if animated_sprite.sprite_frames.has_animation("walk_e"):
				animated_sprite.play("walk_e")
			animated_sprite.flip_h = dir.x < 0

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.LEFT])
				current_state = MOVE
			MOVE:
				move(delta)

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		var new_position = position + dir * speed * delta
		new_position.x = clamp(new_position.x, movement_bound.position.x, movement_bound.position.x + movement_bound.size.x)
		new_position.y = position.y

		if new_position.x == position.x:
			current_state = NEW_DIR
		else:
			position = new_position

func _on_chat_area_body_entered(body: Node2D) -> void:
	if body.name == "StudentPlayer" and !is_chatting:
		player = body
		player_in_chat_zone = true
		is_chatting = true
		is_roaming = false

		post_quiz_dialog = false

		if animated_sprite and animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")

		if dialogue_node:
			dialogue_node.subject = subject
			dialogue_node.custom_dialog_path = ""
			dialogue_node.start()

func _on_chat_area_body_exited(body: Node2D) -> void:
	if body.name == "StudentPlayer":
		player_in_chat_zone = false

func _on_timer_timeout() -> void:
	if timer_node:
		timer_node.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR])

func _on_dialogue_dialog_done() -> void:
	if post_quiz_dialog:
		emit_signal("quiz_result", subject, quiz_passed)
		if quiz_passed:
			queue_free()
		else:
			post_quiz_dialog = false
			is_chatting = false
			is_roaming = true
	else:
		is_chatting = false
		is_roaming = false
		start_quiz()

func start_quiz():
	var quiz = preload("res://Scenes/Quiz.tscn").instantiate()
	quiz.subject = subject
	quiz.quiz_done.connect(_on_quiz_done)
	get_tree().current_scene.add_child(quiz)

func _on_quiz_done(subject: String, passed: bool) -> void:
	print("📥 Quiz completed - Subject:", subject, " | Passed:", passed)

	quiz_passed = passed
	var level = get_tree().current_scene
	var retries_remaining = 0

	if "retries_left" in level:
		retries_remaining = level.retries_left

	var should_skip_dialog = false
	if not passed and retries_remaining <= 1:
		print("💀 LAST RETRY FAIL — Game Over")
		should_skip_dialog = true
	elif passed and is_final_exam:
		print("🎉 FINAL EXAM PASSED — Level Complete")
		should_skip_dialog = true

	if should_skip_dialog:
		emit_signal("quiz_result", subject, passed)
		if passed:
			queue_free()
	else:
		post_quiz_dialog = true
		var result_path = ""
		if passed:
			result_path = "res://Dialogue/Passed.json"
		else:
			result_path = "res://Dialogue/Failed.json"

		if dialogue_node:
			dialogue_node.custom_dialog_path = result_path
			dialogue_node.start()
