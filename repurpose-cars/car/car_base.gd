extends VehicleBody3D


@export var max_steering_angle := 0.9
@export var steering_speed := 10
@export var engine_power := 300

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("right", "left") * max_steering_angle, delta * steering_speed)
	engine_force = Input.get_axis("backward","forward") * engine_power

# MORE REALISTIC?
#@export var max_rpm = 450
#@export var max_torque := 300
#@export var turn_speed := 3
#@export var turn_amount := 0.3
#
#
#
#@onready var wheel_fl: VehicleWheel3D = $wheel_FL
#@onready var wheel_rr: VehicleWheel3D = $wheel_RR
#@onready var wheel_rl: VehicleWheel3D = $wheel_RL
#
#
#func _physics_process(delta: float) -> void:
#
	#var direction = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	#var steering_direction = Input.get_action_strength("left") - Input.get_action_strength("right")
#
	#var rpm_left = abs(wheel_rl.get_rpm())
	#var rpm_right = abs(wheel_rr.get_rpm())
	#var rpm = rpm_left + rpm_right / 2.0
#
	#var torque = direction + max_torque * (1.0 - rpm / max_rpm)
#
	#engine_force = torque
#
	#steering = lerp(steering, steering_direction * turn_amount, turn_amount * delta)
#
	#if direction == 0:
		#brake = 2
