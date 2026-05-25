extends PathFollow2D

signal base_damaged(damage)

var speed = 500
var hp = 50
var base_damage = 20

@onready var health_bar: TextureProgressBar = $"HealthBar"
@onready var impact_area: Marker2D = $"Impact"
@onready var projectile_impact = preload("res://scenes/support_scenes/projectile_impact.tscn")

func _ready() -> void:
	health_bar.max_value = hp;
	health_bar.value = hp;
	health_bar.set_as_top_level(true)

func _physics_process(delta: float) -> void:
	move(delta)
	if progress_ratio == 1.0:
		emit_signal("base_damaged", base_damage)
		queue_free()
	
func move(delta: float) -> void: 
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(25, 32)

func on_hit(damage: int):
	hp -= damage
	health_bar.value = hp
	impact()

	if hp <= 0:
		on_destroy()

func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	$"CharacterBody2D".queue_free()
	
	await get_tree().create_timer(.2).timeout
	queue_free()

	
