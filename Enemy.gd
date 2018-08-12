extends KinematicBody2D

func _ready():
	pass

func take_damage(damage):
	$Stats.take_damage(damage)
	$HealthBar.update_bar($Stats.cur_health, $Stats.max_health)
		
func doomify():
	queue_free()

func _on_Stats_death():
	queue_free()
