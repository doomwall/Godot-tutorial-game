extends CharacterBody2D

class_name PlayerCharacter

@export var speed = 100
var arrow_scene = preload("res://arrow.tscn")

var max_player_hitpoints = 100
var player_hitpoints = 100
var score: int = 0
var dead: bool = false
var experience_needed = 10
var experience_points = 0

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var attackTimer = $AttackTimer
@onready var HPBar = $Control/HitpointsProgress
@onready var EXPBar = $Control/ExperienceProgress
@onready var score_display = $Control/ScoreDisplay

var screen_size_half = ProjectSettings.get_setting("display/window/size/viewport_width") / 2



func movement():
	var input_direction = Input.get_vector("Move_left", "move_right", "move_up", "move_down")
	var mouse_left_button = Input.is_action_just_pressed("attack")
	
	velocity = input_direction * speed

	if(animation.get_current_animation() != "attack") and not dead:
		if input_direction[0] == 0 and input_direction[1] == 0:
			animation.play("idle")
		elif input_direction[0] != 0 or input_direction[1] != 0:
			animation.play("run")
	
	var mouse_pos = get_viewport().get_mouse_position()
	#print(mouse_pos)
	
	if mouse_pos[0] < screen_size_half:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	if mouse_left_button and attackTimer.is_stopped():
		animation.play("attack")
		attack()
		

func attack():
	var mouse_pos = get_global_mouse_position()
	if attackTimer.is_stopped():
		await get_tree().create_timer(0.3).timeout
		if arrow_scene and attackTimer.is_stopped():
			
			var arrow = arrow_scene.instantiate()
			get_parent().add_child(arrow)
			arrow.global_position = sprite.global_position
			arrow.global_position = Vector2(arrow.global_position[0], arrow.global_position[1] - 10) 
			
			var arrow_rotation = sprite.global_position.direction_to(mouse_pos).angle()
			arrow.rotation = arrow_rotation
			
			attackTimer.start()
			
func apply_player_damage(damage):
	player_hitpoints -= damage
	print(player_hitpoints)
	HPBar.value = player_hitpoints
	
func apply_healing(heal):
	player_hitpoints += heal
	if player_hitpoints > max_player_hitpoints:
		player_hitpoints = max_player_hitpoints
	print(player_hitpoints)
	HPBar.value = player_hitpoints
	
func levelUp():
	experience_points = experience_points - experience_needed
	experience_needed = experience_needed * 2
	EXPBar.max_value = experience_needed
	EXPBar.value = experience_points
	
	
func _on_area_2d_area_entered(area):
	var enemy_attack = area.get_parent()
	if enemy_attack is Enemy:
		apply_player_damage(enemy_attack.damage)
		if player_hitpoints <= 0:
			death()
		
func apply_score(score_number, exp_number):
	score += score_number
	experience_points += exp_number
	print(score)
	score_display.text = str(score)
	EXPBar.value = experience_points
	if experience_points >= experience_needed:
		levelUp()
	
func death():
	dead = true
	speed = 0
	animation.play("death")
	await get_tree().create_timer(10).timeout

		
func _physics_process(_delta):
	movement()
	move_and_slide()
