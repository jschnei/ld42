extends KinematicBody2D

onready var target = get_parent().get_parent().get_node("Player")
export (PackedScene) var EnemyBullet = preload("EnemyBullet.tscn")

signal dropped_item
signal death

var item_to_drop = null

func _ready():
	pass

func take_damage(damage):
	$Stats.take_damage(damage)
	$HealthBar.update_bar($Stats.cur_health, $Stats.max_health)
		
func doomify():
	die()

func _process(delta):
	var game = get_parent().get_parent()
	position.x = clamp(position.x, game.left_wall, game.right_wall)

func set_level(level):
	$Stats.max_health = 4*level - 3
	$Stats.cur_health = 4*level - 3

func item_probability(level):
	return 0.2

func _on_Stats_death():
	emit_signal("dropped_item")
	die()

func die():
	emit_signal("death")
	queue_free()

func _on_ShotTimer_timeout():
	var new_bullet = EnemyBullet.instance()
	new_bullet.position = position
	$Bullets.add_child(new_bullet)
	new_bullet.direction = (target.position - position).normalized()
