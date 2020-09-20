extends Node2D

enum {
	RUNNING,
	INITIAL,
	LOST,
	WON
}
var current_state = INITIAL
export (Array, NodePath) var eagles = []

func start():
	current_state = RUNNING
	$Pigeon.start()
	for eagle in eagles:
		get_node(eagle).start()
	$Pigeon.raise()

func _on_Pigeon_lost():
	for eagle in eagles:
		get_node(eagle).stop()
	current_state = LOST


func _on_Pigeon_finished():
	for eagle in eagles:
		get_node(eagle).stop()
	current_state = WON


func _on_Reset_pressed():
	get_tree().reload_current_scene()
