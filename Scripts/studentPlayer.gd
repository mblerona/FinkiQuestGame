#class_name StudentPlayer
#extends CharacterBody2D
#
#var moveSpeed: float = 120.0
#var cardinal_direction: Vector2 = Vector2.DOWN
#var direction: Vector2 = Vector2.ZERO
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var sprite: Sprite2D = $Sprite2D
#
#func _process(delta):
	#direction.x = Input.get_action_strength("Move_right") - Input.get_action_strength("Move_left")
	#direction.y = Input.get_action_strength("Move_down") - Input.get_action_strength("Move_up")
#
	#if direction.length() > 0:
		#direction = direction.normalized()
	#
	#velocity = direction * moveSpeed
	#update_animation()
#
#func _physics_process(delta):
	#move_and_slide()
#
#func update_animation():
	#if velocity.length() > 0:
		#if abs(velocity.x) > abs(velocity.y):
			#animation_player.play("idle_side")
			#sprite.flip_h = velocity.x > 0
			#cardinal_direction = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
		#else:
			#if velocity.y > 0:
				#animation_player.play("idle_down")
				#cardinal_direction = Vector2.DOWN
			#else:
				#animation_player.play("idle_up")
				#cardinal_direction = Vector2.UP
	#else:
		#animation_player.play("RESET")
#
#
#func _on_bonus_timer_timeout() -> void:
	#pass # Replace with function body.
#================================================================
#ADDED THE COFFEE BONUS TIMER HERE 

#class_name StudentPlayer
#extends CharacterBody2D
#
#var base_speed: float = 120.0
#var moveSpeed: float = base_speed
#var cardinal_direction: Vector2 = Vector2.DOWN
#var direction: Vector2 = Vector2.ZERO
#
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var sprite: Sprite2D = $Sprite2D
#@onready var bonus_timer: Timer = $BonusTimer
#@onready var bonus_label: Label = $BonusLabel
#
#func _process(delta):
	#direction.x = Input.get_action_strength("Move_right") - Input.get_action_strength("Move_left")
	#direction.y = Input.get_action_strength("Move_down") - Input.get_action_strength("Move_up")
#
	#if direction.length() > 0:
		#direction = direction.normalized()
	#
	#velocity = direction * moveSpeed
	#update_animation()
#
#func _physics_process(delta):
	#move_and_slide()
#
#func update_animation():
	#if velocity.length() > 0:
		#if abs(velocity.x) > abs(velocity.y):
			#animation_player.play("idle_side")
			#sprite.flip_h = velocity.x > 0
			#cardinal_direction = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
		#else:
			#if velocity.y > 0:
				#animation_player.play("idle_down")
				#cardinal_direction = Vector2.DOWN
			#else:
				#animation_player.play("idle_up")
				#cardinal_direction = Vector2.UP
	#else:
		#animation_player.play("RESET")
#
#func apply_coffee_bonus():
	#moveSpeed = base_speed * 1.8
	#if bonus_label:
		#bonus_label.text = "Bonus: ☕Coffee makes you faster!"
		#bonus_label.visible = true
	#if bonus_timer:
		#bonus_timer.start()
#
#func _on_bonus_timer_timeout() -> void:
	#moveSpeed = base_speed
	#if bonus_label:
		#bonus_label.visible = false
#
#
#
#
#
#func _on_pickup_area_area_entered(area: Area2D) -> void:
	#print("Entered area: ", area.name)
	#if area.is_in_group("BonusCoffee"):
		#print("☕ BONUS TRIGGERED!")
		#apply_coffee_bonus()
		#area.queue_free()
		#
		#
#================================================================
#ADDED THE COFFEE BONUS TIMER HERE AND LABEL TIMER 

class_name StudentPlayer
extends CharacterBody2D

var base_speed: float = 120.0
var moveSpeed: float = base_speed
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var bonus_timer: Timer = $BonusTimer
@onready var bonus_label: Label = $BonusLabel
@onready var label_timer: Timer = $LabelTimer

func _process(delta):
	direction.x = Input.get_action_strength("Move_right") - Input.get_action_strength("Move_left")
	direction.y = Input.get_action_strength("Move_down") - Input.get_action_strength("Move_up")

	if direction.length() > 0:
		direction = direction.normalized()
	
	velocity = direction * moveSpeed
	update_animation()

func _physics_process(delta):
	move_and_slide()

func update_animation():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			animation_player.play("idle_side")
			sprite.flip_h = velocity.x > 0
			cardinal_direction = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
		else:
			if velocity.y > 0:
				animation_player.play("idle_down")
				cardinal_direction = Vector2.DOWN
			else:
				animation_player.play("idle_up")
				cardinal_direction = Vector2.UP
	else:
		animation_player.play("RESET")

func apply_coffee_bonus():
	moveSpeed = base_speed * 1.8
	if bonus_label:
		bonus_label.text = "Bonus: ☕Coffee makes you faster!"
		bonus_label.visible = true
	if bonus_timer:
		bonus_timer.start()
	if label_timer:
		label_timer.start()

func _on_bonus_timer_timeout() -> void:
	moveSpeed = base_speed
	# Label will hide separately after 2 seconds

func _on_label_timer_timeout() -> void:
	if bonus_label:
		bonus_label.visible = false

func _on_pickup_area_area_entered(area: Area2D) -> void:
	print("Entered area: ", area.name)
	if area.is_in_group("BonusCoffee"):
		print("☕ BONUS TRIGGERED!")
		apply_coffee_bonus()
		area.queue_free()
