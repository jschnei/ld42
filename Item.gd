extends Node2D

signal clicked_on(cell_index)

export (int) var CELL_SIZE

var cell_point_list = []
var cell_list = []
var item_cell = preload("res://ItemCell.tscn")

func _ready():
	pass

func point_at(cell_index):
	return cell_point_list[cell_index]
	
func init(point_list):
	for i in range(len(point_list)):
		var new_cell = create_and_add_cell(point_list[i])
		new_cell.connect("clicked_on", self, "_cell_clicked_on", [i])
		cell_list.append(new_cell)
					
"""func create_and_add_cell(point):
	cell_point_list.append(point)
	
	var polygon = [CELL_SIZE * point,
				   CELL_SIZE * (point + Vector2(0, 1)),
				   CELL_SIZE * (point + Vector2(1, 1)),
				   CELL_SIZE * (point + Vector2(1, 0))]
	var new_cell = item_cell.instance()
	new_cell.get_node("Polygon2D").polygon = polygon
	new_cell.get_node("CollisionPolygon2D").polygon = polygon
	
	add_child(new_cell)
	return new_cell
"""

func create_and_add_cell(point):
	cell_point_list.append(point)
	
	var new_cell = item_cell.instance()
	var sprite_size = new_cell.get_node("Sprite").get_texture().get_size()
	var sprite_scale_x = CELL_SIZE / sprite_size.x
	var sprite_scale_y = CELL_SIZE / sprite_size.y
	new_cell.position = CELL_SIZE * point
	new_cell.scale = Vector2(sprite_scale_x, sprite_scale_y)
	
	add_child(new_cell)
	return new_cell
	
# Returns a vector with the (x,y) pixel coordinates of the "center"
# of the item. Used for centering the item in the holding area.
func center_point():
	var min_x = cell_point_list[0].x
	var max_x = cell_point_list[0].x
	var min_y = cell_point_list[0].y
	var max_y = cell_point_list[0].y
	for point in cell_point_list:
		if point.x < min_x:
			min_x = point.x
		if point.x > max_x:
			max_x = point.x
		if point.y < min_y:
			min_y = point.y
		if point.y > max_y:
			max_y = point.y
	var center_point = Vector2((max_x+min_x)/2, (max_y+min_y)/2)
	return center_point * CELL_SIZE
	
func stats():
	return get_node("ItemStats")
	
func set_cell_text(cell_index, text):
	cell_list[cell_index].get_node("Label").text = text
	
func _cell_clicked_on(index):
	emit_signal("clicked_on", index)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
