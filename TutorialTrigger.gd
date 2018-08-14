extends Area2D

var lines = []
var triggered = false
var destroy_items = false
var slow_doom = false
var end_game = false


func _on_TutorialTrigger_area_entered(player):
	pass
	


func _on_TutorialTrigger_body_entered(player):
	if not triggered:
		if end_game:
			get_tree().change_scene("res://EndScreen.tscn")
		player.get_node("TutorialText").set_lines(lines)
		if destroy_items:
			player.emit_signal("destroyed_all_items")
		if slow_doom:
			print('triggering slow doom')
			player.get_parent().slow_doom()
		triggered = true
