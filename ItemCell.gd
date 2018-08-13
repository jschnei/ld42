extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal clicked_on

var red_path = "res://art/redItemCell.png"
var green_path = "res://art/greenItemCell.png"
var blue_path = "res://art/blueItemCell.png"

enum ItemColor {RED, GREEN, BLUE, NONE}

var color = ItemColor.NONE

func set_color(new_color):
	color = new_color
	var texture = ImageTexture.new()
	if color == ItemColor.RED:
		texture.load(red_path)
	elif color == ItemColor.GREEN:
		texture.load(green_path)
	elif color == ItemColor.BLUE:
		texture.load(blue_path)
	$Sprite.texture = texture

func _ready():
	set_process_input(true)

func _process(delta):
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
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				emit_signal('clicked_on')

