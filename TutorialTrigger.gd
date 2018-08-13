extends Area2D

var lines = []
var triggered = false

func _on_TutorialTrigger_area_entered(player):
	pass
	


func _on_TutorialTrigger_body_entered(player):
	print('triggering something')
	if not triggered:
		player.get_node("TutorialText").set_lines(lines)
		triggered = true
