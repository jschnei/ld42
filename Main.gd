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
	player.connect("destroyed_all_items", self, "_player_destroyed_all_items")
	inventory.grid.connect("updated", self, "_update_player")
	_update_hud()

func _process(delta):
	pass
	
func _player_picked_up_item(game_item):
	if inventory.can_pickup_item():
		game_item.picked_up = true
		inventory.pickup_item(game_item.item)
		game_item.queue_free()

func _player_destroyed_all_items():
	print("destroying all the items!")
	inventory.trash_all_items()
		
func _update_player():
	player.stats().bonus_attack = inventory.grid.get_bonus_attack_total()
	player.stats().red_multiplier = inventory.grid.get_red_multiplier()
	player.stats().blue_multiplier = inventory.grid.get_blue_multiplier()
	player.stats().green_multiplier = inventory.grid.get_green_multiplier()
	_update_hud()

func _update_hud():
	var hud = inventory.get_node("InventoryHUD")
	hud.set_attack_label(player.total_attack())
	hud.set_red_label(player.stats().red_multiplier)
	hud.set_blue_label(player.stats().blue_multiplier)
	hud.set_green_label(player.stats().green_multiplier)