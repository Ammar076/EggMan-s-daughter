extends Node2D

const SPEED = 100

const JUMP_VELOCITY = -400.0

var direction = 1
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

var dead = false
@onready var timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	#position.x += direction * SPEED * delta
	
	if dead:
		animated_sprite.play("death")
	else:
		animated_sprite.play("idle")

func _on_timer_timeout():
	queue_free()

func trigger_death():
	dead = true
	timer.start()


func _on_damage_body_entered(body):
	body.damage()
