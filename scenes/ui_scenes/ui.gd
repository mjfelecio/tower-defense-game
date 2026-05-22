extends CanvasLayer

func set_tower_preview(tower_type, mouse_position) -> void:
	# Cleanup previous previews
	if get_node_or_null("TowerPreview"):
		get_node("TowerPreview").queue_free()
		remove_child(get_node("TowerPreview"))
	
	var drag_tower = load("res://scenes/turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	# Range overlay
	var range_texture = Sprite2D.new()

	var tower_data = GameData.tower_data[tower_type]["range"]
	var scaling = tower_data / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://assets/ui/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.global_position = mouse_position
	control.set_name("TowerPreview")	
	control.add_child(range_texture, true)
	
	add_child(control, true)
	move_child(control, 0)

func update_tower_preview(tile_pos: Vector2, color: String) -> void:
	get_node("TowerPreview").global_position = tile_pos
	
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)

##
## Game control functions
##
func _on_pause_play_pressed() -> void:
	var game_scene: GameScene = get_parent()
	if game_scene.current_wave == 0:
		game_scene.current_wave += 1
		game_scene.start_next_wave()
		return
	
	if (game_scene.build_mode):
		game_scene.cancel_build_mode()
	
	get_tree().paused = !get_tree().paused


func _on_speed_up_pressed() -> void:
	if Engine.time_scale == 2.0:
		Engine.time_scale = 1.0
	else:
		Engine.time_scale = 2.0
		
	
