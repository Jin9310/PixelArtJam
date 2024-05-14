extends Area2D

# play start animation - drop into the tube - it will be a press of SPACE key
# have a countdown 3 2 1 GO! with the background of straight animation which needs to be separated from the current straight animation
# on GO! timer starts and I start to randomly change the animations
# I will change these in change_piece() func
# after animation is done, this func is called again
# I will count all animations and will set the finite number for race
# once I reach that number, straight animation is set with last 5 loops followed by an end animation - fall into the pool
# final stats continues and hopefully some online leaderboard

signal show_feet
signal race_start
signal stop_time

var center := Vector2(576/2, 324/2+5)  # Center of the screen
@onready var animation_player = $AnimationPlayer

@onready var game: Node = get_node("/root/Game")

var going_straight: bool = true
var going_left: bool = false
var going_right: bool = false

var animation_count: int
var number_of_straights: int
var number_of_rights: int
var number_of_lefts: int

var countdown: int = 4

#speed handling
var speed: float
var speed_base: float = 15

func _ready():
	speed = speed_base

func _physics_process(delta):
	var position_of_tube = center
	global_position = position_of_tube
	
	if going_left or going_right:
		%CameraAnim.play("shake")
	else:
		%CameraAnim.play("idle")

	if animation_count == 50:
		end_of_run()
	
	if Input.is_action_just_pressed("press_start"): #pressing the SPACE starts the countdown
		%Timer.start()
	
	
	#delete this later, just a preparation for slow down and speed up functionality
	if Input.is_action_just_pressed("change_anim_1"):
		%speed_up_straight.monitoring = !%speed_up_straight.monitoring
	
	if Input.is_action_just_pressed("change_anim_2"):
		%slow_down_position_1.monitoring = !%slow_down_position_1.monitoring
	
	if Input.is_action_just_pressed("go_faster"):
		animation_player.speed_scale += .02
		raise_the_speed()
	
	if Input.is_action_just_pressed("go_slower"):
		animation_player.speed_scale -= .02
		lower_the_speed()
	

func raise_the_speed():
	animation_player.speed_scale += .02
	speed += .2
	Hud.speed_txt.text = str(speed) + " km/h"

func lower_the_speed():
	animation_player.speed_scale -= .02
	speed -= .4
	Hud.speed_txt.text = str(speed) + " km/h"

func end_of_run():
	emit_signal("stop_time")
	print("The End")

func go_right_anim():
	if going_right != true:
		animation_player.play("build_right")
		animation_player.queue("right")
	elif going_right == true:
		animation_player.play("right")
	elif going_left == true:
		animation_player.play("debuild_left")
		animation_player.queue("build_right")
		animation_player.queue("right")

func go_straight_anim():
	if going_right == true:
		animation_player.play("debuild_right")
		animation_player.queue("straight")
	elif going_left == true:
		animation_player.play("debuild_left")
		animation_player.queue("straight")
	else:
		animation_player.play("straight")

func go_left_anim():
	if going_left != true:
		animation_player.play("build_left")
		animation_player.queue("left")
	elif going_left == true:
		animation_player.play("left")
	elif going_right == true:
		animation_player.play("debuild_right")
		animation_player.queue("build_left")
		animation_player.queue("left")

func go_animation():
	animation_player.play("go")

func starting_straight_anim():
	emit_signal("show_feet") #feets needs to be hiden up until this point
	animation_player.play("start_anim")

func change_piece(): #randomly change the animation
	var random = randi_range(0,2)
	animation_count += 1
	match random:
		0:
			go_straight_anim()
			number_of_straights += 1
			going_left = false
			going_right = false
		1:
			go_left_anim()
			number_of_lefts += 1
			going_left = true
			going_right = false
		2:
			go_right_anim()
			number_of_rights += 1
			going_left = false
			going_right = true

func _on_timer_timeout():
	if countdown > 1:
		Hud.countdown.visible = true
		Hud.countdown.text = str(countdown - 1)
	elif countdown == 1:
		Hud.countdown.text = "GO!"
		go_animation()
		emit_signal("race_start")
	else:
		Hud.countdown.visible = false
	countdown -= 1


func _on_speed_up_straight_body_entered(body):
	print("speed up")
	raise_the_speed()
	print(animation_player.speed_scale)


func _on_slow_down_position_1_body_entered(body):
	print("slow down")
	lower_the_speed()
	print(animation_player.speed_scale)
