extends KinematicBody2D

export (float) var SPEED = 100
export (PackedScene) var Bullet = preload("Bullet.tscn")

enum {PLAYER_ACTIVE, PLAYER_STUNNED, PLAYER_DEAD}
var player_state = PLAYER_ACTIVE

var normal_path = load(ProjectSettings.globalize_path("res://art/player.png"))
var left_path = load(ProjectSettings.globalize_path("res://art/player_moving_left.png"))
var right_path = load(ProjectSettings.globalize_path("res://art/player_moving_right.png"))
var up_path = load(ProjectSettings.globalize_path("res://art/player_moving_up.png"))
var down_path = load(ProjectSettings.globalize_path("res://art/player_moving_down.png"))

signal picked_up_item(item)
signal destroyed_all_items

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

	
func _process(delta):
	var texture = normal_path
	if player_state == PLAYER_ACTIVE:
		var input_dir  = Vector2(0, 0)
		if Input.is_action_pressed("ui_right"):
			input_dir += Vector2(1, 0)
			texture = right_path
		elif Input.is_action_pressed("ui_left"):
			input_dir += Vector2(-1, 0)
			texture = left_path
		if Input.is_action_pressed("ui_up"):
			input_dir += Vector2(0, -1)
			texture = up_path
		elif Input.is_action_pressed("ui_down"):
			input_dir += Vector2(0, 1)
			texture = down_path
		move_and_slide(SPEED*(input_dir.normalized()))
	$Sprite.texture = texture
	
func try_pick_up(game_item):
	emit_signal("picked_up_item", game_item)

func take_damage(damage):
	# stun player
	if player_state == PLAYER_ACTIVE:
		player_state = PLAYER_STUNNED
		$StunTimer.start()
		$HitSound.play()
	
func total_attack():
	return stats().base_attack_power + stats().bonus_attack

func doomify():
	# maybe should be some general death function if the player can die in some other way?
	if player_state != PLAYER_DEAD:
		player_state = PLAYER_DEAD
		$DeathSound.play()
	
	
func stats():
	return get_node("Stats")

func _on_BulletTimer_timeout():
	if player_state == PLAYER_ACTIVE:
		var bullet = Bullet.instance()
		bullet.position = position
		bullet.is_player_bullet = true
		var bullet_stats = bullet.get_node("BulletStats")
		bullet_stats.base_damage = total_attack()
		bullet_stats.red_damage = int($Stats.red_multiplier * total_attack())
		bullet_stats.blue_damage = int($Stats.blue_multiplier * total_attack())
		bullet_stats.green_damage = int($Stats.green_multiplier * total_attack())
		$BulletSound.play()
		$bullets.add_child(bullet)

func _on_StunTimer_timeout():
	# stun over
	player_state = PLAYER_ACTIVE


func _on_DeathSound_finished():
	queue_free()
	get_tree().change_scene("res://TitleScreen.tscn")
