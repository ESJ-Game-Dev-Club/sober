extends Node


onready var player: KinematicBody2D = get_node("/root/Main/Player")


func _ready():
	Engine.set_target_fps(60)

func _input(event):
	if (event.is_action_pressed("fullscreen")):
		OS.set_window_fullscreen(!OS.window_fullscreen)
