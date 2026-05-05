extends State

func enter():
	# Hide attack effects when walking
	var attack_fx = player.get_node_or_null("Sprite2D/AttackFX")
	if attack_fx:
		attack_fx.visible = false

func update(_delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		return "Idle"
	if Input.is_action_just_pressed("attack"):
		return "Attack"
	
	player.velocity = input_dir * player.move_speed
	player.move_and_slide()
	player.update_animation(input_dir)
	return ""
