extends Node3D

@export var car : VehicleBody3D

@onready var start_track_1: Node3D = $StartTrack_1
@onready var start_track_2: Node3D = $StartTrack_2
@onready var start_track_3: Node3D = $StartTrack_3
@onready var start_track_4: Node3D = $StartTrack_4

@onready var anim_player: AnimationPlayer = car.get_node("AnimationPlayer")
@onready var game_manager: GameManager = get_node("/root/main/GameManager")

func _unhandled_input(event: InputEvent) -> void:
	if not game_manager.is_racing:
		if event.is_action_pressed("start1"):
			car.global_transform = start_track_1.global_transform
			initialize(0)
		if event.is_action_pressed("start2"):
			car.global_transform = start_track_2.global_transform
			initialize(1)
		if event.is_action_pressed("start3"):
			car.global_transform = start_track_3.global_transform
			initialize(2)
		if event.is_action_pressed("start4"):
			car.global_transform = start_track_4.global_transform
			initialize(3)


func initialize(track: int) -> void:
		game_manager.current_track = track
		game_manager.start_new_game()

		anim_player.seek(0.0, true)
		anim_player.play("turntable")

func freeze_car() -> void:
	car.linear_velocity = Vector3.ZERO
	car.angular_velocity = Vector3.ZERO
