extends Area3D

signal is_in_goal()

var body := VehicleBody3D
@onready var game_manager: GameManager = get_node("/root/testTrack/GameManager")

func _ready():
	connect("body_entered", _on_body_entered)



func _on_body_entered(body):
	if body.name == "CarBase":
		body.linear_velocity = body.linear_velocity.move_toward(Vector3.ZERO, 0.5)
		body.angular_velocity = body.angular_velocity.move_toward(Vector3.ZERO, 0.5)
		body.max_speed = 1.0
		body.can_drive = false
		is_in_goal.emit()

		var anim_player = body.get_node("AnimationPlayer")
		anim_player.play("turntable")
		await anim_player.animation_finished

		if game_manager:
			game_manager.freeze_player()
		else:
			print("GameManager nicht gefunden!")
		#body.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
		#body.freeze = true
