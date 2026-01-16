extends VehicleBody3D

@export var user_interface = Control

@export var max_steering_angle := 0.9
@export var steering_speed := 10
@export var engine_power := 300
@export var brake_power := 1000
@export var max_speed := 20.0
@export var can_drive := true

@export var start_sound = AudioStream
@export var end_sound = AudioStream
@export var min_pitch := 0.8
@export var max_pitch := 2.2
var engine_running := false

@export var reset_counter := 3.0

@export var wheel_scenes : Array[PackedScene]

@onready var wheelholder: Node3D = $SteeringwheelBase/Wheelholder
@onready var chassis_base: Node3D = $ChassisBase
@onready var engine_sound: AudioStreamPlayer3D = $EngineSound


@onready var game_manager: GameManager = get_node("/root/main/GameManager")

func _ready() -> void:
	can_drive = true

func _physics_process(delta: float) -> void:
	#is_on_road()
	if Input.is_action_just_pressed("reset_car"):
		reset_to_road()
	steering = move_toward(
		steering,
		Input.get_axis("right", "left") * max_steering_angle,
		delta * steering_speed
	)
	wheelholder.rotation_degrees.y = steering * 80.0

	if can_drive:
		var throttle_input = Input.get_axis("backward", "forward")
		var is_braking = Input.is_action_pressed("brake")

		if is_braking:
			brake = brake_power
			engine_force = 0
		else:
			brake = 0
			engine_force = throttle_input * engine_power


	var current_speed = linear_velocity.length()
	if current_speed > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	update_engine_audio()

func get_ready() -> void:
	if not game_manager.player_is_in_goal:
		if game_manager:
			game_manager.run_countdown()
			start_engine()
		else:
			return

func reached_goal() -> void:
	stop_engine()

func update_engine_audio() -> void:
	if not engine_running:
		return

	var speed := linear_velocity.length()
	var t: float = clamp(speed / max_speed, 0.0, 1.0)
	engine_sound.pitch_scale = lerp(min_pitch, max_pitch, t)


func start_engine():
	if engine_running:
		return

	engine_running = true
	var one_shot = AudioManager.play_audio_one_shot(start_sound)
	one_shot.finished.connect(_on_engine_start_finished)


func _on_engine_start_finished():
	engine_sound.play()

func stop_engine():
	if not engine_running:
		return

	engine_running = false
	engine_sound.stop()
	AudioManager.play_audio_one_shot(end_sound)



# MANAGE CAR ON ROAD

func is_on_road() -> bool:
	var space = get_world_3d().direct_space_state

	var from = global_transform.origin + Vector3.UP * 2.0
	var to   = global_transform.origin + Vector3.DOWN * 20.0

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 2   # Layer 2
	var result = space.intersect_ray(query)

	var hit = result.size() > 0
	return hit


func is_upside_down() -> bool:
	return transform.basis.y.dot(Vector3.UP) < 0.3



func start_reset_countdown(time : float) -> void:
	await get_tree().create_timer(time).timeout
	reset_to_road()


func find_nearest_road_pos(max_radius := 40.0, step := 3.0) -> Dictionary:
	var space = get_world_3d().direct_space_state

	for r in range(1, int(max_radius / step)):
		var radius = float(r) * step
		for angle_deg in range(0, 360, 20):
			var angle = deg_to_rad(angle_deg)
			var offset = Vector3(
				cos(angle) * radius,
				0,
				sin(angle) * radius
			)

			var from = global_transform.origin + offset + Vector3.UP * 20
			var to   = global_transform.origin + offset + Vector3.DOWN * 100

			var query = PhysicsRayQueryParameters3D.create(from, to)
			query.collision_mask = 2

			var hit = space.intersect_ray(query)
			if hit:
				return hit  # contains position, normal, collider...

	return {} # nothing found

func reset_to_road():
	var hit = find_nearest_road_pos()
	if hit.is_empty():
		return

	var pos: Vector3 = hit.position
	var normal: Vector3 = hit.normal

	# Adjust Up-Vektor on Road Normal
	var up = normal
	var forward = -global_transform.basis.z

	# Project correct direction of car
	forward = (forward - forward.project(up)).normalized()

	var basis = Basis()
	basis = basis.looking_at(forward, up)

	global_transform = Transform3D(basis, pos + up * 0.5)

	# Reset Physics
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO



# CAR CONFIG

func apply_config(config: CarConfig):
	# Chassis
	for c in chassis_base.get_children():
		c.hide()

	match config.chassis_type:
		CarConfig.ChassisType.BATHTUB:
			chassis_base.get_node("bathtub").show()
		CarConfig.ChassisType.MATTRESS:
			chassis_base.get_node("mattress").show()
		CarConfig.ChassisType.TABLE:
			chassis_base.get_node("table").show()

	# Steering
	for w in wheelholder.get_children():
		w.hide()

	match config.steering_type:
		CarConfig.SteeringType.TOILETPAPER:
			wheelholder.get_node("toiletpaper").show()
		CarConfig.SteeringType.PIZZA:
			wheelholder.get_node("pizza").show()
		CarConfig.SteeringType.LID:
			wheelholder.get_node("lid").show()

func apply_wheels(config: CarConfig):
	var wheel_nodes = {
		"Wheel_FR": get_node("wheel_FR"),
		"Wheel_FL": get_node("wheel_FL"),
		"Wheel_RR": get_node("wheel_RR"),
		"Wheel_RL": get_node("wheel_RL")
	}

	# Alte Children löschen
	for wn in wheel_nodes.values():
		for c in wn.get_children():
			c.queue_free()

	# Richtige PackedScene wählen
	var index = int(config.wheel_type)
	var wheel_scene = wheel_scenes[index]

	# Neue Wheel Instances an die Nodes parenten
	for name in wheel_nodes.keys():
		var wn = wheel_nodes[name]
		var instance = wheel_scene.instantiate()
		wn.add_child(instance)

		# Links drehen
		if name.ends_with("_FR") or name.ends_with("_RR"):
			var rot = instance.rotation_degrees
			rot.y = 180
			instance.rotation_degrees = rot
