extends VehicleBody3D

@export var max_steering_angle := 0.9
@export var steering_speed := 10
@export var engine_power := 300
@export var brake_power := 1000
@export var max_speed := 20.0

@onready var wheelholder: Node3D = $SteeringwheelBase/Wheelholder

func _physics_process(delta: float) -> void:
	is_on_road()
	if Input.is_action_just_pressed("reset_car"):
		reset_to_road()
	steering = move_toward(
		steering,
		Input.get_axis("right", "left") * max_steering_angle,
		delta * steering_speed
	)
	wheelholder.rotation_degrees.y = steering * 80.0

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

# MANAGE CAR ON ROAD

func is_on_road() -> bool:
	var space = get_world_3d().direct_space_state

	var from = global_transform.origin + Vector3.UP * 2.0
	var to   = global_transform.origin + Vector3.DOWN * 20.0

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 2   # Layer 2
	var result = space.intersect_ray(query)

	var hit = result.size() > 0
	print("on road: ", hit, " and is upside down: ", is_upside_down())
	return hit

func is_upside_down() -> bool:
	return transform.basis.y.dot(Vector3.UP) < 0.3

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
