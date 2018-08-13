extends Node2D

signal clicked_on(v)
signal released(v)
signal updated

export (int) var CELL_SIZE
export (int) var HEIGHT
export (int) var WIDTH

var inventory_cell = preload("res://InventoryGridCell.tscn")

# The plan is each entry of grid_contents contains a reference
# to the item it holds, or null if it isn't holding any item. 
# (this might be a bad way to do it though, I'm not sure)
# grid_item_cells is the same but holds individual ItemCells
var grid_contents = []
var grid_item_cells = []
var items_in_grid = []

func _ready():
	for i in range(WIDTH):
		for j in range(HEIGHT):
			var v = Vector2(i, j)
			var new_cell = create_and_add_cell(v)
			new_cell.connect("clicked_on", self, "_cell_clicked_on", [v])
			new_cell.connect("released", self, "_cell_released", [v])
	
	for i in range(WIDTH):
		var empty_row = []
		for j in range(HEIGHT):
			empty_row.append(null)
		grid_contents.append(empty_row)
		
	for i in range(WIDTH):
		var empty_row = []
		for j in range(HEIGHT):
			empty_row.append(null)
		grid_item_cells.append(empty_row)
		
	
"""func create_and_add_cell(v):	
	var polygon = [CELL_SIZE * (v + Vector2(0.05, 0.05)),
				   CELL_SIZE * (v + Vector2(0.05, 0.95)),
				   CELL_SIZE * (v + Vector2(0.95, 0.95)),
				   CELL_SIZE * (v + Vector2(0.95, 0.05))]
		
	var new_cell = inventory_cell.instance()
	new_cell.get_node("Polygon2D").polygon = polygon
	new_cell.get_node("CollisionPolygon2D").polygon = polygon

	add_child(new_cell)
	return new_cell
"""

func create_and_add_cell(point):	
	var new_cell = inventory_cell.instance()
	var sprite_size = new_cell.get_node("Sprite").get_texture().get_size()
	var sprite_scale_x = CELL_SIZE / sprite_size.x
	var sprite_scale_y = CELL_SIZE / sprite_size.y
	new_cell.position = CELL_SIZE * point
	new_cell.scale = Vector2(sprite_scale_x, sprite_scale_y)
	
	add_child(new_cell)
	return new_cell
	
func _cell_clicked_on(v):
	emit_signal("clicked_on", v)
	
func _cell_released(v):
	emit_signal("released", v)
	
# Given an item (which contains a list of lattice points, cell_point_list),
# a "base point" in the item list, and a point in the grid, return if the
# item can be placed in the grid so that the item base point coincides with
# the grid base point and doesn't intersect with any existing items.
func can_place_item(item, item_base_point, grid_base_point):
	for cell in item.cell_point_list:
		var v = cell - item_base_point + grid_base_point
		if v[0] < 0 or v[1] < 0 or v[0] >= WIDTH or v[1] >= HEIGHT:
			return false
		if not grid_contents[v[0]][v[1]] == null:
			return false 
	return true
	
func place_item(item, item_base_point, grid_base_point):
	assert can_place_item(item, item_base_point, grid_base_point)
	assert not item in items_in_grid
	
	items_in_grid.append(item)
	for i in range(len(item.cell_list)):
		var cell_point = item.cell_point_list[i]
		var v = cell_point - item_base_point + grid_base_point
		grid_contents[v[0]][v[1]] = item
		grid_item_cells[v[0]][v[1]] = item.cell_list[i]
	
	item.position = position + (grid_base_point - item_base_point) * CELL_SIZE
	item.grid_location = [item_base_point, grid_base_point]
	emit_signal("updated")
		
func remove_item(item):
	assert item in items_in_grid
	
	for i in range(WIDTH):
		for j in range(HEIGHT):
			if grid_contents[i][j] == item:
				grid_contents[i][j] = null
				grid_item_cells[i][j] = null
	items_in_grid.erase(item)
	item.grid_location = null
	emit_signal("updated")
	
func get_bonus_attack_total():
	var bonus_attack = 0
	for item in items_in_grid:
		bonus_attack += item.stats().bonus_attack
	return bonus_attack
		
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
