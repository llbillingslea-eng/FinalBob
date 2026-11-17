extends Node2D

var map1_scene = preload("res://map_1.tscn")
var map2_scene = preload("res://map_2.tscn")
var map3_scene = preload("res://map_3.tscn")
var map4_scene = preload("res://map_4.tscn")
var bob_scene = preload("res://bob.tscn")

var bob: CharacterBody2D
var next_spawn_y: float = 0.0
const MAP_HEIGHT: float = 648.0

func _ready() -> void:
	var m1 = map1_scene.instantiate()
	add_child(m1)
	
	if m1.has_node("Bob"):
		m1.get_node("Bob").queue_free()
		
	bob = bob_scene.instantiate()
	bob.position = Vector2(576, 500)
	add_child(bob)
	
	spawn_random_map()

func _process(_delta: float) -> void:
	if bob.position.y < next_spawn_y + MAP_HEIGHT:
		spawn_random_map()

func spawn_random_map() -> void:
	next_spawn_y -= MAP_HEIGHT
	
	var selected_scene = [map2_scene, map3_scene,map4_scene].pick_random()
	var new_map = selected_scene.instantiate()
	new_map.position = Vector2(0, next_spawn_y)
	add_child(new_map)
