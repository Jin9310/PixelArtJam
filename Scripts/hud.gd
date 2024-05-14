extends CanvasLayer


@onready var speed_txt = %speed_txt
@onready var countdown = %countdown
@onready var tube: Node = get_node("/root/Game/Tube")

var race_has_started: bool = false

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _ready():
	tube.connect("race_start", race_start)
	tube.connect("stop_time", stop)

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
	set_process(false)
