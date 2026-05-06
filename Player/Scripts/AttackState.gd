extends State

@export var attack_deceleration : float = 150.0
@export var attack_move_speed_multiplier : float = 0.35
@export var attack_fx_down_offset : Vector2 = Vector2(0, 10)
@export var attack_fx_up_offset : Vector2 = Vector2(0, -10)
@export var attack_fx_side_offset : Vector2 = Vector2(10, 0)

func enter():
	if player:
		_play_attack_sound()
		_play_attack_fx()

		var anim_name = "attack_" + player.last_direction
		var anim_player = player.get_node_or_null("AnimationPlayer")
		if anim_player:
			anim_player.play(anim_name)

			if not anim_player.animation_finished.is_connected(_on_animation_finished):
				anim_player.animation_finished.connect(_on_animation_finished)

func exit():
	if player:
		var anim_player = player.get_node_or_null("AnimationPlayer")
		if anim_player:
			if anim_player.animation_finished.is_connected(_on_animation_finished):
				anim_player.animation_finished.disconnect(_on_animation_finished)
		_hide_attack_fx()

func update(_delta):
	if player:
		var input_dir = Input.get_vector("left", "right", "up", "down")
		if input_dir.length() > 1.0:
			input_dir = input_dir.normalized()
		if input_dir == Vector2.ZERO:
			player.velocity = player.velocity.move_toward(Vector2.ZERO, attack_deceleration * _delta)
		else:
			player.velocity = input_dir * player.move_speed * attack_move_speed_multiplier
		player.move_and_slide()
	return ""

func _play_attack_sound():
	var sword_woosh = player.get_node_or_null("Audio/SordWoosh")
	if sword_woosh == null:
		sword_woosh = player.get_node_or_null("Audio/SwordWoosh")
	if sword_woosh == null:
		sword_woosh = player.get_node_or_null("Audio/AttackAudio")
	if sword_woosh:
		sword_woosh.play()

func _play_attack_fx():
	var attack_fx = _get_attack_fx()
	if attack_fx == null:
		return

	var attack_fx_anim_name = "attackfx_" + player.last_direction
	attack_fx.visible = false
	attack_fx.frame = _get_attack_fx_start_frame()
	if player.last_direction == "side" and player.sprite:
		attack_fx.flip_h = player.sprite.flip_h
		attack_fx.position = attack_fx_side_offset
		if player.sprite.flip_h:
			attack_fx.position.x *= -1
	else:
		attack_fx.flip_h = false
		attack_fx.position = _get_attack_fx_offset()

	var attack_fx_anim = attack_fx.get_node_or_null("AttackAnimation")
	if attack_fx_anim:
		attack_fx_anim.stop()
		attack_fx_anim.play(attack_fx_anim_name)
		attack_fx_anim.seek(0.0, true)
	attack_fx.visible = true

func _hide_attack_fx():
	var attack_fx = _get_attack_fx()
	if attack_fx:
		attack_fx.visible = false

func _get_attack_fx():
	var attack_fx = player.get_node_or_null("Sprite2D/AttackSprite")
	if attack_fx == null:
		attack_fx = player.get_node_or_null("Sprite2D/AttackFX")
	return attack_fx

func _get_attack_fx_start_frame() -> int:
	if player.last_direction == "up":
		return 4
	if player.last_direction == "side":
		return 8
	return 0

func _get_attack_fx_offset() -> Vector2:
	if player.last_direction == "up":
		return attack_fx_up_offset
	return attack_fx_down_offset

func _on_animation_finished(_anim_name: String):
	if player and player.state_machine:
		player.state_machine.transition_to("Idle")
