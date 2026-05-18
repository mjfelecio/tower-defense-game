extends CanvasLayer

func set_tower_preview(tower_type, mouse_position) -> void:
	# Cleanup previous previews
	if get_node_or_null("TowerPreview"):
		get_node("TowerPreview").queue_free()
		remove_child(get_node("TowerPreview"))
	
	var drag_tower = load("res://scenes/turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("2bff87b5")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.global_position = mouse_position
	control.set_name("TowerPreview")	
	add_child(control, true)
	move_child(control, 0)

func update_tower_preview(tile_pos: Vector2, color: String) -> void:
	get_node("TowerPreview").global_position = tile_pos
	
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
