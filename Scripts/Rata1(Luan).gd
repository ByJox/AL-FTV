extends KinematicBody2D
const Floor = Vector2(0,-1)
const Gravity = 15

export (int, 1, 10) var Health : int = 3

onready var motion : Vector2 = Vector2.ZERO
onready var can_move : bool = true
onready var direction : int = 1
const Speed = 48

func _ready() -> void:
	$AnimationPlayer.play("Caminar")

func _physics_process(_delta) -> void:
	if can_move:
		motion_ctrl()

func motion_ctrl() -> void:
	if direction == 1:
		$Rat1.flip_h = false
	else:
		$Rat1.flip_h = true
	if is_on_wall() or not $Raycast/Ground.is_colliding():
		direction *= -1
		$Raycast.scale.x *= -1
	
	motion.y += Gravity
	motion.x = Speed * direction
	
	motion = move_and_slide(motion, Floor)

func damage_ctrl(damage) -> void:
	if can_move:
		if Health > 0:
			Health -= damage
			$AnimationPlayer.play("Hit")
			print("La vida del enemigo es igual a: "+str(Health))
		else:
			$AnimationPlayer.play("Death")

func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"Hit":
			can_move = false

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Hit":
			if Health > 0:
				can_move = true
				$AnimationPlayer.play("Caminar")
			else:
				$Animation.play("Death")
		"Death":
			queue_free()
