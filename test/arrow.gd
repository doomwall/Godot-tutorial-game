extends Area2D

class_name Projectile

@onready var animation = $AnimationPlayer

var speed = 400
var damage: float = 10.0

func _ready(): 
	body_entered.connect(on_body_entered)

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	animation.play("arrow_fly")
	var direction = Vector2.RIGHT.rotated(rotation)
	position += speed * direction * delta
	
func on_body_entered(body: Node2D) :
	print(body.name)
	if body is Enemy:
		var enemy: Enemy = body as Enemy
		if enemy.health_points > 0:
			enemy.apply_damage(damage)
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
