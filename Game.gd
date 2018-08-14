extends Node2D



# enemy types go here
var StaticEnemy = preload("res://Enemy.tscn")
var DummyEnemy = preload("res://DummyEnemy.tscn")
var MovingEnemy = preload("res://MovingEnemy.tscn")
var RedEnemy = preload("res://RedEnemy.tscn")
var BlueEnemy = preload("res://BlueEnemy.tscn")
var GreenEnemy = preload("res://GreenEnemy.tscn")
var ChameleonBoss = preload("res://ChameleonBoss.tscn")

var GameItem = preload("res://GameItem.tscn")
var TutorialTrigger = preload("res://TutorialTrigger.tscn")
var Wall = preload("res://Wall.tscn")

var left_wall = 0
var right_wall = 0

var slowed = false

export (float) var catchup_margin = 400

export (float) var wave_height = 400
export (float) var rest_height = 200

export (bool) var play_tutorial = true

var empty_wave = {'enemies': [],
				  'has_wall': false}
var tutorial_wave = {'enemies': [],
					 'has_wall': false,
					 'tutorial_text': ['Oh no!',
					                   'Our spaceship is being chased by',
									   'ENCROACHING DOOM!',
									   'Quick, proceed forward!']
					}
					
var tutorial_wave2 = {'enemies': [[DummyEnemy, Vector2(0, 100), 0.0]],
					  'has_wall': true,
					  'tutorial_text': ['It\'s an enemy!',
										'The wall won\'t open until you kill it.']}

onready var tutorial_wave3 = {'enemies': [],
					  'has_wall': false,
					  'items': [[$ItemGenerator.tutorial_item(), Vector2(0, 200)]],
					  'tutorial_text': ['It\'s an item! Go get it!',
										'Pick it up then use your mouse',
										'to drag it into your inventory.',
										'Items in your inventory give you bonus attack damage.',
										'The number on the item tells you how much.']
					  }

var tutorial_wave4 = {'enemies': [[StaticEnemy, Vector2(0, 100), 0.0]],
				     'has_wall': true,
				     'tutorial_text': ['Enemies can also shoot you!',
									   'If you get hit, you will be temporarily stunned!'],
					 'level': 3}

onready var tutorial_wave5 = {'enemies': [[StaticEnemy, Vector2(40, 100), 1.0, $ItemGenerator.tutorial_item2()], [StaticEnemy, Vector2(-40, 100), 0.0]],
				     'has_wall': true,
				     'tutorial_text': ['Enemies can drop items too!',
									   'Get that item and drag it to your inventory!'],
					 'level': 3}

onready var tutorial_wave6 = {'enemies': [],
							  'has_wall': false,
							  'items': [[$ItemGenerator.tutorial_item2b(), Vector2(0, 100)]],
							  'tutorial_text': ['Whenever two squares of the same color touch in your inventory,',
									 		    'you get a 25% damage bonus to enemies of that color.',
												'you get a 25% damage bonus to enemies of that color.',
											    'Try rearranging your inventory so the 4 red squares are next to each other!',
												'Try rearranging your inventory so the 4 red squares are next to each other!']
					}

onready var tutorial_wave7 = {'enemies': [],
							  'has_wall': false,
							  'items': [[$ItemGenerator.tutorial_item3(), Vector2(0, 200)]],
							  'tutorial_text': ['Ooh another item!']
							  }

var tutorial_wave8 = {'enemies': [],
					 'has_wall': false,
					 'tutorial_text': ['Oh no this item is too large!',
									   'Right-click items to delete them.',
									   'Try not to run out of space!']
					}

var tutorial_wave9 = {'enemies': [],
					 'has_wall': false,
					 'end_tutorial': true,
					 'tutorial_text': ['The real game begins here.',
									   'Good luck!']
					}

var wave1 = {'enemies': [[StaticEnemy, Vector2(0, 100), 0.2], [StaticEnemy, Vector2(-80, 100), 0.2], [StaticEnemy, Vector2(80, 100), 0.2]],
			 'has_wall': true}
var wave2 = {'enemies': [[MovingEnemy, Vector2(0, 100), 0.6]],
			 'has_wall': true}
var rainbow_wave = {'enemies': [[GreenEnemy, Vector2(0, 100), 0.25], [RedEnemy, Vector2(-80, 100), 0.25], [BlueEnemy, Vector2(80, 100), 0.25]],
					'has_wall': true}

var boss_wave = {'enemies': [[ChameleonBoss, Vector2(-180, 50), 1.0]],
				 'has_wall': true,
				 'slow_doom': true,
				 'tutorial_text': ['Oh no, a boss!']}

var end_wave = {'enemies': [],
				'has_wall': false,
				'end_game': true,
				'tutorial_text': ['You won!']}

var starting_wave =  {'enemies': [[DummyEnemy, Vector2(0, 100), 1.0]],
					  'has_wall': true,
					  'level': 1}

