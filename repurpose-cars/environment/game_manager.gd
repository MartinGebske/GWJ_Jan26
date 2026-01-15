extends Node3D
class_name GameManager

@export var player: VehicleBody3D
@export var user_interface : Control
@export var tracks : Array[Node3D]
@export var track_starting_points : Array[Node3D]
@export var active_car_config: CarConfig
@export var goals : Array[Area3D]

var current_track:
	set(value):
		current_track = value

var is_racing := false
var lap_time := 0.0
var current_time := 0.0
var player_is_in_goal := false

@onready var anim_player: AnimationPlayer = player.get_node("AnimationPlayer")

# Pre-Game Screen stuff
@onready var init_cam: Camera3D = %Init_Cam
@onready var init_canvas: Control = $"../Init_Canvas"

func _ready() -> void:
	freeze_player()
	user_interface.visible = false
	player.visible = false

func start_new_game() -> void:
	player.visible = true
	var config = active_car_config
	player.apply_config(config)
	player.apply_wheels(config)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	user_interface.set_laptime_label(str("TIme: 00:00:00"))

	player.wheelholder.rotation_degrees.y = 0.0
	freeze_player()

	is_racing = false
	lap_time = 0.0
	player_is_in_goal = false

	player.can_drive = true
	player.max_speed = 20.0

	# Disable each track except the active track
	for track in tracks:
		if track:
			track.hide()

	if tracks[current_track]:
		tracks[current_track].show()

	# Reset animation player
	anim_player.seek(0.0, true)

	# Start Animation player. WITHIN the Animation Player start_ride() is getting called
	anim_player.play("turntable")

# Just holds the player in one place
func freeze_player() -> void:
	player.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	player.linear_velocity = Vector3.ZERO
	player.angular_velocity = Vector3.ZERO
	player.freeze = true
	player.reset_physics_interpolation()
	player.can_drive = false

# is used for counting the time
func _physics_process(delta: float) -> void:
	if is_racing:
		current_time += delta
		user_interface.set_laptime_label("Time: " + format_time(current_time))

func start_ride() -> void:
	player.freeze = false
	current_time = 0.0  # Reset Timer
	is_racing = true

func player_in_goal() -> void:
	if player_is_in_goal:
		return
	if not is_racing:
		return
	anim_player.play("turntable")
	freeze_player()
	is_racing = false
	player_is_in_goal = true
	lap_time = current_time
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	user_interface.finish_race()
	user_interface.set_goal_time_label(str(format_time(current_time)))
	set_time()
	var best_time = get_best_time("track_" + str((current_track + 1)))
	if best_time > 0.0:
		user_interface.set_highscore_label(str(format_time(best_time)))

func get_best_time(track_id: String) -> float:
	return BestTimes.get_best_time(track_id)

func set_time() -> void:
	var track_id := "track_" + str(current_track + 1)

	if BestTimes.check_time(track_id, lap_time):
		goals[current_track].play_particles()


# This is the starting setup function for the new race.
func initialize(track: int) -> void:
	current_track = track

	player.freeze = true
	player.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC

	player.linear_velocity = Vector3.ZERO
	player.angular_velocity = Vector3.ZERO

	player.global_transform = track_starting_points[track].global_transform
	player.reset_physics_interpolation()
	start_new_game()


# Countdown display stuff

func run_countdown() -> void:
	for i in [3, 2, 1]:
		user_interface.set_countdown_label(str(i))
		await get_tree().create_timer(1.0).timeout

	user_interface.set_countdown_label("GO!")
	await get_tree().create_timer(0.8).timeout
	user_interface.set_countdown_label("")
	start_ride()

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60.0
	var secs = int(seconds) % 60
	var hundredths = int((seconds - int(seconds)) * 100)

	return "%02d:%02d:%02d" % [mins, secs, hundredths]

func quit_game() -> void:
	get_tree().quit()

func _on_start_game_btn_pressed() -> void:
	init_canvas.visible = false
	init_cam.current = false
	init_cam.visible = false
	user_interface.visible = true
