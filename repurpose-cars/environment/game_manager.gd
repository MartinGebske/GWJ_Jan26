extends Node3D
class_name GameManager

@export var player: VehicleBody3D
@export var user_interface : Control
@export var tracks : Array[Node3D]



var current_track:
	set(value):
		current_track = value

var is_racing := false
var lap_time := 0.0
var current_time := 0.0
var player_is_in_goal := false

func start_new_game() -> void:
	print("selected track: ", current_track)
	freeze_player()

	lap_time = 0.0
	current_time = 0.0
	player_is_in_goal = false

	for track in tracks:
		if track:
			track.hide()

	if tracks[current_track]:
		tracks[current_track].show()


func _ready() -> void:
	freeze_player()
	current_track = 0
	start_new_game()

func _physics_process(delta: float) -> void:
	if is_racing:
		current_time += delta
		user_interface.set_laptime_label("Time: " + format_time(current_time))

func freeze_player() -> void:
	player.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	player.freeze = true

func start_ride() -> void:
	player.freeze = false
	is_racing = true
	current_time = 0.0  # Reset Timer
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED   # IS THIS THE CORRECT PLACE?


func player_in_goal() -> void:
	is_racing = false
	player_is_in_goal = true
	lap_time = current_time
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	user_interface.finish_race()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("go"):
		run_countdown()

func run_countdown() -> void:
	for i in [3, 2, 1]:
		user_interface.set_countdown_label(str(i))
		await get_tree().create_timer(1.0).timeout

	user_interface.set_countdown_label("GO!")
	await get_tree().create_timer(0.8).timeout
	user_interface.set_countdown_label("")
	start_ride()

func format_time(seconds: float) -> String:
	var mins = int(seconds) / 60
	var secs = int(seconds) % 60
	var hundredths = int((seconds - int(seconds)) * 100)

	return "%02d:%02d:%02d" % [mins, secs, hundredths]
