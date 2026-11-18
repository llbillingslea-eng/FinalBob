extends CharacterBody2D
## Blitz in Bandit Brawl: move with the arrows or WASD, throw a berry with Space.

const KNIFE := preload("res://components/knife.tscn")
const SPEED = 400.0
const JUMP_VELOCITY = -1800.0


@export var speed: float = 260.0

var facing: Vector2 = Vector2.RIGHT


@onready var health: HealthComponent = $HealthComponent

func _ready() -> void:
	health.changed.connect(_on_health_changed)

func _on_health_changed(current: int) -> void:
	print("Blitz health: ", current)
	
func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction (-1, 0, or 1) and handle horizontal movement.
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * speed
		facing = Vector2.RIGHT if direction > 0 else Vector2.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

	if Input.is_action_just_pressed("throw"):
		_throw()

func _throw() -> void:
	var knife = KNIFE.instantiate()
	knife.direction = facing
	
	# Set exact degree angles for right and left. Adjust numbers as needed.
	knife.rotation_degrees = 0.0 if facing == Vector2.RIGHT else 180.0
	
	var horizontal_offset := 200.0 if facing == Vector2.RIGHT else 50.0
	var spawn_offset := (facing * horizontal_offset) + Vector2(0, 50.0)
	
	knife.global_position = global_position + spawn_offset
	add_sibling(knife)
