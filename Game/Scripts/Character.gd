extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -400.0
@onready var character = $"."
signal damageEnemy
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
@onready var animated_sprite = $AnimatedSprite2D
var health = 3
var jumping = false
var attack = false
var damaged = false
@onready var timer = $AttackTimer
@onready var health_label = $Label
var coyote_frames = 600  # How many in-air frames to allow jumping
var coyote = false  # Track whether we're in coyote time or not
var last_floor = false  # Last frame's on-floor state
@onready var coyotetimer = $Coyotetimer
@onready var damagetimer = $damagetimer
@onready var deathtimer = $deathtimer
var score = 0
@onready var score_label = $score_label

func _ready():
	coyotetimer.wait_time = coyote_frames / 60.0
	display_health()
	score_label.text = "Coins x " + str(score)

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
		if animated_sprite.flip_h:
			$attackleft/CollisionShape2D.disabled = false
		else:
			$attackright/CollisionShape2D.disabled = false
		attack = true
		timer.start()
		print("attack")
		
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	# Play animations
	if damaged == true:
		if health > 0:
			animated_sprite.play("hurt")
			
		else: 
			Engine.time_scale = 0.5
			animated_sprite.play("death")
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

		
func _on_timer_timeout():
	attack = false
	$attackright/CollisionShape2D.disabled = true
	$attackleft/CollisionShape2D.disabled = true
	
func _on_coyotetimer_timeout():
	coyote = false

func damage():
	health -= 1;
	damaged = true
	if health > 0:
		damagetimer.start()
	else:
		deathtimer.start()
	display_health()

func _on_damagetimer_timeout():
	if health > 0:
		damaged = false

func _on_deathtimer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func display_health():
	health_label.text = "PLAYER x " + str(health)

func _on_attackleft_body_entered(body):
	body.trigger_death()

func _on_attackright_body_entered(body):
	body.trigger_death()

func display_coins():
	score += 1
	score_label.text = "Coins x " + str(score)
