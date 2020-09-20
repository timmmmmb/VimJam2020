extends Area2D

onready var tween = $Tween
signal finished
signal lost

export var speed = 2
var tile_size = 32
var tilemap_size
onready var initial_rotation = rotation
onready var inital_position = position

func start():
	raise()
	rotation = initial_rotation
	position = inital_position
	var tilemap = $"../TileMap"
	tilemap_size = tilemap.get_used_rect() 
	tilemap_size.end *= tilemap.cell_size
	visible = true
	tween.stop_all()
	move()

func move():
	for body in get_overlapping_areas():
		if body.is_in_group("Direction"):
			rotation = body.rotation
		elif body.is_in_group("Cloud"):
			visible = false
			stop()
			return
	var new_position = position + Vector2.UP.rotated(rotation) * tile_size
	if !tilemap_size.has_point(new_position):
		rotation += PI
		new_position = position + Vector2.UP.rotated(rotation) * tile_size
	tween.interpolate_property(self, "position",
		position, new_position,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func stop():
	tween.stop_all()

func _on_Tween_tween_completed(object, key):
	if $"..".current_state != $"..".RUNNING:
		return
	move()
