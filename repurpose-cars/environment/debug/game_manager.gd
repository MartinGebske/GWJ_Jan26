extends Node3D
class_name GameManager

@export var player: VehicleBody3D



func _ready() -> void:
	freeze_player()

func freeze_player() -> void:
	print("freeze!")
	player.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	player.freeze = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("go"):
		player.freeze = false
