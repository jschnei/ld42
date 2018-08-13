extends KinematicBody2D

onready var target = get_parent().get_parent().get_node("Player")
export (PackedScene) var EnemyBullet = preload("EnemyBullet.tscn")

signal dropped_item
signal death
signal death_by_player

var item_to_drop = null

func _ready():
	pass

func take_damage(bullet_stats):
	if $Stats.get_damage(bullet_stats) > 0:
		$HitSound.play()
		$Stats.take_damage(bullet_stats)
		$HealthBar.update_bar($Stats.cur_health, $Stats.max_health)
	else:
		$NoDamageHitSound.play()
		
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
	emit_signal("death_by_player")
	die()
	
func die():
	emit_signal("death")
	queue_free()

func _on_ShotTimer_timeout():
	$EnemyBehavior.shoot()



