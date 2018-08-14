extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var color_array = [Color(1,0,0), Color(0,1,0), Color(0,0,1)]
onready var scale_array = [$RichTextLabel.rect_scale, 1.5*$RichTextLabel.rect_scale]
var color_index = 0
var scale_index = 0

func _ready():
	$RichTextLabel.rect_pivot_offset = $RichTextLabel.rect_size/2
	reactivate_font_tween()
	
func reactivate_font_tween():
	$FontTween.stop_all()
	$FontTween.interpolate_property($RichTextLabel, "rect_scale", 
									scale_array[scale_index%len(scale_array)], scale_array[(scale_index+1)%len(scale_array)],
									1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$FontTween.interpolate_property($RichTextLabel, "custom_colors/default_color", 
									color_array[color_index%len(color_array)], color_array[(color_index+1)%len(color_array)],
									1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$FontTween.start()
	
func _on_FontTween_tween_completed(object, key):
	color_index += 1
	scale_index += 1
	reactivate_font_tween()

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _on_Button_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_ButtonMinusTutorial_pressed():
	get_tree().change_scene("res://MainMinusTutorial.tscn")
