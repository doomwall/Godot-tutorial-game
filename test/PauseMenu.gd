extends Control

@onready var menu = $Panel

var player = preload("res://player.tscn")

func pause():
	get_tree().paused = true
	menu.visible = true

func unpause():
		menu.visible = false
		get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		if !get_tree().paused:
			pause()
		else:
			unpause()
