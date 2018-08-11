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
	var x = point[0]
	var y = point[1]
	cell_point_list.append(Vector2(x, y))
	
	var polygon = [Vector2(CELL_SIZE*x, CELL_SIZE*y),
				   Vector2(CELL_SIZE*x, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y)]
	var new_cell = item_cell.instance()
	new_cell.get_node("Polygon2D").polygon = polygon
	new_cell.get_node("CollisionPolygon2D").polygon = polygon

	add_child(new_cell)
	return new_cell
	
func _cell_clicked_on(index):
	emit_signal("clicked_on", index)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
