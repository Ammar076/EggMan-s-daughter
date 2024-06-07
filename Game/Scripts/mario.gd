extends CharacterBody2D

const SPEED = 50

const JUMP_VELOCITY = -400.0
@onready var hurt = $hurt
@onready var die = $die
@onready var hit = $hit

var direction = 1
@onready var ray_cast_right = $followright
@onready var ray_cast_left = $followleft
@onready var stop_left = $RayCastLeft
@onready var stop_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var it_me = $it_ME

var health = 3
var dead = false
@onready var timer = $Timer
var running = false
var first = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		if first == 1:
			it_me.play()
			first -= 1
		running = true
		animated_sprite.flip_h = false
		position.x += SPEED * delta
	if ray_cast_left.is_colliding():
		if first == 1:
			it_me.play()
			first -= 1
		first = true
		running  = true
		animated_sprite.play("walk")
		animated_sprite.flip_h = true
		position.x -= SPEED * delta
	if stop_left.is_colliding():
		running  = false
		animated_sprite.play("idle")
		position.x += SPEED * delta
	if stop_right.is_colliding():
		running = false
		animated_sprite.play("idle")
		position.x -= SPEED * delta
		
	if dead:
		animated_sprite.play("death")
	elif running:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func _on_timer_timeout():
	$".".queue_free()

func trigger_death():
	health -= 1
	hurt.play()
	print("death")
	if health <= 0:
		die.play()
		timer.start()
		$CollisionShape2D.queue_free()
		$Damage.queue_free()
		dead = true

func _on_damage_body_entered(body):
	hurt.play()
	body.damage()

