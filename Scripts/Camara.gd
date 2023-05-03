extends Camera2D

onready var rng = RandomNumberGenerator.new()
onready var player = get_tree().get_nodes_in_group("Hero")[0]

func _process(_delta) -> void:
	if player:
		global_position.x = player.global_position.x

func screen_shake(shake_power) -> void:
	if player:
		var _offset_h = rng.randf_range(-shake_power, shake_power)
		var _offset_v = rng.randf_range(-shake_power, shake_power)
