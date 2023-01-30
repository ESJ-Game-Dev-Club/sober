extends Enemy


enum State {
	STILL,
	WANDER,
	ATTACK,
	DEAD,
	AIRBORNE,
}
export(State) var current_state: int = State.WANDER

var speed := 400

var jump_force := -400
var hitbox_cutoff = -50 # if the SpriteOrigin is greater than this number, hits won't register


func damage(_attacker: Node2D, _damage: int, force: Vector2, vertical_force: float):
	vertical_velocity = vertical_force
	velocity += force
	$AudioStreamPlayer2D.play()
	
	if !dead:
		Leveling.add_experience(1)
	
	current_state = State.DEAD

# player calls this, similar to damage
func throw(force: Vector2, vertical_force: float):
	velocity = force
	vertical_velocity = vertical_force
	current_state = State.AIRBORNE

func _ready():
	if current_state == State.WANDER:
		$JumpTimer.start()

func _physics_process(delta):
	# makes it so rabbit won't get hit if too high
	if $SpriteOrigin.position.y < hitbox_cutoff:
		$SpriteOrigin/RabbitSprite/HitBox/CollisionShape2D.disabled = true
		$SpriteOrigin/RabbitSprite/AttackBox/CollisionShape2D.disabled = true
	else:
		$SpriteOrigin/RabbitSprite/HitBox/CollisionShape2D.disabled = false
		$SpriteOrigin/RabbitSprite/AttackBox/CollisionShape2D.disabled = false
	
	if held: # rabbit doesn't do anything when it's being held
		return
	
	# the shadow stays at the origin while the rabbit sprite moves up and down
	vertical_velocity += gravity
	$SpriteOrigin.position.y += vertical_velocity * delta
	$SpriteOrigin.position.y = min(0.0, $SpriteOrigin.position.y)
	
	match current_state:
		State.STILL:
			still()
		State.WANDER:
			wander()
		State.ATTACK:
			attack()
		State.DEAD:
			dead()
		State.AIRBORNE:
			airborne()

func still():
	$AnimationPlayer.play("wander")
	
	velocity = move_and_slide(velocity)
	do_flip()

func wander():
	$AnimationPlayer.play("wander")
	
	velocity = move_and_slide(velocity)
	do_flip()
	if $SpriteOrigin.position.y >= 0.0 and $JumpTimer.is_stopped():
		velocity = Vector2.ZERO
		$JumpTimer.start()
	if Leveling.level >= 10:
		current_state = State.ATTACK

func attack():
	$AnimationPlayer.play("wander")
	
	velocity = move_and_slide(velocity)
	do_flip()
	if $SpriteOrigin.position.y >= 0.0 and $JumpTimer.is_stopped():
		velocity = Vector2.ZERO
		$JumpTimer.start()

func dead():
	if is_in_group("rabbit"):
		remove_from_group("rabbit")
	if is_in_group("enemy"):
		remove_from_group("enemy")
	
	dead = true
	$AnimationPlayer.play("die")
	
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.05)
	velocity = move_and_slide(velocity)
	do_flip()

func airborne():
	velocity = move_and_slide(velocity)
	
	var overlap = $SpriteOrigin/RabbitSprite/AttackBox.get_overlapping_areas()
	# if hit another enemy
	if overlap:
		for area in overlap:
			if not area.owner == self: # ignore self
				if area.owner.dead == false:
					Global.screen_shake(0.3, 0.6)
					Leveling.add_experience(12)
					Global.instructions.bonus_success = true
				area.owner.damage(self, 1, velocity * 0.5, -200) # damage other
				damage(self, 1, -velocity * 1.57, -200)
	
	# hit the ground and die
	if $SpriteOrigin.position.y >= 0.0:
		if !dead:
			Global.screen_shake(0.2, 0.6)
		damage(self, 1, -velocity * 0.5, -400)

func _on_JumpTimer_timeout():
	if current_state == State.WANDER:
		jump()
		velocity = Vector2.RIGHT.rotated(2 * PI * randf()) * speed
	elif current_state == State.ATTACK:
		jump()
		velocity = position.direction_to(Global.player.position).rotated(PI * (randf() - 0.5)) * speed

func jump():
	vertical_velocity = jump_force

func do_flip():
	var input = velocity
	if input.x < 0: # to the left
		$SpriteOrigin/RabbitSprite.flip_h = true
	if input.x > 0: # to the right
		$SpriteOrigin/RabbitSprite.flip_h = false
