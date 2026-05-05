extends State

func enter():
	# 1. Stop movement (if you want them to stay still)
	player.velocity = Vector2.ZERO
	
	# 2. Play the animation based on where they were last facing
	# Assuming your anims are named "attack_up", "attack_down", etc.
	var anim_name = "attack_" + player.last_direction
	player.anim.play(anim_name)
	
	# 3. Connect to the animation signal so we know when it's done
	if not player.anim.animation_finished.is_connected(_on_animation_finished):
		player.anim.animation_finished.connect(_on_animation_finished)

func exit():
	# Disconnect the signal so it doesn't trigger when we're walking
	if player.anim.animation_finished.is_connected(_on_animation_finished):
		player.anim.animation_finished.disconnect(_on_animation_finished)

func update(_delta):
	# Usually, we return nothing here because we want to wait for the animation
	return ""

func _on_animation_finished(_anim_name):
	# When the swing is done, go back to Idle
	player.state_machine.transition_to("Idle")