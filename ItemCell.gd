extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal picked_up

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	#if Input.is_action_just_pressed("ui_left_click"):
	#	print('hello')
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			print('hello')
			emit_signal('picked_up')
		