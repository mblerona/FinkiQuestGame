extends CanvasLayer

func show_banner(text: String, duration: float = 5.0):
	# Set text
	$ColorRect/Label.text = text
	$ColorRect.visible = true
	$ColorRect/Label.visible = true
	$ColorRect.modulate.a = 1.0
	$ColorRect/Label.modulate.a = 1.0

	await get_tree().create_timer(duration).timeout

	# Fade out smoothly
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property($ColorRect/Label, "modulate:a", 0.0, 0.5)
	await tween.finished

	# Instead of queue_free(), just hide it
	$ColorRect.visible = false
	$ColorRect/Label.visible = false
