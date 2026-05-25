class_name GameScene
extends Node2D

signal game_finished(result)

const VALID_TILE_COLOR = "ad54ff3c"
const INVALID_TILE_COLOR = "red"

var map_node: Node2D

var build_mode = false
var build_valid = false
var build_location: Vector2
var build_type: String # Should prob be enum later
var build_tile = null;

var current_wave: int = 0
var enemies_in_wave: int = 0

var base_health = 100

func _ready() -> void:
	map_node = get_node("Map1")

	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", initiate_build_mode.bind(i.get_name().to_lower()))


func _process(delta: float) -> void:
	if build_mode:
		update_tower_preview()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()

	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##
## Build functions
##

func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
	 
	build_type = tower_type + "_t1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview() -> void:
	var tower_exclusion_layer: TileMapLayer = map_node.get_node("TowerExclusion")
	
	var mouse_pos = get_global_mouse_position()
	var current_tile: Vector2i = tower_exclusion_layer.local_to_map(mouse_pos)
	var tile_pos: Vector2 = tower_exclusion_layer.map_to_local(current_tile)

	var is_valid_tile = tower_exclusion_layer.get_cell_tile_data(current_tile) == null

	if is_valid_tile:
		get_node("UI").update_tower_preview(tile_pos, VALID_TILE_COLOR)
		build_valid = true
		build_location = tile_pos
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_pos, INVALID_TILE_COLOR)
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		# todo: check if has enough cash before this
		var new_tower: Node2D = load("res://scenes/turrets/" + build_type + ".tscn").instantiate()
		
		new_tower.position = build_location
		new_tower.is_built = true
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]["category"]

		map_node.get_node("Turrets").add_child(new_tower, true)
		(map_node.get_node("TowerExclusion") as TileMapLayer).set_cell(build_tile, 0, Vector2i(1, 0))
		
		## todo: deduct cash and update cash label

func on_base_damaged(damage):
	base_health -= damage
	
	if base_health <= 0:
		emit_signal("game_finished", false)
	else:
		$"UI".update_health_bar(base_health)

##
## Wave functions
##
func start_next_wave() -> void:
	var wave_data = retrieve_wave_data()
	# Delay between waves
	await get_tree().create_timer(0.2).timeout
	spawn_enemies(wave_data)

func retrieve_wave_data() -> Array:
	var wave_data = [["blue_tank", 0.7], ["blue_tank", 0.1], ["blue_tank", 0.7], ["blue_tank", 0.1], ["blue_tank", 0.7], ["blue_tank", 0.7]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data: Array) -> void:
	for i in wave_data:
		var new_enemy = load("res://scenes/enemies/" + i[0] + ".tscn").instantiate()
		map_node.get_node("Path").add_child(new_enemy, true)
		new_enemy.connect("base_damaged", on_base_damaged)
		
		# Delay between each spawns based on specified wave_data
		await get_tree().create_timer(i[1]).timeout
