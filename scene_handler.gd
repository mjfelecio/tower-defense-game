extends Node

func _ready() -> void:
	load_main_menu()
 
func on_start_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene: GameScene = load("res://scenes/main_scenes/game_scene.tscn").instantiate()
	game_scene.connect("game_finished", unload_game)
	add_child(game_scene)

func on_quit_game_pressed():
	get_tree().quit()

func unload_game(result):
	$"GameScene".queue_free()
	var main_menu = load("res://scenes/ui_scenes/main_menu.tscn").instantiate()
	add_child(main_menu)
	load_main_menu()

func load_main_menu():
	$"MainMenu/M/VB/StartGame".connect("pressed", on_start_game_pressed)
	$"MainMenu/M/VB/Quit".connect("pressed", on_quit_game_pressed)
