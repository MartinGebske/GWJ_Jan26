extends Control

@onready var prompt_label: Label = $MarginContainer/Control/PromptLabel
@onready var time_label: Label = $MarginContainer/Control/TimeLabel

@onready var level_selection: MarginContainer = $level_selection
@onready var game_manager: GameManager = get_node("/root/main/GameManager")


func _ready() -> void:
	prompt_label.text = ""
	level_selection.visible = true

func set_track(track: int) -> void:
	game_manager.initialize(track)
	level_selection.visible = false


func finish_race() -> void:
	prompt_label.text = "FINISH!"
	await get_tree().create_timer(6.0).timeout
	set_countdown_label("")
	time_label.text = ""
	level_selection.visible = true

func set_countdown_label(t: String) -> void:
	prompt_label.text = t

func set_laptime_label(t: String) -> void:
	if not time_label:
		time_label = $MarginContainer/Control/TimeLabel
	time_label.text = t

func _on_btn_track_1_pressed() -> void:
	set_track(0)

func _on_btn_track_2_pressed() -> void:
	set_track(1)

func _on_btn_track_3_pressed() -> void:
	set_track(2)

func _on_btn_track_4_pressed() -> void:
	set_track(3)
