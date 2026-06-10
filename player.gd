extends CharacterBody2D

var ghost_wrapped_time: float = 0.0
@export var SPEED = 250.0
@export var JUMP_VELOCITY = -350.0

@export var DASH_SPEED = 450.0
var is_dashing: bool = false
var dash_direction = 1
var cooled_down = true
@export var on_moving_platform = false

@onready var dash_timer = $DashTimer

func _ready() -> void:
	velocity.x = SPEED
	$AnimatedSprite2D.play("walk")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("dash") and not is_dashing and cooled_down:
		start_dash(1)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
			
	if not on_moving_platform:
		velocity.x = SPEED
	
	if on_moving_platform:
		velocity.x = 0
	
	if is_dashing:
		velocity.x = DASH_SPEED
	
	ghost_wrapped_time += delta
	if ghost_wrapped_time >= 0.1 and is_dashing:
		spawn_ghost()
		ghost_wrapped_time = 0.0
	move_and_slide()


func spawn_ghost():
	var ghost = AnimatedSprite2D.new()
	
	# Copy the sprite frames and configuration
	ghost.sprite_frames = $AnimatedSprite2D.sprite_frames
	ghost.animation = $AnimatedSprite2D.animation
	ghost.frame = $AnimatedSprite2D.frame
	ghost.flip_h = $AnimatedSprite2D.flip_h
	
	# Match the player's exact transform/position
	ghost.global_position = global_position
	ghost.rotation = rotation
	ghost.scale = scale
	
	# Give it a ghostly blue tint
	ghost.modulate = Color(0.3, 0.6, 1.0, 0.6) 
	ghost.show_behind_parent = true
	#ghost.z_index = $AnimatedSprite2D.z_index-1 # z_index - 1
	# Attach the fading logic script
	ghost.set_script(preload("res://dash_ghost.gd"))
	
	# Add it to the world (parent), so it stays put while the player moves away
	get_parent().add_child(ghost)

func start_dash(dir: float):
	is_dashing = true
	
	# Determine dash direction. Default to the way the player is facing 
	# if they aren't holding left or right.
	if dir != 0:
		dash_direction = Vector2(dir, 0).normalized()
	else:
		# Fallback: Check which way your sprite is facing if standing still
		dash_direction = Vector2(-1 if $Sprite2D.flip_h else 1, 0)
	
	dash_timer.start()
	
func _on_dash_timer_timeout() -> void:
	is_dashing = false
	cooled_down = false
	$DashTimer/cooldown_timer.start()
	if not on_moving_platform:
		velocity.x = SPEED


func _on_cooldown_timer_timeout() -> void:
	cooled_down = true
