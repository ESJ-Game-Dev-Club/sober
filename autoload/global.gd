extends Node


onready var player: KinematicBody2D = get_node("/root/Main/Player")
onready var instructions: Instructions = get_node("/root/Main/CanvasLayer/HUD/Instructions")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Engine.set_target_fps(60)

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
	if event.is_action_pressed("attack"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func freeze_frame(time_scale: float, duration: float):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(time_scale * duration), "timeout")
	Engine.time_scale = 1.0
