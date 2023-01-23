extends ProgressBar


func _physics_process(_delta):
	max_value = Leveling.experience_required
	value = Leveling.experience
	
	$Label.text = "Level: " + String(Leveling.level)
