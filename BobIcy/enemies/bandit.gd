extends CharacterBody2D
## A Berry Bandit. The brain chases Blitz. Every number it uses lives in its stats file.

@export var stats: EntityStats

@onready var health: HealthComponent = $HealthComponent
@onready var hitbox: HitboxComponent = $HitboxComponent

func _ready() -> void:
	if stats == null:
		stats = EntityStats.new()
	health.setup(stats.max_health)
	hitbox.damage = stats.touch_damage
	$Sprite2D.modulate = stats.tint
	health.changed.connect(_on_health_changed)
	health.died.connect(_on_died)

func _on_health_changed(current: int) -> void:
	print(name, " health: ", current)

func _on_died() -> void:
	queue_free()

func _physics_process(_delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var to_player: Vector2 = player.global_position - global_position
	if to_player.length() < stats.sight_range:
		velocity = to_player.normalized() * stats.speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
