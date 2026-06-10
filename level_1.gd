extends Node

#@onready var scene_transition

var timer1_started = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$settings.hide()
	$ColorRect.hide()
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.seek(15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer1_started:
		if Input.is_action_just_pressed("jump"):
			$Timer.stop()
			get_tree().paused = false
			$ColorRect.visible = false
			timer1_started = false
			$Player.velocity.y = -400
	if Input.is_action_just_pressed("quit"):
		get_tree().paused = true
		$settings.show()
	if $MovingPlatform.animation_finished_bool:
		$Player.on_moving_platform = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	$ColorRect.show()
	$ColorRect/Label.show()
	$Timer.start()
	$ColorRect.visible = true
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($ColorRect, "material:shader_parameter/progress", 0, $Timer.time_left)
	timer1_started = true
	get_tree().paused = true;

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().paused = true
	$Area2D2/AudioStreamPlayer2D.play()


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	$Parallax2D/Rocks2.hide()
	$Parallax2D/Sky.hide()


func _on_audio_stream_player_2d_finished() -> void:
	get_tree().paused = false


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	$transition/AnimationPlayer.play("fade_in")
	$Timer2.start()
	get_tree().paused = true


func _on_timer_2_timeout() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://reached.tscn")


func _on_start_platform_body_entered(body: Node2D) -> void:
	$Player.on_moving_platform = true
	$Player.velocity.x = 0
	$MovingPlatform/AnimatableBody2D/AnimationPlayer.play("move")


func _on_test_area_body_entered(body: Node2D) -> void:
	print($AudioStreamPlayer.get_playback_position())
	get_tree().paused = true


func _on_void_space_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://died.tscn")


func _on_settings_reset_pressed() -> void:
	$settings/LineEdit.text = 250
	$settings/LineEdit2.text = 450
	$settings/j_velocity.text = -350
	$settings/dash_duration_edit.text = 1
	$settings/dash_cooldown_edit.text = 3

func _on_apply_pressed() -> void:
	$Player.SPEED = float($settings/LineEdit.text)
	$Player.velocity.x = $Player.SPEED
	$Player.dash_timer.wait_time = float($settings/dash_duration_edit.text)
	$Player/DashTimer/cooldown_timer.wait_time = float($settings/dash_cooldown_edit.text)
	$Player.JUMP_VELOCITY = float($settings/j_velocity.text)
	$Player.DASH_SPEED = float($settings/LineEdit2.text)
	get_tree().paused = false
	$settings.hide()
