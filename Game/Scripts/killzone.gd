extends Area2D

@onready var timer = $Timer
signal Dead

func _on_body_entered(body):
	Engine.time_scale = 0.5
	timer.start()
	body.damage()
	body.damage()
	body.damage()
func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
