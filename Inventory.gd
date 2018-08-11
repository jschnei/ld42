extends Node2D

var item = preload("res://Item.tscn")
var inventory_grid = preload("res://InventoryGrid.tscn")

var is_holding_item = false
var held_item = null
var held_item_cell = 0

var grid = null

func _ready():
	# initialize some fake items
	var item1 = item.instance()
	item1.init([[0, 0], [0, 1], [0, 2]])
	
	var item2 = item.instance()
	item2.init([[2, 0], [2, 1], [2, 2]])
	
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
	if is_holding_item and held_item == item:
		print("dropping item")
		is_holding_item = false
		held_item = null
	elif not is_holding_item:
		print("now holding item")
		is_holding_item = true
		held_item = item
		held_item_cell = cell_index

# x, y is row, column of the grid "matrix"		
func _grid_clicked_on(x, y):
	print("clicked on grid ", x, y)
	if is_holding_item:
		if grid.is_item_placeable(held_item, held_item.point_at(held_item_cell), [x, y]):
			# TODO: place the item in the grid
			pass
	pass

func _input(event):
	if is_holding_item:
		if event is InputEventMouseMotion:
			# TODO: this seems to go out of sync if you move the mouse really quickly
			# It would probably be best to always move the item so that the
			# center of the clicked item cell follows the mouse.
			held_item.position = held_item.position + event.relative

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
