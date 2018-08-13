extends "res://Enemy.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$EnemyBehavior.set_idle()
	
func set_level(level):
	$Stats.max_health = 10
	$Stats.cur_health = $Stats.max_health

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
