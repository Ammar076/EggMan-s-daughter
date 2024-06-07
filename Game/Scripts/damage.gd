extends Area2D

signal damage

func _on_body_entered(body):
	emit_signal("damage")
