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
	for i in range(WIDTH):
		for j in range(HEIGHT):
			var new_cell = create_and_add_cell(i, j)
			new_cell.connect("clicked_on", self, "_cell_clicked_on", [i, j])
	
	# Note that i, j is swapped here. This is because I want the cell
	# (x, y) to correspond to the xth column and yth row (because that
	# is how pixels work), but in grid_contents matrix (x,y) would be
	# the xth row and yth column.	
	for i in range(HEIGHT):
		var empty_row = []
		for j in range(WIDTH):
			empty_row.append(null)
		grid_contents.append(empty_row)

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
		if x < 0 or y < 0 or x >= HEIGHT or y >= WIDTH:
			return false
		if not grid_contents[x][y] == null:
			return false 
	return true
	
func place_item(item, item_base_point, grid_base_point):
	assert is_item_placeable(item, item_base_point, grid_base_point)
	assert not item in items_in_grid
	
	items_in_grid.append(item)
	for cell in item.cell_point_list:
		var x = cell[0] - item_base_point[0] + grid_base_point[0]
		var y = cell[1] - item_base_point[1] + grid_base_point[0]
		grid_contents[x][y] = item
	
	item.position = position + (grid_base_point - item_base_point) * CELL_SIZE
		
func remove_item(item):
	assert item in items_in_grid
	
	for i in range(HEIGHT):
		for j in range(WIDTH):
			if grid_contents[i][j] == item:
				grid_contents[i][j] = null
	items_in_grid.erase(item)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
