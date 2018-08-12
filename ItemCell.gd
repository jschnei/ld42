extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal clicked_on

func _ready():
	set_process_input(true)

func _process(delta):
	#if Input.is_action_just_pressed("ui_left_click"):
	#	print('hello')
	pass
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			emit_signal('clicked_on')
		