extends Area2D

signal clicked_or_released

var held_item = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func mouse_in_area():
	var pos = get_local_mouse_position()
	var cell_size = 64
	return (pos.x >= -cell_size) && (pos.x <= cell_size) && (pos.y >= -cell_size) && (pos.y <= cell_size)
	
func _input(event):
	if mouse_in_area():
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			emit_signal('clicked_or_released')

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func can_place_item():
	return held_item == null

func place_item(item):
	assert held_item == null
	
	held_item = item
	item.position = position - item.center_point()

func remove_item(item):
	assert held_item == item
	
	held_item = null