extends State

func enter():
	# 1. Stop movement (if you want them to stay still)
	if player:
		player.velocity = Vector2.ZERO
		
		# 2. Play the animation based on where they were last facing
		var anim_name = "attack_" + player.last_direction
		var anim_player = player.get_node_or_null("AnimationPlayer")
		if anim_player:
			anim_player.play(anim_name)
			
			# 3. Connect to the animation signal so we know when it's done
			if not anim_player.animation_finished.is_connected(_on_animation_finished):
				anim_player.animation_finished.connect(_on_animation_finished)

func exit():
	# Disconnect the signal so it doesn't trigger when we're walking
	if player:
		var anim_player = player.get_node_or_null("AnimationPlayer")
		if anim_player:
			if anim_player.animation_finished.is_connected(_on_animation_finished):
				anim_player.animation_finished.disconnect(_on_animation_finished)

func update(_delta):
	# Usually, we return nothing here because we want to wait for the animation
	return ""

func _on_animation_finished(_anim_name: String):
	# When the swing is done, go back to Idle
	if player and player.state_machine:
		player.state_machine.transition_to("Idle")