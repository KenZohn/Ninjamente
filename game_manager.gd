extends Node

var coins: int = 0
var level = 1
var current_xp: int = 0
var next_level_xp: int = 10

func add_xp(amount: int):
	current_xp += amount
