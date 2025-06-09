class_name StudentPlayer extends CharacterBody2D

var moveSpeed:float = 100.0

func _process( delta ):
	var direction :Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("Move_right") - Input.get_action_strength("Move_left")
	direction.y = Input.get_action_strength("Move_down") - Input.get_action_strength("Move_up")
	velocity=direction * moveSpeed

func _physics_process(delta):
	move_and_slide() 
	
