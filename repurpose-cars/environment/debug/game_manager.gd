extends Node3D
class_name GameManager

@export var player: VehicleBody3D

var is_racing := false
var lap_time := 0.0

func _ready() -> void:
	freeze_player()

func freeze_player() -> void:
	print("freeze!")
	player.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	player.freeze = true

func start_ride() -> void:
	player.freeze = false
	is_racing = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("go"):
		start_ride()
