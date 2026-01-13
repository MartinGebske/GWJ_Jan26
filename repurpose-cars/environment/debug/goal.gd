extends Area3D

signal is_in_goal()

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "CarBase":
		print("GOAL!!!")
		body.linear_velocity = body.linear_velocity.move_toward(Vector3.ZERO, 0.5)
		body.angular_velocity = body.angular_velocity.move_toward(Vector3.ZERO, 0.5)
		body.max_speed = 1.0
		body.can_drive = false
		is_in_goal.emit()
