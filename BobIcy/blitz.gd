extends CharacterBody2D
## Blitz in Bandit Brawl: move with the arrows or WASD, throw a berry with Space.

const KNIFE := preload("res://PNG/Building/Cartoon_Medieval_Training Arena_Level_Set_Building - Decor Weapon 03.png")

@export var speed: float = 260.0

var facing: Vector2 = Vector2.RIGHT

@onready var health: HealthComponent = $HealthComponent

func _ready() -> void:
	health.changed.connect(_on_health_changed)

func _on_health_changed(current: int) -> void:
	print("Blitz health: ", current)
	
func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		facing = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("throw"):
		_throw()

func _throw() -> void:
	var knife = KNIFE.instantiate()
	knife.direction = facing
	knife.global_position = global_position + facing * 24.0
	add_sibling(knife)
