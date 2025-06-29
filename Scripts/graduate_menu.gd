extends Control

@onready var wining_music: AudioStreamPlayer = $wining_music
@onready var click_sound: AudioStreamPlayer = $click_sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wining_music.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
		click_sound.play()
		BgMusic.play()
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
