extends Area2D

var lines = []
var triggered = false
var destroy_items = false

func _on_TutorialTrigger_area_entered(player):
	pass
	


func _on_TutorialTrigger_body_entered(player):
	print('triggering something')
	if not triggered:
		player.get_node("TutorialText").set_lines(lines)
		if destroy_items:
			print('destroying the items!')
			player.emit_signal("destroyed_all_items")
		triggered = true
