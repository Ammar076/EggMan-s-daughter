extends Node

var score = 0
@onready var player = %Character


func add_point():
	player.display_coins()
