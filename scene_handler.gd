extends Node

func _ready() -> void:
	get_node("MainMenu/M/VB/StartGame").connect("pressed", on_start_game_pressed)
	get_node("MainMenu/M/VB/Quit").connect("pressed", on_quit_game_pressed)
 
func on_start_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://scenes/main_scenes/game_scene.tscn").instantiate()
	print(game_scene)
	add_child(game_scene)

func on_quit_game_pressed():
	get_tree().quit()
