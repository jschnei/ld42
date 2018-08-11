extends Node2D

var item = preload("res://Item.tscn")

var is_holding_item = false
var held_item = null
var held_item_cell = 0

func _ready():
	# initialize some fake items
	var item1 = item.instance()
	item1.init([[0, 0], [0, 1], [0, 2]])
	
	var item2 = item.instance()
	item2.init([[2, 0], [2, 1], [2, 2]])
	
	for item in [item1, item2]:
		item.connect("clicked_on", self, "_item_clicked_on", [item])
		add_child(item)
		
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

func _input(event):
	if is_holding_item:
		if event is InputEventMouseMotion:
			# TODO: this seems to go out of sync if you move the mouse really quickly
			held_item.position = held_item.position + event.relative

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
