extends Control

@onready var how_to_play_panel: Panel = $"Welcome Screen/MarginContainer/HowToPlayPanel"
@onready var welcome_screen: VBoxContainer = $"Welcome Screen/MarginContainer/WelcomeScreen"

func _ready() -> void:
	how_to_play_panel.visible = false
	welcome_screen.visible = true


func _on_how_btn_pressed() -> void:
	welcome_screen.visible = false
	how_to_play_panel.visible = true


func _on_back_btn_pressed() -> void:
	how_to_play_panel.visible = false
	welcome_screen.visible = true
