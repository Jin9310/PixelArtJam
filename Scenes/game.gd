extends Node2D

@onready var press_start_lbl = %press_start_lbl
@onready var name_tube = %name_tube
@onready var name_runners = %name_runners
@onready var moving_main_01 = %moving_main_01
@onready var moving_main_02 = %moving_main_02
@onready var music_main_menu = $MusicMainMenu
@onready var end_stats = $EndStats
@onready var play_game_snd = $play_game_snd

@onready var tube: Node = get_node("/root/Game/Tube")

var runners_position_x: int = 291
var runners_position_x_get_out: int = -500

var out_of_main_menu: bool = false
var final_stats_song: bool = false
var play_game_on: bool = false


func _ready():
	tube.connect("end_tunes_on", end_tunes_on)
	tube.connect("stop_stats_song", stop_stats_song)
	tube.connect("play_game_sound", play_game_sound)
	tube.connect("stop_play_game_sound", stop_play_game_sound)
	scale_label()
	moving_bg_01()

func _process(delta):
	if Input.is_action_just_pressed("press_start"):
		press_start_lbl.visible = false
		out_of_main_menu = true
		name_get_out()
	
	if Input.is_action_just_pressed("change_anim_1"):
		name_get_out()
	
	if Input.is_action_just_pressed("change_anim_2"):
		name_arrival()

func moving_bg_01():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(moving_main_01, "scale", Vector2(.7,.7), .1)
	tween.tween_property(moving_main_01, "modulate:a", 1.0, .1)
	tween.chain().tween_property(moving_main_01, "scale", Vector2(2,2), 8.0)
	tween.parallel().tween_property(moving_main_01, "modulate:a", 0.0, 7.8)


func moving_bg_02():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(moving_main_02, "scale", Vector2(.7,.7), .1)
	tween.tween_property(moving_main_02, "modulate:a", 1.0, .1)
	tween.chain().tween_property(moving_main_02, "scale", Vector2(2,2), 8.0)
	tween.parallel().tween_property(moving_main_02, "modulate:a", 0.0, 7.8)


func scale_label():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(press_start_lbl, "scale", Vector2(.9,.9), 1.0)
	tween.tween_property(press_start_lbl, "scale", Vector2(1,1), 1.0)

func name_arrival():
	var tween = get_tree().create_tween()
	tween.tween_property(name_tube, "position:x", runners_position_x, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(name_runners, "position:x", runners_position_x, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func name_get_out():
	var tween = get_tree().create_tween()
	tween.tween_property(name_tube, "position:x", runners_position_x_get_out, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(name_runners, "position:x", runners_position_x_get_out, .5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	music_main_menu.stop()


func _on_timer_timeout():
	name_arrival()
	%Timer.stop()


func _on_timer_2_timeout():
	moving_bg_02()
	%Timer2.stop()


func _on_music_main_menu_finished():
	if out_of_main_menu != true:
		music_main_menu.play()

func end_tunes_on():
	final_stats_song = true
	end_stats.play()

func _on_end_stats_finished():
	if final_stats_song == true:
		end_stats.play()

func stop_stats_song():
	final_stats_song = false
	end_stats.stop()

func play_game_sound():
	play_game_on = true
	play_game_snd.play()


func _on_play_game_snd_finished():
	if play_game_on:
		play_game_snd.play()

func stop_play_game_sound():
	play_game_on = false
	play_game_snd.stop()
