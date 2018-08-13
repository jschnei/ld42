extends Node

enum EnemyBulletBehavior { ONE_DIRECT_BULLET, MULTIPLE_BULLETS }

var EnemyBullet = preload("res://EnemyBullet.tscn")

var enemy

var bullet_behavior = EnemyBulletBehavior.ONE_DIRECT_BULLET

func shoot_one_direct_bullet():
	var new_bullet = EnemyBullet.instance()
	new_bullet.position = enemy.position
	enemy.get_node("Bullets").add_child(new_bullet)
	new_bullet.direction = (enemy.target.position - enemy.position).normalized()

func shoot_multiple_bullets():
	# TODO: implement this
	pass

func shoot():
	if bullet_behavior == EnemyBulletBehavior.ONE_DIRECT_BULLET:
		shoot_one_direct_bullet()
	elif bullet_behavior == EnemyBulletBehavior.MULTIPLE_BULLETS:
		shoot_multiple_bullets()

func _ready():
	enemy = get_parent()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
