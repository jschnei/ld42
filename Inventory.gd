extends Node2D

var item = preload("res://Item.tscn")
var inventory_grid = preload("res://InventoryGrid.tscn")
var holding_area_scene = preload("res://HoldingArea.tscn")

var held_item = null
var held_item_cell = 0
var time_held = 0

# See save_location_of_item for the format of this.
# This is used to return items to their original locations if they
# are dropped in an invalid place
var saved_item_location = null

var item_clicked_this_frame = null
var cell_index_clicked_this_frame = null
var grid_cell_clicked_this_frame = null
var holding_area_clicked_this_frame = false
var clicked_this_frame = false
var released_this_frame = false

var grid = null
var holding_area = null

func _ready():
	grid = inventory_grid.instance()
	grid.position = Vector2(100, 50)
	grid.connect("clicked_on", self, "_grid_clicked_on")
	grid.connect("released", self, "_grid_released")
	add_child(grid)
	
	initialize_holding_area()
	
	# Uncomment if you want to test inventory by itself.
	"""
	var item1 = item.instance()
	item1.init([Vector2(0, 1), Vector2(0, 2), Vector2(0, 3)])

	var item2 = item.instance()
	item2.init([Vector2(2, 0), Vector2(2, 1), Vector2(3, 1)])

	for item in [item1, item2]:
		item.connect("clicked_on", self, "_item_clicked_on", [item])
		item.stats().bonus_attack = 1
		add_child(item)
	"""
	
func initialize_holding_area():
	holding_area = holding_area_scene.instance()
	var sprite_size = holding_area.get_node("Sprite").get_texture().get_size()
	var sprite_scale_x = grid.WIDTH*grid.CELL_SIZE / sprite_size.x
	var sprite_scale_y = grid.HEIGHT*grid.CELL_SIZE / sprite_size.y
	holding_area.position = Vector2(grid.position.x + grid.WIDTH*grid.CELL_SIZE/2 - grid.CELL_SIZE/2,
									grid.position.y + grid.HEIGHT*grid.CELL_SIZE*3/2 + 50)
	holding_area.scale = Vector2(sprite_scale_x, sprite_scale_y)
	holding_area.connect("clicked_or_released", self, "_holding_area_clicked_or_released")
	add_child(holding_area)
		
func _item_clicked_on(cell_index, item):
	# print(cell_index)
	# print(item.point_at(cell_index))
	item_clicked_this_frame = item
	cell_index_clicked_this_frame = cell_index
	

# v is vector of the grid "matrix" clicked		
func _grid_clicked_on(v):
	grid_cell_clicked_this_frame = v
	
func _grid_released(v):
	grid_cell_clicked_this_frame = v
	
func _holding_area_clicked_or_released():
	holding_area_clicked_this_frame = true

func _input(event):
	if event is InputEventMouseMotion:
		if held_item != null:
			# Move the item so that the center of the clicked item cell follows the mouse.
			held_item.position = get_local_mouse_position() - held_item.point_at(held_item_cell) * grid.CELL_SIZE
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			clicked_this_frame = true
		else:
			released_this_frame = true
	elif event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.pressed and held_item != null:
			trash_held_item()

func drop():
	if held_item == null:
		return
		
	if grid_cell_clicked_this_frame != null:
		if grid.can_place_item(held_item, held_item.point_at(held_item_cell), grid_cell_clicked_this_frame):
			grid.place_item(held_item, held_item.point_at(held_item_cell), grid_cell_clicked_this_frame)
			held_item = null
	elif holding_area_clicked_this_frame:
		if holding_area.can_place_item():
			holding_area.place_item(held_item)
			held_item = null
	else:
		restore_saved_item(held_item)
		held_item = null

func can_pickup_item():
	return holding_area.held_item == null and held_item == null
	
func pickup_item(item):
	assert can_pickup_item()

	item.connect("clicked_on", self, "_item_clicked_on", [item])
	add_child(item)
	holding_area.place_item(item)
	
func save_location_of_item(item):
	if item in grid.items_in_grid:
		saved_item_location = ["Grid", item.grid_location]
	elif item == holding_area.held_item:
		saved_item_location = ["HoldingArea"]
	else:
		saved_item_location = ["Unknown"]

func restore_saved_item(item):
	if saved_item_location[0] == "Grid":
		var grid_location = saved_item_location[1]
		grid.place_item(item, grid_location[0], grid_location[1])
	elif saved_item_location[0] == "HoldingArea":
		holding_area.place_item(item)
	else:
		print("unknown previous location of item, dropping in place")
		pass

func trash_held_item():
	held_item.queue_free()
	held_item = null

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if clicked_this_frame:
		time_held = 0
		if item_clicked_this_frame != null and held_item == null:
			print("now holding item")
			held_item = item_clicked_this_frame
			held_item_cell = cell_index_clicked_this_frame
			save_location_of_item(held_item)
			if held_item in grid.items_in_grid:
				grid.remove_item(held_item)
			if held_item == holding_area.held_item:
				holding_area.remove_item(held_item)
		else:
			drop()
	elif released_this_frame and time_held >= 0.17:
		drop()
			
	
	item_clicked_this_frame = null
	cell_index_clicked_this_frame = null
	grid_cell_clicked_this_frame = null
	holding_area_clicked_this_frame = false
	clicked_this_frame = false
	released_this_frame = false
	time_held += delta
