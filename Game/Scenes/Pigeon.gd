extends Area2D


onready var tween = $Tween
signal finished
signal lost

export var speed = 2
var tile_size = 32
var visited_goal = false
var tilemap_size
onready var initial_rotation = rotation

func start():
	raise()
	visited_goal = false
	rotation = initial_rotation
	position = $"../StartPosition".position
	var tilemap = $"../TileMap"
	tilemap_size = tilemap.get_used_rect() 
	tilemap_size.end *= tilemap.cell_size
	tween.stop_all()
	move()

func move():
	for body in get_overlapping_areas():
		if body.is_in_group("Direction"):
			rotation = body.rotation
		elif body.is_in_group("Goal"):
			visited_goal = true
		elif body.is_in_group("Start") && visited_goal:
			finish()
			return
		elif body.is_in_group("Cloud") || body.is_in_group("Eagle"):
			lost()
			return
	var new_position = position + Vector2.UP.rotated(rotation) * tile_size
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
