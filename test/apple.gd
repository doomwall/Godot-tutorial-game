extends Area2D

class_name Item

var healing = 20
var spawn_chance = 6

func pickUp(player):
	player.apply_healing(healing)
	queue_free()

func _on_body_entered(body):
	if body is PlayerCharacter:
		pickUp(body)
