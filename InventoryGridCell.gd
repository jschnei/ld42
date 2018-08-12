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
	
"""func mouse_in_cell():
	var pos = get_local_mouse_position() - $Polygon2D.polygon[0]
	var cell_size = get_parent().CELL_SIZE
	return (pos.x >= 0) && (pos.x <= cell_size) && (pos.y >= 0) && (pos.y <= cell_size)
"""

func mouse_in_cell():
	var pos = get_local_mouse_position()
	var cell_size = get_parent().CELL_SIZE/2
	return (pos.x >= -cell_size) && (pos.x <= cell_size) && (pos.y >= -cell_size) && (pos.y <= cell_size)

func _input(event):
	if mouse_in_cell():
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				emit_signal('clicked_on')
			else:
				emit_signal('released')

	