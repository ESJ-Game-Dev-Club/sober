class_name Instructions
extends Label


# please rethink the tutorial script
var movement_instructions = false
var moved := false
var attacked := false
var throwing_instructions := false
var grabbed := false
var thrown := false
var kill_instructions := false
var bonus_success := false


func _ready():
	Leveling.connect("level_up", self, "_on_level_up")

func _on_level_up(new_level):
	if new_level == 5:
		throwing_instructions = false
		grabbed = false
		thrown = false
		text = "RIGHT CLICK to GRAB, LEFT CLICK to THROW"
		$Timer.stop()
	if new_level == 8:
		kill_instructions = false
		bonus_success = false
		text = "KILL a RABBIT with another RABBIT for a BONUS"
		$Timer.stop()

func _process(_delta):
	if grabbed and thrown and !throwing_instructions:
		throwing_instructions = true
		$Timer.start()
	if bonus_success and !kill_instructions:
		kill_instructions = true
		$Timer.start()

func _input(event):
	if (
			event.is_action_pressed("move_up") or
			event.is_action_pressed("move_down") or
			event.is_action_pressed("move_left") or
			event.is_action_pressed("move_right")
	):
		moved = true
	if event.is_action_pressed("attack"):
		attacked = true
	if moved and attacked and $Timer.is_stopped() and !movement_instructions:
		movement_instructions = true
		$Timer.start()

func _on_Timer_timeout():
	text = ""
