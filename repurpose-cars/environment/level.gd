extends Node3D

@export var car := VehicleBody3D

@onready var start_track_1: Node3D = $StartTrack_1
@onready var start_track_2: Node3D = $StartTrack_2
@onready var start_track_3: Node3D = $StartTrack_3
@onready var start_track_4: Node3D = $StartTrack_4


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("start1"):
		car.global_transform = start_track_1.global_transform
		#freeze_car()
	if event.is_action_pressed("start2"):
		car.global_transform = start_track_2.global_transform
		#freeze_car()
	if event.is_action_pressed("start3"):
		car.global_transform = start_track_3.global_transform
		#freeze_car()
	if event.is_action_pressed("start4"):
		car.global_transform = start_track_4.global_transform
		#1freeze_car()

func freeze_car() -> void:
	car.linear_velocity = Vector3.ZERO
	car.angular_velocity = Vector3.ZERO
