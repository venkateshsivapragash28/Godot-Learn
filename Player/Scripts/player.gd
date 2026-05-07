class_name Player extends CharacterBody2D

@onready var anim = $PlayerAnimation
@onready var sprite = $PlayerSprite2D
@onready var state_machine = $PlayerFSM

var move_speed : float = 200.0 # 500 is very fast for pixel art!
	
var last_direction : String = "down"

func update_animation(dir):
	var anim_to_play = ""
	
	if dir == Vector2.ZERO:
		anim_to_play = "idle_" + last_direction
	else:
		# Vertical Priority
		if abs(dir.y) > abs(dir.x):
			if dir.y > 0:
				last_direction = "down"
				anim_to_play = "walk_down"
			else:
				last_direction = "up"
				anim_to_play = "walk_up"
		# Horizontal Priority
		else:
			last_direction = "side"
			anim_to_play = "walk_side"
			if sprite:
				sprite.flip_h = (dir.x < 0)

	# Only play if changed
	var anim_player = get_node_or_null("PlayerAnimation")
	if anim_player and anim_player.current_animation != anim_to_play:
		anim_player.play(anim_to_play)
