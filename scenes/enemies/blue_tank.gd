extends PathFollow2D

var speed = 150
var hp = 50

@onready var health_bar: TextureProgressBar = get_node("HealthBar")

func _ready() -> void:
	health_bar.max_value = hp;
	health_bar.value = hp;
	health_bar.set_as_top_level(true)

func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta: float) -> void: 
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(25, 32)

func on_hit(damage: int):
	hp -= damage
	health_bar.value = hp

	if hp <= 0:
		on_destroy()

func on_destroy():
	self.queue_free()

	
