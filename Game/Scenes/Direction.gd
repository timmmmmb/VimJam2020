extends Area2D


var can_grab = false
var grabbed_offset = Vector2()
var is_grabbed = false
onready var last_position = position
onready var tilemap_size

func _ready():
	var tilemap = $"../TileMap"
	tilemap_size = tilemap.get_used_rect() 
	tilemap_size.end *= tilemap.cell_size

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset
		is_grabbed = true
	elif Input.is_action_just_released("click") && is_grabbed:
		is_grabbed = false
		position = position.snapped(Vector2.ONE * 32)
		position -= Vector2.ONE * 32/2
		if !tilemap_size.has_point(position):
			position = last_position
		last_position = position
		
