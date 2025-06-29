
extends SubViewport

@onready var camera: Camera2D = $Camera2D
var player: CharacterBody2D

func _ready() -> void:
	world_2d = get_tree().root.world_2d

func _physics_process(delta: float) -> void:
	if player:
		camera.position = player.position

func set_player(p):
	player = p
