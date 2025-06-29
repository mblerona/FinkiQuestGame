extends Control

@onready var wining_music: AudioStreamPlayer = $wining_music
@onready var click_sound: AudioStreamPlayer = $click_sound


func _ready() -> void:
	wining_music.play()
	pass 


func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
		click_sound.play()
		BgMusic.play()
		get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
