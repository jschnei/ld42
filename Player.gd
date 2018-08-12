extends KinematicBody2D

export (float) var SPEED = 100
export (PackedScene) var Bullet = preload("Bullet.tscn")

const MAX_BULLETS = 5

signal picked_up_item(item)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	var input_dir  = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		input_dir += Vector2(1, 0)
	elif Input.is_action_pressed("ui_left"):
		input_dir += Vector2(-1, 0)
		
	
	if Input.is_action_pressed("ui_up"):
		input_dir += Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		input_dir += Vector2(0, 1)
	
	if Input.is_action_just_pressed("shoot"):
		if $bullets.get_child_count() < MAX_BULLETS:
			var bullet = Bullet.instance()
			bullet.position = position
			$bullets.add_child(bullet)
	
	move_and_slide(SPEED*(input_dir.normalized()))
	
func try_pick_up(game_item):
	emit_signal("picked_up_item", game_item)

func take_damage(damage):
	print("oh no, player hit")

func doomify():
	queue_free()