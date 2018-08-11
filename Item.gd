extends Node2D

signal clicked_on(cell_index)

export (int) var CELL_SIZE

var cell_point_list = []
var item_cell = preload("res://ItemCell.tscn")

func _ready():
	# init([[1, 1]])
	pass

func point_at(cell_index):
	return cell_point_list[cell_index]
	
func init(point_list):
	for i in range(len(point_list)):
		var new_cell = create_and_add_cell(point_list[i])
		new_cell.connect("clicked_on", self, "_cell_clicked_on", [i])
					
func create_and_add_cell(point):
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
	
func _cell_clicked_on(index):
	emit_signal("clicked_on", index)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
