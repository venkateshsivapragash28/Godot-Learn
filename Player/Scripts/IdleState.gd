extends State

func enter():
	player.velocity = Vector2.ZERO
	# Hide attack effects when idle
	var attack_fx = player.get_node_or_null("Sprite2D/AttackFX")
	if attack_fx:
		attack_fx.visible = false
	# You'd call your animation logic here
	var anim_player = player.get_node_or_null("AnimationPlayer")
	if anim_player:
		anim_player.play("idle_" + player.last_direction)

func update(_delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir != Vector2.ZERO:
		return "Walk" # Tells StateMachine to switch to the Walk node
	if Input.is_action_just_pressed("attack"):
		return "Attack"
	return ""
