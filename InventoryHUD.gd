extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func set_attack_label(attack):
	$AttackLabel.text = "Base attack: " + str(attack)
	
func set_red_label(red):
	$RedLabel.text = "Bonus vs. red: " + str(100*red) + "%"
	
func set_blue_label(blue):
	$BlueLabel.text = "Bonus vs. blue: " + str(100*blue) + "%"

func set_green_label(green):
	$GreenLabel.text = "Bonus vs. green: " + str(100*green) + "%"	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
