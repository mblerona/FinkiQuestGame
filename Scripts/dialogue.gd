#extends Control
#
#@export var subject: String
#var custom_dialog_path := ""
#var dialog = []
#var current_dialog_id = 0
#var d_active = false
#
#signal dialog_done
#
#func _ready():
	#$NinePatchRect.visible = false
#
#func start():
	#if d_active:
		#return
	#d_active = true
	#$NinePatchRect.visible = true
	#dialog = load_dialog()
	#current_dialog_id = -1
	#next_script()
#
#func load_dialog():
	#var path := custom_dialog_path if custom_dialog_path != "" else "res://Quiz/%s/dialogueText.json" % subject
	#if not FileAccess.file_exists(path):
		#push_error("Dialogue file not found: %s" % path)
		#return []
	#var file = FileAccess.open(path, FileAccess.READ)
	#var content = JSON.parse_string(file.get_as_text())
	#return content
#
#func next_script():
	#current_dialog_id += 1
	#if current_dialog_id >= dialog.size():
		#d_active = false
		#$NinePatchRect.visible = false
		#emit_signal("dialog_done")
		#return
#
	#$NinePatchRect/Name.text = dialog[current_dialog_id]["name"]
	#$NinePatchRect/Text.text = dialog[current_dialog_id]["text"]
#
	#await get_tree().create_timer(2.0).timeout
	#next_script()



extends Control

@export var subject: String
var custom_dialog_path := ""
var dialog = []
var current_dialog_id = 0
var d_active = false

signal dialog_done

func _ready():
	$NinePatchRect.visible = false

func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialog = load_dialog()
	current_dialog_id = -1
	next_script()

func load_dialog():
	var path := custom_dialog_path if custom_dialog_path != "" else "res://Quiz/%s/dialogueText.json" % subject
	if not FileAccess.file_exists(path):
		push_error("Dialogue file not found: %s" % path)
		return []
	var file = FileAccess.open(path, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func next_script():
	current_dialog_id += 1
	if current_dialog_id >= dialog.size():
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialog_done")
		return

	$NinePatchRect/Name.text = dialog[current_dialog_id]["name"]
	$NinePatchRect/Text.text = dialog[current_dialog_id]["text"]

	await get_tree().create_timer(2.0).timeout
	next_script()
