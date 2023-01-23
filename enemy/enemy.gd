class_name Enemy
extends KinematicBody2D


var held := false # for determining wether the player is holding this node

var dead = false

var velocity := Vector2.ZERO
var vertical_velocity := 0.0

var gravity := 40


# called when damaging
func damage(_attacker: Node2D, _damage: int, _force: Vector2, _vertical_force: float):
	pass

# player calls this, similar to damage
func throw(_force: Vector2, _vertical_force: float):
	pass
