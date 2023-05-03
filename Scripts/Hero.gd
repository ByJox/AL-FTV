extends KinematicBody2D
const Speed = 128
const Floor = Vector2(0,-1)
const Gravity = 15
const jumpHeigth = 350
onready var motion : Vector2 = Vector2.ZERO
var can_move : bool

"""STATE MACHINE"""
var playback : AnimationNodeStateMachinePlayback

func _ready():
	playback = $AnimationTree.get("parameters/playback")
	playback.start("Idle")
	$AnimationTree.active = true
	
func _process(_delta):
	motion_ctrl()
	jump_ctrl()
	attack_ctrl()

func get_axis() -> Vector2:
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("CaminarDer")) - int(Input.is_action_pressed("CaminarIzq"))
	return axis

func motion_ctrl():
	motion.y += Gravity
	if can_move:
		motion.x = get_axis().x * Speed
		if get_axis().x == 0:
			playback.travel("Idle")
		elif get_axis().x == 1:
			playback.travel("Run")
			$Hero.flip_h = false
		elif get_axis().x == -1:
			playback.travel("Run")
			$Hero.flip_h = true
	
	match $Hero.flip_h:
		true:
			$Raycast.scale.x = -1
		false:
			$Raycast.scale.x = 1
	
	motion = move_and_slide(motion,Floor)
	
func jump_ctrl():
	match is_on_floor():
		true:
			can_move = true
			
			if Input.is_action_just_pressed("Saltar"):
				#Sound
				motion.y -= jumpHeigth
		
		false:
			if motion.y < 0:
				playback.travel("Jump")
			else:
				playback.travel("Fall")
			
			if $Raycast/RayWall.is_colliding():
				can_move = false
				var _body = $Raycast/RayWall.get_collider()

func attack_ctrl():
	var body = $Raycast/Hit.get_collider()
	
	if is_on_floor():
		if get_axis().x == 0 and Input.is_action_just_pressed("Atacar"):
			match playback.get_current_node():
				"Idle":
					playback.travel("Attack_1")
					#Sound
				"Attack_1":
					playback.travel("Attack_2")
			if $Raycast/Hit.is_colliding():
				if body.is_in_group("Enemy"):
					body.damage_ctrl()
