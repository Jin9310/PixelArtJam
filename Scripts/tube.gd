extends Area2D

var center := Vector2(576/2, 324/2+10)  # Center of the screen
@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	var position_of_tube = center
	global_position = position_of_tube
	
	if Input.is_action_just_pressed("go_faster"):
		animation_player.speed_scale += .1
	
	if Input.is_action_just_pressed("go_slower"):
		animation_player.speed_scale -= .1
