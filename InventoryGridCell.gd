extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal clicked_on
signal released

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	#if Input.is_action_just_pressed("ui_left_click"):
	#	print('hello')
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal('clicked_on')
		else:
			emit_signal('released')