extends Node2D

signal clicked_on(x, y)

export (int) var CELL_SIZE
export (int) var HEIGHT
export (int) var WIDTH

var inventory_cell = preload("res://InventoryGridCell.tscn")

# The plan is each entry of grid_contents contains a reference
# to the item it holds, or null if it isn't holding any item. 
# (this might be a bad way to do it though, I'm not sure)
var grid_contents = []
var items_in_grid = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for i in range(WIDTH):
		for j in range(HEIGHT):
			var new_cell = create_and_add_cell(i, j)
			new_cell.connect("clicked_on", self, "_cell_clicked_on", [i, j])

func create_and_add_cell(x, y):	
	var polygon = [Vector2(CELL_SIZE*x, CELL_SIZE*y),
				   Vector2(CELL_SIZE*x, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y)]
				
	# NOTE: this is just a hack to make grid borders clearer, we should get rid of this
	for i in len(polygon):
		polygon[i] += Vector2(x, y)
		
	var new_cell = inventory_cell.instance()
	new_cell.get_node("Polygon2D").polygon = polygon
	new_cell.get_node("CollisionPolygon2D").polygon = polygon

	add_child(new_cell)
	return new_cell
	
func _cell_clicked_on(i, j):
	emit_signal("clicked_on", i, j)
	
# Given an item (which contains a list of lattice points, cell_point_list),
# a "base point" in the item list, and a point in the grid, return if the
# item can be placed in the grid so that the item base point coincides with
# the grid base point and doesn't intersect with any existing items.
func is_item_placeable(item, item_base_point, grid_base_point):
	for cell in item.cell_point_list:
		var x = cell[0] - item_base_point[0] + grid_base_point[0]
		var y = cell[1] - item_base_point[1] + grid_base_point[0]
		if not grid_contents[x][y] == null:
			return false 
	return true
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
