extends Node

var item_scene = preload("res://Item.tscn")

var item3_1 = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)]
var item3_2 = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1)]
var item3s = [item3_1, item3_2]

var item4_1 = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3,0)]
var item4_2 = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(2,1)]
var item4_3 = [Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(1,1)]
var item4_4 = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2,1)]
var item4_5 = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1,1)]
var item4s = [item4_1, item4_2, item4_3, item4_4, item4_5]

var ItemColor = preload("res://ItemCell.gd").ItemColor
var colors = [ItemColor.RED, ItemColor.GREEN, ItemColor.BLUE]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func random_item(item_level):
	var item_points
	var bonus_attack
	
	if randi()%3 == 0:
		item_points = item3s[randi()%(len(item3s))]
		bonus_attack = item_level
	else:
		item_points = item4s[randi()%(len(item4s))]
		bonus_attack = (3*item_level)/2
		
	bonus_attack += randi() % (1 + (item_level/2))
	
	var item = item_scene.instance()
	item.init(item_points)
	item.stats().bonus_attack = bonus_attack
	item.set_cell_text(0, str(bonus_attack))
	
	set_item_cell_colors(item)
	
	return item
	
func set_item_cell_colors(item):
	for cell in item.cell_list:
		cell.set_color(colors[randi()%(len(colors))])

# Pick one of the random 8 transformations.
func random_transform(point):
	for i in range(randi()%4):
		point = Vector2(-point.y, point.x)
	
	if randi()%2 == 0:
		point = Vector2(-point.x, point.y)
	
	return point

	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
