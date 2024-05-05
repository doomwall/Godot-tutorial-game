extends Node2D

@onready var spawnTimer := $SpawnTimer
var screen_x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
var screen_y = ProjectSettings.get_setting("display/window/size/viewport_height") / 2

var preloadedEnemies := [
	preload("res://skeleton.tscn")
]

var nextSpawntime := 1.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawntime)

func _on_spawn_timer_timeout():
	# Spawn an enemy
	var enemyPreload = preloadedEnemies[0]
	var enemy : Enemy = enemyPreload.instantiate()
	var player_pos = get_parent().get_node("Player/Sprite2D").global_position
	
	var up_or_down = randi_range(1,2)
	var pos_y = 0
	var pos_x = player_pos[0] - screen_x
	
	if up_or_down == 1:
		pos_y = player_pos[1] - screen_y
	else:
		pos_y = player_pos[1] + screen_y
	
	pos_x = randi_range(pos_x, screen_x * 2)
	
	
	enemy.position = Vector2(pos_x, pos_y)
	get_tree().current_scene.add_child(enemy)
	
	
	#Restart the timer
	spawnTimer.start(nextSpawntime)
