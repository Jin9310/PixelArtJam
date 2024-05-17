extends Node2D

@onready var press_start_lbl = %press_start_lbl


# Called when the node enters the scene tree for the first time.
func _ready():
	scale_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func scale_label():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(press_start_lbl, "scale", Vector2(.9,.9), 1.0)
	tween.tween_property(press_start_lbl, "scale", Vector2(1,1), 1.0)
	
