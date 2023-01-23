class_name Hivemind
extends Node2D


var rabbit := preload("res://enemy/rabbit/rabbit.tscn")

onready var spawn_rect = Rect2($SpawnRect.rect_position, $SpawnRect.rect_size)


func spawn_enemies(type: PackedScene, count: int):
	var spawned = 0
	while spawned < count:
		var spawn_point = point_on_circle(1200) + Global.player.position
		if spawn_rect.has_point(spawn_point):
			spawn_enemy(type, spawn_point)
			spawned += 1

func spawn_enemy(enemy: PackedScene, spawn_position: Vector2):
	var enemy_instance = enemy.instance()
	enemy_instance.position = spawn_position
	add_child(enemy_instance)

func point_on_circle(radius: int):
	var random_radian = randf() * deg2rad(360) # 0 to 2pi radians
	var unit_position = Vector2(sin(random_radian), cos(random_radian))
	var point = unit_position * radius
	return point


func _on_RabbitTimer_timeout():
	if get_tree().get_nodes_in_group("rabbit").size() < Leveling.max_rabbits:
		spawn_enemies(rabbit, 1)

