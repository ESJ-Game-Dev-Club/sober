extends Label


var moved := false
var attacked := false


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
	if moved and attacked and $Timer.is_stopped():
		$Timer.start()

func _on_Timer_timeout():
	queue_free()
