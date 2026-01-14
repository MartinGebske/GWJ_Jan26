extends Area3D

signal is_in_goal()

var body := VehicleBody3D
@onready var game_manager: GameManager = get_node("/root/main/GameManager")

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "CarBase":
		body.linear_velocity = body.linear_velocity.move_toward(Vector3.ZERO, 0.5)
		body.angular_velocity = body.angular_velocity.move_toward(Vector3.ZERO, 0.5)
		body.max_speed = 1.0
		body.can_drive = false
		is_in_goal.emit()

		if game_manager:
			game_manager.player_in_goal()
		else:
			print("GameManager not found!")

		var anim_player = body.get_node("AnimationPlayer")
		anim_player.play("turntable")
		await anim_player.animation_finished

		if game_manager:
			game_manager.freeze_player()
		else:
			print("GameManager not found!")
