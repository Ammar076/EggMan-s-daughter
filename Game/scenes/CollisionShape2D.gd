extends Area2D
signal boss

func _on_body_entered(body):
	emit_signal("Boss")
