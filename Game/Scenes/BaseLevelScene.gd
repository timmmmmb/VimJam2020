extends Node2D

enum {
	RUNNING,
	INITIAL,
	LOST,
	WON
}
var current_state = INITIAL

func start():
	current_state = RUNNING
	$Pigeon.start()
	for eagle in get_tree().get_nodes_in_group("Eagle"):
		eagle.start()
	$Pigeon.raise()

func _on_Pigeon_lost():
	for eagle in get_tree().get_nodes_in_group("Eagle"):
		eagle.stop()
	current_state = LOST


func _on_Pigeon_finished():
	for eagle in get_tree().get_nodes_in_group("Eagle"):
		eagle.stop()
	current_state = WON


func _on_Reset_pressed():
	get_tree().reload_current_scene()
