extends CanvasLayer

signal reset_game

@onready var speed_txt = %speed_txt
@onready var countdown = %countdown
@onready var tube: Node = get_node("/root/Game/Tube")

var race_has_started: bool = false

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

var time_of_the_lap: float = 0

func _ready():
	tube.connect("race_start", race_start)
	tube.connect("stop_time", stop)
	tube.connect("final_score", final_score)

func _process(delta):
	if race_has_started:
		time += delta
		msec = fmod(time, 1) * 100
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
		%minutes.text = "%02d:" % minutes
		%seconds.text = "%02d." % seconds
		%milisec.text = "%03d" % msec

func race_start():
	race_has_started = true

func stop():
	race_has_started = false

func _on_play_again_btn_pressed():
	default_values()
	%timers.visible = true
	%end_game_stats.visible = false
	emit_signal("reset_game")

func default_values():
	time = 0
	msec = 0
	seconds = 0
	minutes = 0
	race_has_started = false
	%minutes.text = "%02d:" % minutes
	%seconds.text = "%02d." % seconds
	%milisec.text = "%03d" % msec

func final_score():
	%timers.visible = false
	%end_game_stats.visible = true
	%final_time.text = "%02d:" % minutes + "%02d." % seconds + "%03d" % msec
