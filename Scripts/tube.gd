extends Area2D

# play start animation - drop into the tube - it will be a press of SPACE key
# have a countdown 3 2 1 GO! with the background of straight animation which needs to be separated from the current straight animation
# on GO! timer starts and I start to randomly change the animations
# I will change these in change_piece() func
# after animation is done, this func is called again
# I will count all animations and will set the finite number for race
# once I reach that number, straight animation is set with last 5 loops followed by an end animation - fall into the pool
# final stats continues and hopefully some online leaderboard

@onready var texture_rect = %TextureRect
var end_y_position_of_texture: float = -362
var end_x_position_of_texture: float = -213
var start_y_position_of_texture: float = -109



signal show_feet
signal race_start
signal stop_time
signal final_score

var center := Vector2(576/2, 324/2+5)  # Center of the screen
@onready var animation_player = $AnimationPlayer

@onready var game: Node = get_node("/root/Game")
@onready var hud: Node = get_node("/root/Hud")

var going_straight: bool = true
var going_left: bool = false
var going_right: bool = false

var animation_count: int
var number_of_straights: int
var number_of_rights: int
var number_of_lefts: int

var track_lenght: int = 30
var bg_vert_move: float

var countdown: int = 4

#speed handling
var speed: float
var speed_base: float = 15

var run_ended: bool = false

func vertical_movement_of_bg():
	bg_vert_move = end_y_position_of_texture / track_lenght
	print(bg_vert_move)

func _ready():
	texture_rect.position.y = start_y_position_of_texture
	texture_rect.position.x = end_x_position_of_texture
	vertical_movement_of_bg()
	%Camera2D.zoom = Vector2(1,1)
	Hud.speed_txt.text = "0 km/h"
	hud.connect("reset_game", reset_game)
	hud.connect("zoom_camera", zoom_camera)
	speed = speed_base
	#right_zone_speed_1()

func _physics_process(delta):
	var position_of_tube = center
	global_position = position_of_tube
	
	if going_left or going_right:
		%CameraAnim.play("shake")
	else:
		%CameraAnim.play("idle")

	if animation_count == track_lenght: #condition for end of the game
		end_of_run()
	
	if Input.is_action_just_pressed("press_start") && Hud.in_game == true && Hud.game_started != true: #pressing the SPACE starts the countdown
		countdown = 4
		Hud.game_started = true
		%Timer.start()


func raise_the_speed():
	animation_player.speed_scale += .025
	speed += .3
	Hud.speed_txt.text = str(speed) + " km/h"

func lower_the_speed():
	animation_player.speed_scale -= .01
	speed -= .1
	Hud.speed_txt.text = str(speed) + " km/h"

func end_of_run():
	emit_signal("stop_time")
	run_ended = true

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

func finish_sequence():
	emit_signal("show_feet")
	going_left = false
	going_right = false
	animation_player.speed_scale = 1
	animation_player.play("end_line")
	animation_player.play("end_animation")

func go_animation(): #entry animation followed by script change_piece()
	animation_player.play("go")

func starting_straight_anim():
	emit_signal("show_feet") #feets needs to be hiden up until this point
	animation_player.play("start_anim")

func change_piece(): #randomly change the animation
	if run_ended != true:
		var random = randi_range(0,2)
		animation_count += 1
		if texture_rect.position.y >= (end_y_position_of_texture + 4):
			texture_rect.position.y += bg_vert_move #move the background downwards as you progress 
		else:
			texture_rect.position.y = end_y_position_of_texture
		match random:
			0:
				straight_zone_speed() #enable Area2Ds that handle speed detection
				go_straight_anim()
				number_of_straights += 1
				going_left = false
				going_right = false
			
			1:
				left_zone_speed_1()
				go_left_anim()
				number_of_lefts += 1
				going_left = true
				going_right = false
			
			2:
				right_zone_speed_1()
				go_right_anim()
				number_of_rights += 1
				going_left = false
				going_right = true
	else:
		finish_sequence()

func _on_timer_timeout():
	if countdown > 1:
		Hud.countdown.visible = true
		scale_text()
		Hud.countdown.text = str(countdown - 1)
	elif countdown == 1:
		scale_text()
		Hud.countdown.text = "GO!"
		go_animation()
		emit_signal("race_start")
	else:
		Hud.countdown.visible = false
	countdown -= 1

func scale_text():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(Hud.countdown, "scale", Vector2(1.5,1.5), 1)
	tween.tween_property(Hud.countdown, "scale", Vector2(1,1), .001)

func show_score():
	emit_signal("final_score")

func zoom_camera():
	%Camera2D.zoom = Vector2(2,2)

func reset_game(): #all the default states
	%Timer.stop()
	countdown = 4
	animation_player.play("waiting")
	run_ended = false
	animation_count = 0
	number_of_rights = 0
	number_of_lefts = 0
	number_of_straights = 0
	speed = speed_base
	Hud.speed_txt.text = "00 km/h"
	Hud.game_started = false
	texture_rect.position.y = start_y_position_of_texture
	

func straight_zone_speed(): #turn on speed and slow zones for straight tube
	%speed_up_straight.monitoring = true
	%slow_down_straight_1.monitoring = true
	%slow_down_straight_2.monitoring = true
	
	%speed_up_left_1.monitoring = false
	%slow_down_left_1.monitoring = false
	%slow_down_left_2.monitoring = false
	
	%speed_up_right_1.monitoring = false
	%slow_down_right_1.monitoring = false
	%slow_down_right_2.monitoring = false

func left_zone_speed_1():
	%speed_up_straight.monitoring = false
	%slow_down_straight_1.monitoring = false
	%slow_down_straight_2.monitoring = false
	
	%speed_up_left_1.monitoring = true
	%slow_down_left_1.monitoring = true
	%slow_down_left_2.monitoring = true
	
	%speed_up_right_1.monitoring = false
	%slow_down_right_1.monitoring = false
	%slow_down_right_2.monitoring = false

func right_zone_speed_1():
	%speed_up_straight.monitoring = false
	%slow_down_straight_1.monitoring = false
	%slow_down_straight_2.monitoring = false
	
	%speed_up_left_1.monitoring = false
	%slow_down_left_1.monitoring = false
	%slow_down_left_2.monitoring = false
	
	%speed_up_right_1.monitoring = true
	%slow_down_right_1.monitoring = true
	%slow_down_right_2.monitoring = true

### ZONES which when hit, slows down or speed up the movement ###
## straight zone
func _on_speed_up_straight_body_entered(body):
	raise_the_speed()

func _on_slow_down_straight_1_body_entered(body):
	lower_the_speed()

func _on_slow_down_straight_2_body_entered(body):
	lower_the_speed()

## left side
func _on_speed_up_left_1_body_entered(body):
	raise_the_speed()

func _on_slow_down_left_1_body_entered(body):
	lower_the_speed()

func _on_slow_down_left_2_body_entered(body):
	lower_the_speed()


##right side
func _on_speed_up_right_1_body_entered(body):
	raise_the_speed()

func _on_slow_down_right_1_body_entered(body):
	lower_the_speed()

func _on_slow_down_right_2_body_entered(body):
	lower_the_speed()
