extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal clicked_on

func _ready():
	set_process_input(true)

func _process(delta):
	pass

func mouse_in_cell():
	var pos = get_local_mouse_position() - $Polygon2D.polygon[0]
	var cell_size = get_parent().CELL_SIZE
	return (pos.x >= 0) && (pos.x <= cell_size) && (pos.y >= 0) && (pos.y <= cell_size)

func _input(event):
	if mouse_in_cell():
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				emit_signal('clicked_on')

