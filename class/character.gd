class_name Character
extends CharacterBody2D


@export_node_path("Node2D") var sprite_origin_path # the pivot point of the sprite
@export_node_path("Node2D") var hold_origin_path # where the held character goes
@export_node_path("Node2D") var sprite_height_path # where the sprite of the held character goes
@export_node_path("AnimationPlayer") var directional_player # the animation player that controls direction
@onready var sprite_origin: Node2D = get_node(sprite_origin_path)
@onready var hold_origin: Node2D = get_node(hold_origin_path)
@onready var sprite_height: Node2D = get_node(sprite_height_path)

@export var pickable := false

var vertical_velocity = 0 # self explanatory
var z := 0.0 # distance off the ground
var gravity := 40 # force downwards
var holding: Character = null # node that we are holding
var holder: Character = null # node the is being held

var health := 3 # hitpoints
var direction := Vector2.DOWN # idle pydel


@warning_ignore("unused_parameter")
func take_damage(attacker: Node2D, damage: int, force: Vector2, vertical_force: float):
	health -= damage
	velocity += force
	vertical_velocity += vertical_force

# launch the character
func launch(force: Vector2, vertical_force: float):
	holding.holder = null
	holding.velocity += force
	holding.vertical_velocity += vertical_force
	holding = null

# move the character being held to the correct positions
func holding_position():
	holding.global_position = hold_origin.global
	holding.sprite_origin.position.y = sprite_origin.position.y

# return the string of the direction of which way the character is facing
func direction_string() -> String:
	if direction.x < 0:
		get_node(directional_player).play("left")
		return "_left"
	elif direction.x > 0:
		get_node(directional_player).play("right")
		return "_right"
	elif direction.y > 0:
		get_node(directional_player).play("down")
		return "_down"
	elif direction.y < 0:
		get_node(directional_player).play("up")
		return "_up"
	else:
		get_node(directional_player).play("down")
		return "_down"
