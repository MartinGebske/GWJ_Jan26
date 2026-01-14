extends Control

@onready var prompt_label: Label = $MarginContainer/Control/PromptLabel
@onready var time_label: Label = $MarginContainer/Control/TimeLabel

func _ready() -> void:
	prompt_label.text = ""

func finish_race() -> void:
	prompt_label.text = "FINISH!"
	await get_tree().create_timer(3.0).timeout
	set_countdown_label("")

func set_countdown_label(t: String) -> void:
	prompt_label.text = t

func set_laptime_label(t: String) -> void:
	time_label.text = t
