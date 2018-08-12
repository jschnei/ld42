extends Node2D

# enemy types go here
var StaticEnemy = preload("res://Enemy.tscn")
var MovingEnemy = preload("res://MovingEnemy.tscn")

var GameItem = preload("res://GameItem.tscn")

var left_wall = 0
var right_wall = 0

export (float) var catchup_margin = 400
export (int) var num_waves = 10

export (float) var wave_height = 400
export (float) var rest_height = 200

var wave1 = [[StaticEnemy, Vector2(0, 100)], [StaticEnemy, Vector2(-80, 100)], [StaticEnemy, Vector2(80, 100)]]
var wave2 = [[MovingEnemy, Vector2(0, 100)]]

func _ready():
	left_wall = $Floor.position.x - $Floor.region_rect.end.x/2
	right_wall = $Floor.position.x + $Floor.region_rect.end.x/2
	
	# initialize waves
	for wave_ind in range(num_waves):
		# generate random wave
		var wave = []
		var choice = randi() % 2
		if choice == 0:
			wave = wave1
		else:
			wave = wave2
			
		var displacement = Vector2(0, -(wave_ind + 1)*wave_height - wave_ind*rest_height)
		
		for spawn in wave:
			var enemy_position = $Player.position + displacement + spawn[1]
			_create_enemy(spawn[0], enemy_position)

			
func _create_enemy(enemy_type, enemy_position):
	var enemy = enemy_type.instance()
	enemy.position = enemy_position
	enemy.connect("dropped_item", self, "_enemy_dropped_item", [enemy])
	enemy.item_to_drop = $ItemGenerator.random_item()
	$Enemies.add_child(enemy)		

func _process(delta):
	$Player.position.x = clamp($Player.position.x, left_wall, right_wall)
	
	if $Player.position.y < $EncroachingDoom.position.y - catchup_margin:
		$EncroachingDoom.speed = $EncroachingDoom.catchup_speed
	else:
		$EncroachingDoom.speed = $EncroachingDoom.normal_speed

func _enemy_dropped_item(enemy):
	if enemy.item_to_drop != null:
		var new_item = GameItem.instance()
		new_item.item = enemy.item_to_drop
		new_item.position = enemy.position
		add_child(new_item)