extends Area2D

@onready var respawn_timer = $RespawnTimer

func _ready():
	respawn_timer.connect("timeout", Callable(self, "_on_respawn_timeout"))

func pickup():
	hide()
	set_deferred("monitoring", false)
	respawn_timer.start()

func _on_respawn_timeout():
	show()
	monitoring = true
