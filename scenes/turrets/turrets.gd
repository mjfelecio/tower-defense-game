extends Node2D

var enemy_array = []
var built = false
var enemy

func _ready() -> void:
	if built:
		var collision_shape: CollisionShape2D = self.get_node("Range/CollisionShape2D")
		# This is stupid
		var normalized_tower_name = self.name.to_snake_case().replace("t_1", "t1");
		collision_shape.shape.radius = 0.5 * GameData.tower_data[normalized_tower_name]["range"]

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn_to_enemy()
	else:
		enemy = null

func select_enemy() -> void:
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)

	# find the frontmost enemy as the one to target
	var max_progress = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_progress)
	enemy = enemy_array[enemy_index]

func turn_to_enemy():
	get_node("Turret").look_at(enemy.position)

func _on_range_body_entered(body: Node2D) -> void:
	# The body is only the CharacterBody2D,
	# where as we want the full enemy node
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
