extends Node

@export var initial_state : NodePath
@onready var current_state : Node = get_node(initial_state)

func _ready():
	# Give every state a reference to the Player
	for child in get_children():
		child.player = owner
	current_state.enter()

func _physics_process(delta):
	var next_state_path = current_state.update(delta)
	if next_state_path:
		transition_to(next_state_path)
		

func transition_to(next_state_path: String):
	current_state.exit()
	current_state = get_node(next_state_path)
	current_state.enter()
