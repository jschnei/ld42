extends Area2D

var item_scene = preload("res://Item.tscn")

var item = null
var picked_up = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	item = item_scene.instance()
	item.init([Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2,1)])
	pass	

func _process(delta):
	if picked_up == true:
		hide()
	else:
		show()


func _on_GameItem_body_entered(player):
	player.try_pick_up(self)
