extends KinematicBody2D

onready var target = get_parent().get_node("Player")
export (PackedScene) var EnemyBullet = preload("EnemyBullet.tscn")

func _ready():
	pass

func take_damage(damage):
	$Stats.take_damage(damage)
	$HealthBar.update_bar($Stats.cur_health, $Stats.max_health)
		
func doomify():
	queue_free()

func _on_Stats_death():
	queue_free()

func _on_ShotTimer_timeout():
	var new_bullet = EnemyBullet.instance()
	new_bullet.position = position
	$Bullets.add_child(new_bullet)
	new_bullet.direction = (target.position - position).normalized()
