extends Area2D

var center := Vector2(576/2, 324/2+5)  # Center of the screen
@onready var animation_player = $AnimationPlayer

var going_left: bool = false
var goin_right: bool = false
#var going_straight: bool = true

func _physics_process(delta):
	var position_of_tube = center
	global_position = position_of_tube
	
	if Input.is_action_just_pressed("go_faster"):
		animation_player.speed_scale += .1
	
	if Input.is_action_just_pressed("go_slower"):
		animation_player.speed_scale -= .1
	
	if going_left or goin_right:
		%CameraAnim.play("shake")
	else:
		%CameraAnim.play("idle")
		
	

func _on_timer_timeout():
	var random = randi_range(0,2)
	match random:
		0:
			animation_player.play("straight")
			going_left = false
			goin_right = false
		1:
			animation_player.play("left")
			going_left = true
			goin_right = false
		2:
			animation_player.play("right")
			going_left = false
			goin_right = true
