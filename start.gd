extends Control

func _ready() -> void:
	$VBoxContainer/Menu/EnterButton.pressed.connect(_enter_pressed)
	$VBoxContainer/EnterButton.pressed.connect(_enter2_pressed)
func _enter_pressed():
	$AnimationPlayer.current_animation = "enter"
	await get_tree().create_timer(1.0).timeout
	
func _enter2_pressed():
	get_tree().change_scene_to_file("res://home.tscn")
