extends Node3D
class_name GameManager

@export var player: VehicleBody3D
@export var user_interface : Control
@export var tracks : Array[Node3D]
@export var track_starting_points : Array[Node3D]

var current_track:
	set(value):
		current_track = value

var is_racing := false
var lap_time := 0.0
var current_time := 0.0
var player_is_in_goal := false

@onready var anim_player: AnimationPlayer = player.get_node("AnimationPlayer")

func _ready() -> void:
	current_track = 0
	start_new_game()

func start_new_game() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	user_interface.set_laptime_label(str("TIme: 00:00:00"))

	print("selected track: ", current_track)
	freeze_player()

	lap_time = 0.0
	player_is_in_goal = false

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
	player.freeze = true


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
	is_racing = false
	player_is_in_goal = true
	lap_time = current_time
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	user_interface.finish_race()

func _unhandled_input(event: InputEvent) -> void:
	if not is_racing:
		if event.is_action_pressed("start1"):
			initialize(0)
		if event.is_action_pressed("start2"):
			initialize(1)
		if event.is_action_pressed("start3"):
			initialize(2)
		if event.is_action_pressed("start4"):
			initialize(3)


func initialize(track: int) -> void:
	current_track = track
	player.global_transform = track_starting_points[track].global_transform
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
