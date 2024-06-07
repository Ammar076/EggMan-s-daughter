extends CharacterBody2D

const SPEED = 100
const DASH_SPEED = 200
@onready var breaktimer = $breaktimer

@onready var label = $Label
@onready var tired = $tired
var bool_tired = false
var weak = false
const JUMP_VELOCITY = -400.0
@onready var ray_cast_right = $followright
@onready var ray_cast_left = $followleft
@onready var stop_left = $RayCastLeft
@onready var stop_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash = $Dash
@onready var dash_2 = $Dash2
var health = 7
var dead = false
@onready var timer = $Timer
var running = false
var rolling  = false
# Called every frame. 'delta' is the elapsed time since the previous frame.()
func _process(delta):
	label.text = str(health) + " Souls"
	if !bool_tired:
		tired.start()
		bool_tired = true
	if weak:
		running =  false
		rolling = false
	else:
		if dash.is_colliding():
			rolling = true
			position.x -= DASH_SPEED * delta
			animated_sprite.flip_h = true
		elif dash_2.is_colliding():
			animated_sprite.play("roll")
			animated_sprite.flip_h = false
			position.x += DASH_SPEED * delta
			rolling = true
		else:
			rolling = false
		if ray_cast_right.is_colliding() and !rolling:
			running = true
			animated_sprite.flip_h = false
			position.x += SPEED * delta
		elif ray_cast_left.is_colliding()and !rolling :
			running  = true
			animated_sprite.play("walk")
			animated_sprite.flip_h = true
			position.x -= SPEED * delta
		else:
			running = false
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
	elif rolling:
		animated_sprite.play("roll")
	elif weak:
		animated_sprite.play("tired")
	else:
		animated_sprite.play("idle")

func _on_timer_timeout():
	$".".queue_free()

func trigger_death():
	health -= 1
	print("death")
	if health <= 0:
		timer.start()
		$CollisionShape2D.queue_free()
		$Damage.queue_free()
		dead = true

func _on_damage_body_entered(body):
	body.damage()


func _on_tired_timeout():
	print("break")
	bool_tired = false
	if !weak:
		print("tired")
		weak = true
		breaktimer.start()

func _on_breaktimer_timeout():
	weak = false
