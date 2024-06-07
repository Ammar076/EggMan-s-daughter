extends Area2D
@onready var damage = $damage

func _on_body_entered(body):
	print("damage")
	damage.play()
