extends "res://Enemy.gd"

var Bullet = preload("res://Bullet.gd")

var MAX_HEALTH = 9

var red_boss_path = "res://art/red_enemy.png"
var green_boss_path = "res://art/green_enemy.png"
var blue_boss_path = "res://art/blue_enemy.png"

# 3 phases for now
var phase = 1

var current_color
var current_direction = Vector2(100, 0)

func _ready():
	$Stats.max_health = MAX_HEALTH
	$Stats.cur_health = $Stats.max_health
	change_color("RED")
	pass

func update_resistances():
	$Stats.base_weakness = 1
	$Stats.red_weakness = 0
	$Stats.blue_weakness = 0
	$Stats.green_weakness = 0
	if current_color == "RED":
		$Stats.red_weakness = 1
	elif current_color == "GREEN":
		$Stats.green_weakness = 1
	elif current_color == "BLUE":
		$Stats.blue_weakness = 1
		
func update_sprite():
	var texture = ImageTexture.new()
	if current_color == "RED":
		texture.load(red_boss_path)
	elif current_color == "GREEN":
		texture.load(green_boss_path)
	elif current_color == "BLUE":
		texture.load(blue_boss_path)
	$Sprite.texture = texture
		
func change_color(color):
	current_color = color
	update_resistances()
	update_sprite()

func _process(delta):
	if current_color == "RED" and $Stats.cur_health <= MAX_HEALTH*2/3:
		print("woooo")
		phase += 1
		change_color("GREEN")
	elif current_color == "GREEN" and $Stats.cur_health <= MAX_HEALTH/3:
		phase += 1
		change_color("BLUE")
	
	var collision = move_and_collide(current_direction*delta)
	if collision:
		var collider = collision.collider
		if collider is Bullet and collider.is_player_bullet:
			take_damage(collider.get_node("BulletStats"))
			collider.queue_free()

func _on_SpreadShotTimer_timeout():
	if phase >= 2:
		$EnemyBehavior.spread_shot(5)

func _on_ColumnShotTimer_timeout():
	if phase >= 3:
		$EnemyBehavior.column_shot(6)

func _on_ChangeDirectionTimer_timeout():
	current_direction = Vector2(-current_direction.x, current_direction.y)
