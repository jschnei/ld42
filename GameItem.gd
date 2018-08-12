extends Area2D

var item_scene = preload("res://Item.tscn")

var item = null
var picked_up = false

func _ready():
	if item == null:
		# Default item shape
		item = item_scene.instance()
		item.init([Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2,1)])

func _process(delta):
	if picked_up == true:
		hide()
	else:
		show()


func _on_GameItem_body_entered(player):
	player.try_pick_up(self)
