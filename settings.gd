extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$LineEdit.text = 250
	$LineEdit2.text = 450


func _on_button_2_pressed() -> void:
	get_parent().get_node("Player").velocity.x = 45
	pass
