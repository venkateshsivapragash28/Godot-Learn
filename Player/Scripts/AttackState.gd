extends State

@export var attack_sound : AudioStream

func enter():
	# 1. Stop movement (if you want them to stay still)
	if player:
		player.velocity = Vector2.ZERO
		var attack_audio = player.get_node_or_null("Audio/AttackAudio")
		if attack_audio:
			attack_audio.play()
		
		# 2. Show the attack effects based on attack direction
		var attack_direction = player.last_direction
		var attack_fx_node = player.get_node_or_null("Sprite2D/AttackFX")
		
		if attack_fx_node:
			attack_fx_node.visible = true
			# Flip the attack FX if attacking left
			var sprite = player.get_node_or_null("Sprite2D")
			if sprite and attack_direction == "side":
				attack_fx_node.flip_h = sprite.flip_h
			# Play the attack visual effects animation
			var attack_anim = attack_fx_node.get_node_or_null("AttackAnimation")
			if attack_anim:
				# Play animation based on direction
				var effect_anim_name = "attackfx_" + attack_direction
				attack_anim.play(effect_anim_name)
		
		# 3. Play the attack animation based on where they were last facing
		var anim_name = "attack_" + player.last_direction
		var anim_player = player.get_node_or_null("AnimationPlayer")
		if anim_player:
			anim_player.play(anim_name)
			
			# 4. Connect to the animation signal so we know when it's done
			if not anim_player.animation_finished.is_connected(_on_animation_finished):
				anim_player.animation_finished.connect(_on_animation_finished)

func exit():
	# Disconnect the signal and hide attack effects
	if player:
		var anim_player = player.get_node_or_null("AnimationPlayer")
		if anim_player:
			if anim_player.animation_finished.is_connected(_on_animation_finished):
				anim_player.animation_finished.disconnect(_on_animation_finished)
		
		# Hide the attack visual effects
		var attack_fx_node = player.get_node_or_null("Sprite2D/AttackFX")
		if attack_fx_node:
			attack_fx_node.visible = false

func update(_delta):
	# Usually, we return nothing here because we want to wait for the animation
	return ""

func _on_animation_finished(_anim_name: String):
	# When the swing is done, go back to Idle
	if player and player.state_machine:
		player.state_machine.transition_to("Idle")
