extends KinematicBody2D

export (float) var SPEED = 100

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var input_dir  = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		input_dir += Vector2(1, 0)
	elif Input.is_action_pressed("ui_left"):
		input_dir += Vector2(-1, 0)
		
	
	if Input.is_action_pressed("ui_up"):
		input_dir += Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		input_dir += Vector2(0, 1)
	
	move_and_slide(SPEED*input_dir)
	