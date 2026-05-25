extends Node2D

var enemy_array = []
var is_built: bool = false
var enemy: PathFollow2D
var type: String
var category: String # projectile or missile

var is_ready: bool = true

func _ready() -> void:
	if is_built:
		var collision_shape: CollisionShape2D = self.get_node("Range/CollisionShape2D")
		collision_shape.shape.radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and is_built:
		select_enemy()

		if not $"AnimationPlayer".is_playing():
			turn_to_enemy()
		if is_ready:
			fire()
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

func fire():
	is_ready = false
	
	if (category == "projectile"):
		fire_gun()
	elif (category == "missile"):
		fire_missile()
	
	enemy.on_hit(GameData.tower_data[type]["damage"])
	await get_tree().create_timer(GameData.tower_data[type]["rof"]).timeout
	is_ready = true

func fire_gun():
	(get_node("AnimationPlayer") as AnimationPlayer).play("fire")

func fire_missile():
	pass

func turn_to_enemy():
	get_node("Turret").look_at(enemy.position)

func _on_range_body_entered(body: Node2D) -> void:
	# The body is only the CharacterBody2D,
	# where as we want the full enemy node
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
