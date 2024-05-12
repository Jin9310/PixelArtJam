extends Area2D

var center := Vector2(576/2, 324/2+10)  # Center of the screen

func _physics_process(delta):
	var position_of_tube = center
	global_position = position_of_tube
