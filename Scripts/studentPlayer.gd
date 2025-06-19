class_name StudentPlayer
extends CharacterBody2D

var moveSpeed: float = 100.0
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

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
