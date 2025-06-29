#extends CanvasLayer
#
#signal quiz_done(subject: String, passed: bool)
#
#@export var subject: String
#var quiz_data = []
#var current_question_index = 0
#var correct_answer = 0
#var score = 0
#
#@onready var question_label = $Panel/VBoxContainer/QuestionLabel
#@onready var progress_label = $Panel/VBoxContainer/ProgressLabel
#@onready var option_buttons = [
	#$Panel/VBoxContainer/OptionA,
	#$Panel/VBoxContainer/OptionB,
	#$Panel/VBoxContainer/OptionC,
	#$Panel/VBoxContainer/OptionD
#]
#
#func _ready():
	#print("🧪 QUIZ STARTED | Subject:", subject)
	#load_quiz(subject)
	#show_question()
#
#func load_quiz(subject):
	#var path = "res://Quiz/%s/quiz.json" % subject
	#if !FileAccess.file_exists(path):
		#push_error("Quiz file not found for subject: %s" % subject)
		#return
#
	#var file = FileAccess.open(path, FileAccess.READ)
	#quiz_data = JSON.parse_string(file.get_as_text())
#
#func show_question():
	#if current_question_index >= quiz_data.size():
		#end_quiz()
		#return
#
	#var q = quiz_data[current_question_index]
	#question_label.text = q["question"]
	#progress_label.text = "Correct: %d / %d" % [score, quiz_data.size()]
#
	#for i in range(4):
		#option_buttons[i].text = q["options"][i]
		#option_buttons[i].disabled = false
		#option_buttons[i].connect("pressed", Callable(self, "_on_option_pressed").bind(i), CONNECT_ONE_SHOT)
#
	#correct_answer = q["answer"]
#
#func _on_option_pressed(index):
	#for button in option_buttons:
		#button.disabled = true
#
	#if index == correct_answer:
		#option_buttons[index].modulate = Color(0, 1, 0)
		#print("✅ Correct!")
		#score += 1
	#else:
		#option_buttons[index].modulate = Color(1, 0, 0)
		#option_buttons[correct_answer].modulate = Color(0, 1, 0)
		#print("❌ Wrong!")
#
	#await get_tree().create_timer(1.5).timeout
#
	#for button in option_buttons:
		#button.modulate = Color(1, 1, 1)
#
	#current_question_index += 1
	#show_question()
#
#func end_quiz():
	#var passed = score >= 2
	#print("🎯 QUIZ FINISHED | Score:", score, "/", quiz_data.size(), " → Passed?", passed)
	#emit_signal("quiz_done", subject, passed)
	#queue_free()


extends CanvasLayer

signal quiz_done(subject: String, passed: bool)

@export var subject: String
@onready var correct_sound: AudioStreamPlayer = $correct_sound
@onready var incorrect_sound: AudioStreamPlayer = $incorrect_sound

var quiz_data = []
var current_question_index = 0
var correct_answer = 0
var score = 0

@onready var question_label = $Panel/VBoxContainer/QuestionLabel
@onready var progress_label = $Panel/VBoxContainer/ProgressLabel
@onready var option_buttons = [
	$Panel/VBoxContainer/OptionA,
	$Panel/VBoxContainer/OptionB,
	$Panel/VBoxContainer/OptionC,
	$Panel/VBoxContainer/OptionD
]


func _ready():
	print("🧪 QUIZ STARTED | Subject:", subject)
	load_quiz(subject)
	show_question()

func load_quiz(subject):
	var path = "res://Quiz/%s/quiz.json" % subject
	if !FileAccess.file_exists(path):
		push_error("Quiz file not found for subject: %s" % subject)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	quiz_data = JSON.parse_string(file.get_as_text())

func show_question():
	if current_question_index >= quiz_data.size():
		end_quiz()
		return

	var q = quiz_data[current_question_index]
	question_label.text = q["question"]
	progress_label.text = "Correct: %d / %d" % [score, quiz_data.size()]

	for i in range(4):
		var btn = option_buttons[i]
		btn.text = q["options"][i]
		btn.disabled = false
		btn.modulate = Color(1, 1, 1)
		btn.release_focus()
		btn.set_pressed_no_signal(false)

		var callback = Callable(self, "_on_option_pressed").bind(i)
		if btn.is_connected("pressed", callback):
			btn.disconnect("pressed", callback)

		btn.connect("pressed", callback, CONNECT_ONE_SHOT)

	correct_answer = q["answer"]

func _on_option_pressed(index):
	for button in option_buttons:
		button.disabled = true

	if index == correct_answer:
		option_buttons[index].modulate = Color(0, 1, 0)
		print("✅ Correct!")
		correct_sound.play()
		score += 1
	else:
		option_buttons[index].modulate = Color(1, 0, 0)
		option_buttons[correct_answer].modulate = Color(0, 1, 0)
		incorrect_sound.play()
		print("❌ Wrong!")

	await get_tree().create_timer(1.5).timeout

	for button in option_buttons:
		button.modulate = Color(1, 1, 1)
		button.set_pressed_no_signal(false)
		button.release_focus()

	current_question_index += 1
	show_question()

#func end_quiz():
	#var passed = score >= 2
	#print("🎯 QUIZ FINISHED | Score:", score, "/", quiz_data.size(), " → Passed?", passed)
	#emit_signal("quiz_done", subject, passed)
	#queue_free()
func end_quiz():
	var total = quiz_data.size()
	var required_to_pass = 2  # Default fallback

	if total == 4:
		required_to_pass = 3  # Level 3
	elif total == 5:
		required_to_pass = 4  # Level 4

	var passed = score >= required_to_pass
	print("🎯 QUIZ FINISHED | Score:", score, "/", total, " → Passed?", passed)
	emit_signal("quiz_done", subject, passed)
	queue_free()
