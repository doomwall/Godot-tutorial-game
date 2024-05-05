extends CharacterBody2D

class_name Enemy

@onready var skelly_animation = $AnimationPlayer
@onready var skelly = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attack_area = $attack/CollisionShape2D

var preloadedItems := [
	preload("res://apple.tscn")
]

var speed = 50
var player_chase = false
var player = null
var health_points: float = 20
var dead: bool = false
var is_attacking: bool = false
var damage: float = 8.0
var score_value: float = 1
var experience_gain = 3

func itemSpawner():
	var droppedItem = preloadedItems[0]
	var item = droppedItem.instantiate()
	var random_number = randi_range(0, 100)
	print(random_number)
	
	if random_number < item.spawn_chance:
		item.position = skelly.global_position
		get_tree().current_scene.call_deferred("add_child", item)

#Aggro range
func _on_detection_area_body_entered(body):
	if body is PlayerCharacter:
		player = body
		player_chase = true

#enemy damage to himself
func apply_damage(number: float):
	health_points -= number
	print(health_points)
	if health_points <= 0:
		death()
		
	
#death animation + effects
func death():
	dead = true
	itemSpawner()
	speed = 0
	skelly_animation.play("skeleton_death")
	player.apply_score(score_value, experience_gain)
	await get_tree().create_timer(5).timeout
	queue_free()

#player chase
func chase(delta):
	if position[0] > player.position[0]:
		skelly.flip_h = true
		attack_area.position.x = -31.5
		collision.position.x = -6
	else:
		skelly.flip_h = false
		attack_area.position.x = 31.5
		collision.position.x = 4
	
	position += (player.position - position).normalized() * speed * delta
	
	var pos_for_attacking = player.position - position
	if pos_for_attacking[0] < 0:
		pos_for_attacking[0] = pos_for_attacking[0] * -1
	if pos_for_attacking[1] < 0:
		pos_for_attacking[1] = pos_for_attacking[1] * -1
	
	if pos_for_attacking[0] < 50 and pos_for_attacking[1] < 50:
		is_attacking = true
		skelly_animation.play("skeleton_attack")
		await get_tree().create_timer(1).timeout
		is_attacking = false

func _physics_process(delta):
	if player_chase and not dead and not is_attacking:
		skelly_animation.play("skeleton_walk")
		chase(delta)
		move_and_slide()
	elif not dead and not is_attacking:
		skelly_animation.play("skeleton_idle")

func _ready():
	randomize()
