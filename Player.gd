extends KinematicBody2D

export (float) var SPEED = 100
export (PackedScene) var Bullet = preload("Bullet.tscn")

enum {PLAYER_ACTIVE, PLAYER_STUNNED}
var player_state = PLAYER_ACTIVE

signal picked_up_item(item)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if player_state == PLAYER_ACTIVE:
		var input_dir  = Vector2(0, 0)
		if Input.is_action_pressed("ui_right"):
			input_dir += Vector2(1, 0)
		elif Input.is_action_pressed("ui_left"):
			input_dir += Vector2(-1, 0)
			
		if Input.is_action_pressed("ui_up"):
			input_dir += Vector2(0, -1)
		elif Input.is_action_pressed("ui_down"):
			input_dir += Vector2(0, 1)
		
		move_and_slide(SPEED*(input_dir.normalized()))
	
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
