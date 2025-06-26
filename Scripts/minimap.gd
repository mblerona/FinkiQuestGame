extends CanvasLayer

@onready var player_icon = $Panel/Player
@onready var professor_icon = $Panel/Professor

var player_ref: Node2D
var professor_ref: Node2D
var level_bounds = Rect2(Vector2.ZERO, Vector2(2000, 2000))  # Customize this

func _process(_delta):
	if player_ref and professor_ref:
		update_icons()

func update_icons():
	var minimap_size = $Panel.size

	var player_pos = (player_ref.global_position - level_bounds.position) / level_bounds.size * minimap_size
	var prof_pos = (professor_ref.global_position - level_bounds.position) / level_bounds.size * minimap_size

	player_icon.position = player_pos
	professor_icon.position = prof_pos
