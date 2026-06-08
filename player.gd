extends CharacterBody2D

var ghost_wrapped_time: float = 0.0
const SPEED = 500.0
const JUMP_VELOCITY = -300.0

func _ready() -> void:
	velocity.x = SPEED
	$AnimatedSprite2D.play("walk")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or (velocity.x == 0 and not is_on_floor())):
		velocity.y = JUMP_VELOCITY
	
	velocity.x = SPEED
	
	ghost_wrapped_time += delta
	if ghost_wrapped_time >= 0.1:
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

#func _on_dash_timer_timeout() -> void:
