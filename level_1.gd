extends Node

#@onready var scene_transition

var timer1_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer1_started:
		if Input.is_action_just_pressed("ui_accept"):
			$Timer.stop()
			get_tree().paused = false
			$ColorRect.visible = false
			timer1_started = false
			$Player.velocity.y = -400
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://main.tscn")
		

func _on_area_2d_body_entered(body: Node2D) -> void:
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
