extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var game
var player
var inventory

func _ready():
	game = $ViewportContainer/Viewport/Game
	player = $ViewportContainer/Viewport/Game/Player
	inventory = $ViewportContainer2/Viewport/Inventory
	player.connect("picked_up_item", self, "_player_picked_up_item")
	inventory.grid.connect("updated", self, "_update_player")

func _process(delta):
	pass
	
func _player_picked_up_item(game_item):
	if inventory.can_pickup_item():
		game_item.picked_up = true
		inventory.pickup_item(game_item.item)
		game_item.queue_free()
		
func _update_player():
	player.bonus_attack = inventory.grid.get_bonus_attack_total()
