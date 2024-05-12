extends CharacterBody2D

# Circle parameters
var center := Vector2(576/2, 324/2)  # Center of the circle
var radius = 25  # Radius of the circle

# Character parameters
var angle = PI/2  # Initial angle at the bottom of the circle
var angular_speed = 2  # Angular speed of movement
var min_angle = PI/6  # Minimum angle on the left side (30 degrees)
var max_angle = 5*PI/6  # Maximum angle on the right side (150 degrees)

func _physics_process(delta):
	# Handle player input for movement
	if Input.is_action_pressed("move_left"):
		if angle < max_angle:  # Check if within maximum angle limit
			angle += angular_speed * delta
	elif Input.is_action_pressed("move_right"):
		if angle > min_angle:  # Check if within minimum angle limit
			angle -= angular_speed * delta
	
	# Calculate character's position on the circle
	var position_on_circle = center + Vector2(cos(angle), sin(angle)) * radius
	
	# Update character's position
	global_position = position_on_circle
	
	# Rotate the sprite
	%Sprite2D.rotation = angle - PI/2  # Adjust rotation to match character's orientation
