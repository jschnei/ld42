extends Node2D

var item = preload("res://Item.tscn")
var inventory_grid = preload("res://InventoryGrid.tscn")

var held_item = null
var held_item_cell = 0

var item_clicked_this_frame = null;
var cell_index_clicked_this_frame = null;
var grid_cell_clicked_this_frame = null;
var clicked_this_frame = false;

var grid = null

func _ready():
	# initialize some fake items
	var item1 = item.instance()
	item1.init([Vector2(0, 0), Vector2(0, 1), Vector2(0, 2)])
	
	var item2 = item.instance()
	item2.init([Vector2(2, 0), Vector2(2, 1), Vector2(3, 1)])
	
	for item in [item1, item2]:
		item.connect("clicked_on", self, "_item_clicked_on", [item])
		add_child(item)
		
	grid = inventory_grid.instance()
	grid.position = Vector2(500, 300)
	grid.connect("clicked_on", self, "_grid_clicked_on")
	add_child(grid)
		
func _item_clicked_on(cell_index, item):
	# print(cell_index)
	# print(item.point_at(cell_index))
	item_clicked_this_frame = item
	cell_index_clicked_this_frame = cell_index
	
	

# v is vector of the grid "matrix" clicked		
func _grid_clicked_on(v):
	grid_cell_clicked_this_frame = v
	

func _input(event):
	if event is InputEventMouseMotion:
		if held_item != null:
			# TODO: this seems to go out of sync if you move the mouse really quickly
			# It would probably be best to always move the item so that the
			# center of the clicked item cell follows the mouse.
			held_item.position = get_local_mouse_position() - (held_item.point_at(held_item_cell) + Vector2(0.5, 0.5)) * grid.CELL_SIZE
	elif event is InputEventMouseButton:
		clicked_this_frame = clicked_this_frame or event.pressed

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if clicked_this_frame:
		if item_clicked_this_frame != null and held_item == null:
			print("now holding item")
			held_item = item_clicked_this_frame
			held_item_cell = cell_index_clicked_this_frame
			if held_item in grid.items_in_grid:
				grid.remove_item(held_item)
		elif grid_cell_clicked_this_frame != null: 
			print("clicked on grid ", grid_cell_clicked_this_frame)
			if held_item != null:
				if grid.is_item_placeable(held_item, held_item.point_at(held_item_cell), grid_cell_clicked_this_frame):
					# TODO: place the item in the grid
					grid.place_item(held_item, held_item.point_at(held_item_cell), grid_cell_clicked_this_frame)
					held_item = null
		elif held_item != null:
			print("dropping item")
			held_item = null
	
	item_clicked_this_frame = null;
	cell_index_clicked_this_frame = null;
	grid_cell_clicked_this_frame
	clicked_this_frame = false;
	pass
