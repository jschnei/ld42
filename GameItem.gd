extends Area2D

var item = null
var picked_up = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass	

func _process(delta):
	if picked_up == true:
		hide()
	else:
		show()


func _on_GameItem_body_entered(player):
	player.try_pick_up(self)
