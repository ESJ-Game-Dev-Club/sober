extends KinematicBody2D


enum State {
	STILL,
	WANDER,
	DEAD,
}
export(State) var current_state: int = State.WANDER

export var jump_curve: Curve # used for getting the height
var jump_time := 1.0 # where we are
var jump_delta := 2.0 # how fast the jump goes
var in_air := false
var sprite_y = -30 # used for jumping animation
var jump_height := 80

var velocity = Vector2.ZERO
var speed := 300


func damage(_attacker: Node2D, _damage: int, knockback: Vector2):
	$AudioStreamPlayer2D.play()
	velocity += knockback
	current_state = State.DEAD

func _ready():
	if current_state == State.WANDER:
		$JumpTimer.start()

func _physics_process(delta):
	match current_state:
		State.STILL:
			still(delta)
		State.WANDER:
			wander(delta)
		State.DEAD:
			dead(delta)
	
	$RabbitSprite.position.y = -jump_curve.interpolate(jump_time) * jump_height + sprite_y
	jump_time += delta * jump_delta

func still(_delta):
	$AnimationPlayer.play("wander")
	
	velocity = move_and_slide(velocity)
	do_flip()

func wander(_delta):
	$AnimationPlayer.play("wander")
	
	velocity = move_and_slide(velocity)
	do_flip()
	if jump_time >= 1.0 and velocity.length_squared() > 0:
		velocity = Vector2.ZERO
		$JumpTimer.start()

func dead(_delta):
	$AnimationPlayer.play("die")
	
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.05)
	velocity = move_and_slide(velocity)
	do_flip()

func _on_JumpTimer_timeout():
	jump_time = 0.0
	velocity = Vector2.RIGHT.rotated(2 * PI / randf()) * speed

func do_flip():
	var input = velocity
	if input.x < 0: # to the left
		$RabbitSprite.flip_h = true
	if input.x > 0: # to the right
		$RabbitSprite.flip_h = false
