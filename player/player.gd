extends Character


enum State {
	NORMAL,
	ATTACK,
	GRAB,
	HOLD,
	THROW,
}
var current_state := State.NORMAL

var max_speed := 300
var acceleration := 50


func _physics_process(delta):
	match current_state:
		State.NORMAL:
			normal()
		State.ATTACK:
			attack()
		State.GRAB:
			grab()
		State.HOLD:
			hold()
		State.THROW:
			throw()

func normal():
	if Input.is_action_just_pressed("attack"):
		current_state = State.ATTACK
		var hits = %AttackBox.get_overlapping_areas()
		if hits:
			for hit in hits:
				hit.owner.damage(self, 2, %AttackOrigin.global_position.direction_to(hit.owner.position) * 400, -400)
		attack()
		return
	elif Input.is_action_just_pressed("grab"):
		current_state = State.GRAB
		grab()
		return
	
	move()
	$AnimationPlayer.play("idle" + direction_string())


func attack():
	move()
#	$AnimationPlayer.play("")

func grab():
	move()
#	$AnimationPlayer.play("grab")

func hold():
	pass

func throw():
	pass


func move():
	var goal = get_input() * max_speed # the desired direction
	var to_goal = goal - velocity # direction from velocity to desired direction
	var accel_speed = min(acceleration, to_goal.length()) # clamp the speed
	var steering = to_goal.normalized() * accel_speed # return the movement
	velocity += steering
	move_and_slide()
#	do_flip()

#func do_flip():
#	var input = get_input()
#	if input.x < 0: # to the left
#		$SpriteOrigin/Sprite2D.flip_h = true
#	if input.x > 0: # to the right
#		$SpriteOrigin/Sprite2D.flip_h = false
#
#	if $SpriteOrigin/Sprite2D.flip_h: # to the left
#		%AttackBox.position.x = -abs(%AttackBox.position.x)
#		%AttackOrigin.position.x = -abs(%AttackOrigin.position.x)
#		%HoldOrigin.position.x = -abs(%HoldOrigin.position.x)
#	else: # to the right
#		%AttackBox.position.x = abs(%AttackBox.position.x)
#		%AttackOrigin.position.x = abs(%AttackOrigin.position.x)
#		%HoldOrigin.position.x = abs(%HoldOrigin.position.x)

func transition_to(new_state: State):
	current_state = new_state

func get_input() -> Vector2: # returns normalized direction input
	var input = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		input.y -= 1
	if Input.is_action_pressed("move_down"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if input:
		direction = input.normalized()
	
	return input.normalized()
