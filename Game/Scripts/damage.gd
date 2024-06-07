extends Area2D

@onready var timer = $Timer
signal damage

func _on_body_entered(body):

	Engine.time_scale = 0.5
	emit_signal("damage")
	timer.start()