func _ready():
	left_wall = $Floor.position.x - $Floor.region_rect.end.x/2
	right_wall = $Floor.position.x + $Floor.region_rect.end.x/2
	
	randomize()
	
	$Music.play()
	
	var tutorial_waves = [tutorial_wave,
						 empty_wave,
						 tutorial_wave2,
						 tutorial_wave3,
						 empty_wave,
						 empty_wave,
						 tutorial_wave4,
						 empty_wave,
						 tutorial_wave5,
						 tutorial_wave6,
						 empty_wave,
						 empty_wave,
						 tutorial_wave7,
						 tutorial_wave8,
						 empty_wave,
						 empty_wave,
						 tutorial_wave9]
	
	var game_waves = [empty_wave,
					  starting_wave,
					  end_wave,
					  gen_easy_wave(1),
				 	  gen_easy_wave(1),
				 	  gen_easy_wave(2),
				 	  gen_easy_wave(3),
				 	  gen_easy_wave(3),
				      gen_easy_wave(4),
				      gen_medium_wave(7),
				      gen_medium_wave(9),
				      gen_medium_wave(9),
				 	  gen_medium_wave(11),
					  gen_colored_wave(13, 0),
					  gen_colored_wave(13, 1),
					  gen_colored_wave(13, 2),
					  gen_rainbow_wave(15),
				 	  gen_boss_wave(20),
					  end_wave]
				
		
	var waves
	if play_tutorial:
		waves = tutorial_waves + game_waves
	else:
		waves = game_waves
	var num_waves = len(waves)
	
	# initialize waves
	for wave_ind in range(num_waves):
		# generate random wave
		var wave = waves[wave_ind]
			
		var displacement = Vector2(0, -(wave_ind + 1)*wave_height - wave_ind*rest_height)
		
		var wall = null
		if wave['has_wall']:
			wall = Wall.instance()
			wall.position = $Player.position + displacement
			wall.strength = 0
			$Walls.add_child(wall)
			
		
		var level = wave_ind + 1
		if 'level' in wave:
			level = wave['level']
		
		if 'tutorial_text' in wave:
			var tutorial_trigger = TutorialTrigger.instance()
			tutorial_trigger.position = $Player.position + displacement + Vector2(0, wave_height)
			tutorial_trigger.lines = wave['tutorial_text']
			if 'end_game' in wave:
				tutorial_trigger.end_game = true
			if 'end_tutorial' in wave and wave['end_tutorial']:
				tutorial_trigger.destroy_items = true
			if 'slow_doom' in wave:
				tutorial_trigger.slow_doom = true
			$TutorialTriggers.add_child(tutorial_trigger)
		
		if 'items' in wave:
			for item in wave['items']:
				var new_item = GameItem.instance()
				new_item.item = item[0]
				new_item.position = $Player.position + item[1] + displacement
				$Items.add_child(new_item)
		
		for spawn in wave['enemies']:
			var enemy_position = $Player.position + displacement + spawn[1]
			var enemy_item = null
			if len(spawn) >= 4:
				enemy_item = spawn[3]
			var enemy = _create_enemy(spawn[0], enemy_position, level, spawn[2], enemy_item)
			enemy.connect("death", self, "_enemy_death")
			if wall:
				enemy.connect("death_by_player", wall, "weaken_wall")
				wall.strength += 1

func gen_boss_wave(level):
	var wave = boss_wave.duplicate()
	wave['level'] = level
	return wave

func gen_easy_wave(level):
	var choice = randf()
	var wave
	if choice < 0.6:
		wave = wave1.duplicate()
	else:
		wave = wave2.duplicate()
	
	wave['level'] = level
	return wave
	
func gen_medium_wave(level):
	var choice = randf()
	var wave
	if choice < 0.2:
		wave = wave1.duplicate()
	elif choice < 0.4:
		wave = wave2.duplicate()
	elif choice < 0.7:
		wave = random_colored_wave()
	else:
		wave = rainbow_wave.duplicate()
	
	wave['level'] = level
	return wave
	
func gen_colored_wave(level, color_ind):
	var wave = colored_wave(color_ind)
	wave['level'] = level
	return wave

func gen_rainbow_wave(level):
	var wave = rainbow_wave.duplicate()
	wave['level'] = level
	return wave

func random_colored_wave():
	return colored_wave(randi()%3)

func colored_wave(color_ind):
	var coloredEnemies = [RedEnemy, BlueEnemy, GreenEnemy]
	var enemyType = coloredEnemies[color_ind]
	return {'enemies': [[enemyType, Vector2(0, 100), 0.25], [enemyType, Vector2(-80, 100), 0.25], [enemyType, Vector2(80, 100), 0.25]],
			'has_wall': true}
			
func _create_enemy(enemy_type, enemy_position, level, prob, item_to_drop):
	var enemy = enemy_type.instance()
	enemy.position = enemy_position
	enemy.connect("dropped_item", self, "_enemy_dropped_item", [enemy])
	
	if enemy.has_method("set_level"):
		enemy.set_level(level)
	
	if randf() <= prob:
		enemy.item_to_drop = $ItemGenerator.random_item(level)
	if item_to_drop != null:
		enemy.item_to_drop = item_to_drop
	
	$Enemies.add_child(enemy)
	return enemy

func _process(delta):
	$Player.position.x = clamp($Player.position.x, left_wall, right_wall)
	
	if slowed:
		$EncroachingDoom.speed = $EncroachingDoom.slow_speed
	else:
		if $Player.position.y < $EncroachingDoom.position.y - catchup_margin:
			$EncroachingDoom.speed = $EncroachingDoom.catchup_speed
		else:
			$EncroachingDoom.speed = $EncroachingDoom.normal_speed

func slow_doom():
	print("slowing the doom!")
	slowed = true

func _enemy_dropped_item(enemy):
	if enemy.item_to_drop != null:
		var new_item = GameItem.instance()
		new_item.item = enemy.item_to_drop
		new_item.position = enemy.position
		add_child(new_item)

func _enemy_death():
	$EnemyDeathSound.play()
	
