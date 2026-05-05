extends Node
class_name State

var player: Player
var state_machine: Node

func enter():
	pass

func exit():
	pass

func update(_delta: float) -> String:
	return "" # Return a string name of the next state to switch
