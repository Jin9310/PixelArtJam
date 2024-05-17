extends CanvasLayer

signal reset_game
signal zoom_camera

@onready var speed_txt = %speed_txt
@onready var countdown = %countdown
@onready var tube: Node = get_node("/root/Game/Tube")
@onready var player: Node = get_node("/root/Game/Player")
@onready var main_menu: Node = get_node("/root/Game/Canvas/MainMenu")


var race_has_started: bool = false

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

var time_of_the_lap: float = 0

var in_game: bool = false # means that player is in game screen waiting for start
var game_started: bool = false # means that the SPACE has been pressed and game started

func _ready():
	tube.connect("race_start", race_start)
	tube.connect("stop_time", stop)
	tube.connect("final_score", final_score)
	
	tube.visible = false
	player.visible = false
	
	%timers.visible = false
	%end_game_stats.visible = false

func _process(delta):
	if race_has_started:
		time += delta
		msec = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
		%minutes.text = "%02d:" % minutes
		%seconds.text = "%02d." % seconds
		%milisec.text = "%03d" % msec
	
	if Input.is_action_just_pressed("press_start"):
		scene_switch()

#start / stop the race
func race_start():
	race_has_started = true

func stop():
	race_has_started = false

func _on_play_again_btn_pressed(): #play again pressed
	default_values()
	%timers.visible = true
	%end_game_stats.visible = false
	emit_signal("reset_game")

func default_values(): #reset default values after finished run
	time = 0
	msec = 0
	seconds = 0
	minutes = 0
	race_has_started = false
	%minutes.text = "%02d:" % minutes
	%seconds.text = "%02d." % seconds
	%milisec.text = "%03d" % msec

func final_score(): # show final score
	%timers.visible = false
	%end_game_stats.visible = true
	%final_time.text = "%02d:" % minutes + "%02d." % seconds + "%03d" % msec

func scene_switch(): #switching scene to game
	tube.visible = true
	player.visible = true
	main_menu.visible = false
	in_game = true
	emit_signal("zoom_camera")
	%timers.visible = true
	

