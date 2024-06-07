extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -400.0
@onready var character = $"."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
@onready var animated_sprite = $AnimatedSprite2D
var health = 3
var jumping = false
var attack = false
@onready var timer = $Timer

var coyote_frames = 600  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state
@onready var coyotetimer = $Coyotetimer

func _ready():
	coyotetimer.wait_time = coyote_frames / 60.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	last_floor = is_on_floor()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote):
		velocity.y = JUMP_VELOCITY
		jumping = true
		
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		coyotetimer.start()
	
	if Input.is_action_just_pressed("attack"):
		$Area2D/CollisionShape2D.disabled = false
		attack = true
		timer.start()
	else:
		$Area2D/CollisionShape2D.disabled = true
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_dead == true:
		if health == 0:
			animated_sprite.play("death")
		else: 
			animated_sprite.play("hurt")
	else:
		if is_on_floor() and !attack:
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		elif attack:
			animated_sprite.play("attack")
				
		else:
			animated_sprite.play("jump")
			
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	last_floor = is_on_floor()


func _on_killzone_player_damaged():
	is_dead= true
	health = 0

func change_player_position(new_position):
	set_global_position(new_position)
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("hit"):
		body.take_damage()


func _on_timer_timeout():
	attack = false


func _on_coyotetimer_timeout():
	coyote = false
