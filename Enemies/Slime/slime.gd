extends CharacterBody2D

@export var move_speed: float = 90.0
@export var attack_range: float = 58.0
@export var attack_damage: int = 1
@export var attack_duration: float = 0.4
@export var attack_cooldown: float = 0.8
@export var hitbox_active_time: float = 0.18
@export var hitbox_side_offset: Vector2 = Vector2(34, 0)
@export var hitbox_down_offset: Vector2 = Vector2(0, 28)
@export var hitbox_up_offset: Vector2 = Vector2(0, -28)

@onready var sprite: Sprite2D = $SlimeSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var direction_range: Area2D = $DirectionRange
@onready var hitbox: Area2D = $HitBox
@onready var hitbox_shape: CollisionShape2D = $HitBox/CollisionShape2D

var target_player: Player
var last_direction: String = "down"
var is_attacking: bool = false
var attack_timer: float = 0.0
var cooldown_timer: float = 0.0
var hitbox_timer: float = 0.0
var damaged_this_attack: bool = false

func _ready():
	direction_range.monitoring = true
	hitbox.monitoring = true
	hitbox_shape.disabled = true
	direction_range.body_entered.connect(_on_direction_range_body_entered)
	direction_range.body_exited.connect(_on_direction_range_body_exited)
	hitbox.area_entered.connect(_on_hitbox_area_entered)

func _physics_process(delta):
	if cooldown_timer > 0.0:
		cooldown_timer -= delta

	if is_attacking:
		_update_attack(delta)
		return

	if not is_instance_valid(target_player):
		target_player = _find_player_in_range()
		if target_player == null:
			velocity = Vector2.ZERO
			move_and_slide()
			_play_animation("idle_" + last_direction)
			return

	var to_player = target_player.global_position - global_position
	_update_direction(to_player)

	if to_player.length() <= attack_range and cooldown_timer <= 0.0:
		_start_attack()
		return

	velocity = to_player.normalized() * move_speed
	move_and_slide()
	_play_animation("walk_" + last_direction)

func _start_attack():
	is_attacking = true
	attack_timer = attack_duration
	hitbox_timer = hitbox_active_time
	cooldown_timer = attack_cooldown
	damaged_this_attack = false
	velocity = Vector2.ZERO
	move_and_slide()
	_position_hitbox()
	hitbox_shape.disabled = false
	_play_animation("attack_" + last_direction)
	_try_damage_overlapping_hurtbox()

func _update_attack(delta):
	velocity = Vector2.ZERO
	move_and_slide()
	attack_timer -= delta
	hitbox_timer -= delta

	if hitbox_timer > 0.0:
		_try_damage_overlapping_hurtbox()
	else:
		hitbox_shape.disabled = true

	if attack_timer <= 0.0:
		is_attacking = false
		hitbox_shape.disabled = true

func _update_direction(direction: Vector2):
	if abs(direction.y) > abs(direction.x):
		if direction.y > 0.0:
			last_direction = "down"
		else:
			last_direction = "up"
	else:
		last_direction = "side"
		sprite.flip_h = direction.x < 0.0

func _position_hitbox():
	if last_direction == "up":
		hitbox.position = hitbox_up_offset
	elif last_direction == "down":
		hitbox.position = hitbox_down_offset
	else:
		hitbox.position = hitbox_side_offset
		if sprite.flip_h:
			hitbox.position.x *= -1.0

func _try_damage_overlapping_hurtbox():
	if damaged_this_attack:
		return

	for area in hitbox.get_overlapping_areas():
		_damage_hurtbox(area)

func _find_player_in_range() -> Player:
	for body in direction_range.get_overlapping_bodies():
		if body is Player:
			return body
	return null

func _damage_hurtbox(area: Area2D):
	if damaged_this_attack or area.name != "PlayerHurtBox":
		return

	var player = area.get_parent()
	if player and player.has_method("take_damage"):
		player.take_damage(attack_damage)
		damaged_this_attack = true

func _play_animation(anim_name: String):
	if anim.current_animation != anim_name:
		anim.play(anim_name)

func _on_direction_range_body_entered(body: Node2D):
	if body is Player:
		target_player = body

func _on_direction_range_body_exited(body: Node2D):
	if body == target_player:
		target_player = null

func _on_hitbox_area_entered(area: Area2D):
	if is_attacking and hitbox_timer > 0.0:
		_damage_hurtbox(area)
