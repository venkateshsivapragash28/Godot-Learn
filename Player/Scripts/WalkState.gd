extends State

func update(_delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		return "Idle"
	
	player.velocity = input_dir * player.move_speed
	player.move_and_slide()
	player.update_animation(input_dir)
	return ""
