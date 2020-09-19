extends Area2D


onready var tween = $Tween
signal finished
signal lost

export var speed = 3
var tile_size = 32
var direction = Vector2.RIGHT
var visited_goal = false
var tilemap_size

func start():
	visited_goal = false
	direction = Vector2.RIGHT
	position = $"../Start".position
	var tilemap = $"../TileMap"
	tilemap_size = tilemap.get_used_rect() 
	tilemap_size.end *= tilemap.cell_size
	tween.stop_all()
	move()

func move():
	for body in get_overlapping_areas():
		if body.is_in_group("Direction"):
			rotation = body.rotation
			direction = Vector2.UP.rotated(rotation)
		elif body.is_in_group("Goal"):
			visited_goal = true
		elif body.is_in_group("Start") && visited_goal:
			finish()
			return
	var new_position = position + direction * tile_size
	if !tilemap_size.has_point(new_position):
		lost()
		return
	tween.interpolate_property(self, "position",
		position, new_position,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_completed(object, key):
	move()

func finish():
	emit_signal("finished")
	
func lost():
	emit_signal("lost")
