extends KinematicBody2D

export (float) var SPEED = 100
export (PackedScene) var Bullet = preload("Bullet.tscn")

enum {PLAYER_ACTIVE, PLAYER_STUNNED}
var player_state = PLAYER_ACTIVE

var normal_path = "res://art/player.png"
var left_path = "res://art/player_moving_left.png"
var right_path = "res://art/player_moving_right.png"
var up_path = "res://art/player_moving_up.png"
var down_path = "res://art/player_moving_down.png"

signal picked_up_item(item)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

	
func _process(delta):
	var texture = ImageTexture.new()
	if player_state == PLAYER_ACTIVE:
		var input_dir  = Vector2(0, 0)
		texture.load(normal_path)
		if Input.is_action_pressed("ui_right"):
			input_dir += Vector2(1, 0)
			texture.load(right_path)
		elif Input.is_action_pressed("ui_left"):
			input_dir += Vector2(-1, 0)
			texture.load(left_path)
		if Input.is_action_pressed("ui_up"):
			input_dir += Vector2(0, -1)
			texture.load(up_path)
		elif Input.is_action_pressed("ui_down"):
			input_dir += Vector2(0, 1)
			texture.load(down_path)
		move_and_slide(SPEED*(input_dir.normalized()))
	$Sprite.texture = texture
	
func try_pick_up(game_item):
	emit_signal("picked_up_item", game_item)

func take_damage(damage):
	# stun player
	if player_state == PLAYER_ACTIVE:
		player_state = PLAYER_STUNNED
		$StunTimer.start()
	
	
func total_attack():
	return stats().base_attack_power + stats().bonus_attack

func doomify():
	queue_free()
	
func stats():
	return get_node("Stats")

func _on_BulletTimer_timeout():
	if player_state == PLAYER_ACTIVE:
		var bullet = Bullet.instance()
		bullet.position = position
		bullet.damage = total_attack()
		$bullets.add_child(bullet)

func _on_StunTimer_timeout():
	# stun over
	player_state = PLAYER_ACTIVE
