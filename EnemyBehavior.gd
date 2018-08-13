extends Node

enum EnemyBulletBehavior { ONE_DIRECT_BULLET, MULTIPLE_BULLETS,
						   BOSS_PHASE_ONE, BOSS_PHASE_TWO, BOSS_PHASE_THREE,
						   IDLE }

var EnemyBullet = preload("res://EnemyBullet.tscn")

var SCREEN_WIDTH = 512

var enemy

var bullet_behavior = EnemyBulletBehavior.ONE_DIRECT_BULLET

func set_idle():
	bullet_behavior = EnemyBulletBehavior.IDLE

func shoot_one_direct_bullet():
	var new_bullet = EnemyBullet.instance()
	new_bullet.position = enemy.position
	enemy.get_node("Bullets").add_child(new_bullet)
	new_bullet.direction = (enemy.target.position - enemy.position).normalized()

func spread_shot(num_bullets):
	var initial_offset = randf() * PI/num_bullets
	for i in range(num_bullets):
		var new_bullet = EnemyBullet.instance()
		new_bullet.position = enemy.position
		enemy.get_node("Bullets").add_child(new_bullet)
		new_bullet.direction = Vector2(1, 0).rotated(initial_offset + i*PI/num_bullets)

func column_shot(num_bullets):
	var initial_offset = randf() * SCREEN_WIDTH/num_bullets
	for i in range(num_bullets):
		var new_bullet = EnemyBullet.instance()
		new_bullet.position = Vector2(initial_offset + i*SCREEN_WIDTH/num_bullets, enemy.position.y)
		enemy.get_node("Bullets").add_child(new_bullet)
		new_bullet.direction = Vector2(0, 1)

func shoot():
	if bullet_behavior == EnemyBulletBehavior.ONE_DIRECT_BULLET:
		shoot_one_direct_bullet()

func _ready():
	enemy = get_parent()
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
