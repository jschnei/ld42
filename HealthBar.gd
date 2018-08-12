extends Control

func _ready():
	pass

func _process(delta):
	pass

func update_bar(cur_val, max_val):
	$HealthFront.rect_size.x = (cur_val/(1.0*max_val)) * $HealthBack.rect_size.x