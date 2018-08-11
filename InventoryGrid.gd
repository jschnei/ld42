extends Node2D

export (int) var CELL_SIZE
export (int) var HEIGHT
export (int) var WIDTH

var inventory_cell = preload("res://InventoryGridCell.tscn")

var grid_cells = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for i in range(HEIGHT):
		for j in range(WIDTH):
			var new_cell = create_and_add_cell(i, j)
			new_cell.connect("clicked_on", self, "_cell_clicked_on", [i, j])

func create_and_add_cell(x, y):	
	var polygon = [Vector2(CELL_SIZE*x, CELL_SIZE*y),
				   Vector2(CELL_SIZE*x, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y + CELL_SIZE),
				   Vector2(CELL_SIZE*x + CELL_SIZE, CELL_SIZE*y)]
				
	# NOTE: this is just a hack to make grid borders clearer, we should get rid of this
	for i in len(polygon):
		polygon[i] += Vector2(x, y)
		
	var new_cell = inventory_cell.instance()
	new_cell.get_node("Polygon2D").polygon = polygon
	new_cell.get_node("CollisionPolygon2D").polygon = polygon

	add_child(new_cell)
	return new_cell
	
func _cell_clicked_on(i, j):
	print("clicked on ", i, j)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
