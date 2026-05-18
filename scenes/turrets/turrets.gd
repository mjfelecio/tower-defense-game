extends Node2D

func _physics_process(delta: float) -> void:
	turn_to_enemy()

func turn_to_enemy():
	var enemy_pos = get_global_mouse_position()
	get_node("Turret").look_at(enemy_pos)
