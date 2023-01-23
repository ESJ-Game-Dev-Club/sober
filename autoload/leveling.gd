extends Node


signal level_up(new_level)
var level: int = 0
var experience: int = 0
var experience_total: int = 0
var experience_required: int = 1

onready var hivemind: Hivemind = get_node("/root/Main/Hivemind")

var max_rabbits: int = 0


func get_required_experience():
	return round((level + 1) * 0.5 + pow(level + 1, 1.1) - 1)

# ax+x^b+c
func calculate(linear: float, exponent: float, offset: float):
	return round(level * linear + pow(level, exponent) + offset)

func add_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()

func level_up():
	$LevelUpSound.play()
	
	level += 1
	experience_required = get_required_experience()
	
	# recalculate
	if level >= 1:
		max_rabbits = calculate(0.7, 0.5, 30)
	
	emit_signal("level_up", level)

