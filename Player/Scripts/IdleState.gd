extends State

func enter():
	player.velocity = Vector2.ZERO
	# You'd call your animation logic here
	player.anim.play("idle_" + player.last_direction)

func update(_delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir != Vector2.ZERO:
		return "Walk" # Tells StateMachine to switch to the Walk node
	return ""
