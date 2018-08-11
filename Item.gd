extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var CELL_SIZE

var grid_points = []
var item_cell = preload("res://ItemCell.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	init([[1, 1], [1, 2]])
	
func init(point_list):
	for i in range(len(point_list)):
		var new_cell = create_cell(point_list[i])
		new_cell.connect("picked_up", self, "_item_picked_up", [i])
		add_child(new_cell)
			
func create_cell(point):
	var x = point[0]
	var y = point[1]
	var polygon = [Vector2(CELL_SIZE*x, CELL_SIZE*y),
				   Vector2(CELL_SIZE*x, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y)]
	var new_cell = item_cell.instance()
	new_cell.get_node("Polygon2D").polygon = polygon
	new_cell.get_node("CollisionPolygon2D").polygon = polygon
	return new_cell
	
func _item_picked_up(index):
	print("clicked on index", index)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
