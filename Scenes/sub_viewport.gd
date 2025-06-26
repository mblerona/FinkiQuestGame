#extends SubViewport
#
#@onready var camera: Camera2D=$Camera2D
#@onready var player: CharacterBody2D= CharacterBody2D
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#world_2d =get_tree().root.world_2d
	#
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#$Camera2D.position =player.position
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
