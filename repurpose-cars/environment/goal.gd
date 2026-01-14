extends Area3D

signal is_in_goal()

var body := VehicleBody3D
@onready var game_manager: GameManager = get_node("/root/main/GameManager")

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name != "CarBase":
		return

	if game_manager and game_manager.is_racing:
		game_manager.player_in_goal()
