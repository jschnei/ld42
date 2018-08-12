extends Node2D

var item = preload("res://Item.tscn")
var inventory_grid = preload("res://InventoryGrid.tscn")
var holding_area_scene = preload("res://HoldingArea.tscn")

var held_item = null
var held_item_cell = 0
var time_held = 0

var item_clicked_this_frame = null
var cell_index_clicked_this_frame = null
var grid_cell_clicked_this_frame = null
var holding_area_clicked_this_frame = false
var clicked_this_frame = false
var released_this_frame = false

var grid = null
var holding_area = null

func _ready():
	# initialize some fake items
	var item1 = item.instance()
	item1.init([Vector2(0, 1), Vector2(0, 2), Vector2(0, 3)])
	
	var item2 = item.instance()
	item2.init([Vector2(2, 0), Vector2(2, 1), Vector2(3, 1)])
	
	for item in [item1, item2]:
		item.connect("clicked_on", self, "_item_clicked_on", [item])
		add_child(item)
		
	grid = inventory_grid.instance()
	grid.position = Vector2(100, 50)
	grid.connect("clicked_on", self, "_grid_clicked_on")
	grid.connect("released", self, "_grid_released")
	add_child(grid)
	
	initialize_holding_area()
	
func initialize_holding_area():
	holding_area = holding_area_scene.instance()
	var sprite_size = holding_area.get_node("Sprite").get_texture().get_size()
	var sprite_scale_x = grid.WIDTH*grid.CELL_SIZE / sprite_size.x
	var sprite_scale_y = grid.HEIGHT*grid.CELL_SIZE / sprite_size.y
	holding_area.position = Vector2(grid.position.x + grid.WIDTH*grid.CELL_SIZE/2,
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
			held_item.position = get_local_mouse_position() - (held_item.point_at(held_item_cell) + Vector2(0.5, 0.5)) * grid.CELL_SIZE
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			clicked_this_frame = true
		else:
			released_this_frame = true

func drop():
	if grid_cell_clicked_this_frame != null:
		print("clicked on grid ", grid_cell_clicked_this_frame)
		if held_item != null:
			if grid.can_place_item(held_item, held_item.point_at(held_item_cell), grid_cell_clicked_this_frame):
				grid.place_item(held_item, held_item.point_at(held_item_cell), grid_cell_clicked_this_frame)
				held_item = null
	elif holding_area_clicked_this_frame:
		if held_item != null:
			if holding_area.can_place_item():
				holding_area.place_item(held_item)
				held_item = null
	elif held_item != null:
		print("dropping item")
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
