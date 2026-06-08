extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$transition/ColorRect.color.a = 255
	$transition/AnimationPlayer.play("fade_out")
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$transition/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://badla.tscn")
