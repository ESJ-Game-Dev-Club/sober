extends KinematicBody2D


var current_state: int = State.NORMAL
enum State {
	NORMAL,
	ATTACK,
}

var velocity := Vector2.ZERO
var max_speed := 275
var acceleration := 50


func _physics_process(_delta):
	match current_state:
		State.NORMAL:
			normal()
		State.ATTACK:
			attack()

func normal():
	move()
	$AnimationPlayer.play("idle")
	
	if Input.is_action_just_pressed("attack"):
		start_attack()
		current_state = State.ATTACK

func start_attack():
	$AnimationPlayer.play("attack")

func attack():
	move()

func do_damage():
	var hits = $AttackBox.get_overlapping_areas()
	if hits:
		for hit in hits:
			hit.owner.damage(self, 2, $AttackBox/AttackOrigin.global_position.direction_to(hit.owner.position) * 400)


func transition_to(new_state: int):
	current_state = new_state

func move():
	var goal = get_input().normalized() * max_speed # the desired direction
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
		$AttackBox/CollisionShape2D.position.x = -abs($AttackBox/CollisionShape2D.position.x)
	else: # to the right
		$AttackBox/CollisionShape2D.position.x = abs($AttackBox/CollisionShape2D.position.x)

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
	
	return input
