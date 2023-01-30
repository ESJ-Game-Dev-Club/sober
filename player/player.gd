extends KinematicBody2D


var current_state: int = State.NORMAL
enum State {
	NORMAL,
	ATTACK,
	GRAB,
	HOLD,
	THROW,
}

var velocity := Vector2.ZERO
var max_speed := 400
var acceleration := 100
var player_direction = Vector2.RIGHT

var holding: Node2D
var throw_force = 1400
var throw_height = 100


func _physics_process(delta):
	match current_state:
		State.NORMAL:
			normal()
		State.ATTACK:
			attack()
		State.GRAB:
			grab()
		State.HOLD:
			hold(delta)
		State.THROW:
			throw()

func normal():
	move()
	$AnimationPlayer.play("idle")
	
	if Input.is_action_just_pressed("attack"):
		current_state = State.ATTACK
	if Input.is_action_just_pressed("grab"):
		current_state = State.GRAB

func attack():
	$AnimationPlayer.play("attack")
	move()

func do_damage():
	var hits = $AttackBox.get_overlapping_areas()
	if hits:
		for hit in hits:
			hit.owner.damage(self, 2, $AttackOrigin.global_position.direction_to(hit.owner.position) * 400, -400)

func grab():
	$AnimationPlayer.play("grab")
	move()

func do_grab():
	var overlap = $AttackBox.get_overlapping_areas()
	if overlap:
		Global.instructions.grabbed = true # for the tutorial guided
		holding = overlap[0].owner
		holding.held = true
		current_state = State.HOLD

func hold(delta):
	$AnimationPlayer.play("holding")
	move()
	
	# where the shadow goes
	holding.global_position = $HoldOrigin.global_position
	# where the sprite goes
	holding.get_node("SpriteOrigin").position.y = $HoldOrigin/SpriteOrigin.position.y
	
#	var magnitude = (player_direction * throw_force + velocity).length() + throw_height
#	var throw_distance = get_range(holding.gravity, magnitude, asin(throw_height / magnitude), delta)
#	$Node/Target.position = (throw_distance - 100) * player_direction + $HoldOrigin.position + position
	
	if Input.is_action_just_pressed("attack"):
		current_state = State.THROW
	elif Input.is_action_just_pressed("grab"): # let go of enemy
		holding.held = false
		holding.vertical_velocity = 0.0
		current_state = State.NORMAL

#func get_range(gravity, force, angle, delta):
#	return pow(force, 2) * sin(2 * angle) / gravity * delta

func throw():
	$AnimationPlayer.play("throw")
	move()

func do_throw():
	Global.instructions.thrown = true # for the tutorial instructions
	holding.throw(player_direction * throw_force + velocity, -throw_height)
	holding.throw(player_direction * throw_force, -throw_height)
	holding.held = false


func transition_to(new_state: int):
	current_state = new_state

func move():
	var goal = get_input() * max_speed # the desired direction
	var to_goal = goal - velocity # direction from velocity to desired direction
	var accel_speed = min(acceleration, to_goal.length()) # clamp the speed
	var steering = to_goal.normalized() * accel_speed # return the movement
	velocity = move_and_slide(velocity + steering)
	do_flip()

func do_flip():
	var input = get_input()
	if input.x < 0: # to the left
		$Sprite.flip_h = true
	if input.x > 0: # to the right
		$Sprite.flip_h = false
	
	if $Sprite.flip_h: # to the left
		$AttackBox.position.x = -abs($AttackBox.position.x)
		$AttackOrigin.position.x = -abs($AttackOrigin.position.x)
		$HoldOrigin.position.x = -abs($HoldOrigin.position.x)
	else: # to the right
		$AttackBox.position.x = abs($AttackBox.position.x)
		$AttackOrigin.position.x = abs($AttackOrigin.position.x)
		$HoldOrigin.position.x = abs($HoldOrigin.position.x)

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
		player_direction = input.normalized()
	
	return input.normalized()
