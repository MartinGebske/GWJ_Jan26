extends Control

@onready var prompt_label: Label = $MarginContainer/Control/PromptLabel
@onready var time_label: Label = $MarginContainer/Control/TimeLabel

@onready var goal_container: MarginContainer = $GoalContainer
@onready var level_selection: MarginContainer = $level_selection

@onready var game_manager: GameManager = get_node("/root/main/GameManager")

@onready var highscore_label: Label = $GoalContainer/Panel/MarginContainer/VBoxContainer/highscore_label
@onready var goal_time_label: Label = $GoalContainer/Panel/MarginContainer/VBoxContainer/goal_time_label
@onready var car_design: MarginContainer = $car_design

var current_track

func _ready() -> void:
	set_prompt_label("")
	level_selection.visible = true
	goal_container.visible = false

func set_track(track: int) -> void:
	game_manager.initialize(track)
	level_selection.visible = false

func finish_race() -> void:
	prompt_label.text = "FINISH!"
	await get_tree().create_timer(6.0).timeout
	set_countdown_label("")
	time_label.text = ""
	goal_container.visible = true

func set_prompt_label(t: String) -> void:
	prompt_label.text = t

func set_countdown_label(t: String) -> void:
	prompt_label.text = t

func set_laptime_label(t: String) -> void:
	if not time_label:
		time_label = $MarginContainer/Control/TimeLabel
	time_label.text = t

func set_highscore_label(t: String) -> void:
	if not highscore_label:
		highscore_label = $GoalContainer/Panel/MarginContainer/VBoxContainer/highscore_label
	highscore_label.visible = true
	highscore_label.text = ("Best Time: " + t)

func set_goal_time_label(t: String) -> void:
	if not goal_time_label:
		goal_time_label = $GoalContainer/Panel/MarginContainer/VBoxContainer/goal_time_label
	goal_time_label.text = ("Your Time: " + t)

func _on_btn_track_1_pressed() -> void:
	AudioManager.play_click_audio()
	set_track(0)
	current_track = 0

func _on_btn_track_2_pressed() -> void:
	AudioManager.play_click_audio()
	set_track(1)
	current_track = 1

func _on_btn_track_3_pressed() -> void:
	AudioManager.play_click_audio()
	set_track(2)
	current_track = 2

func _on_btn_track_4_pressed() -> void:
	AudioManager.play_click_audio()
	set_track(3)
	current_track = 3

func _on_try_again_btn_pressed() -> void:
	AudioManager.play_click_audio()
	set_track(current_track)
	goal_container.visible = false

func _on_track_selection_btn_pressed() -> void:
	AudioManager.play_click_audio()
	goal_container.visible = false
	level_selection.visible = true

func _on_change_vehicle_btn_pressed() -> void:
	AudioManager.play_click_audio()
	goal_container.visible = false
	car_design.visible = true
	level_selection.visible = true

func _on_quit_game_btn_pressed() -> void:
	AudioManager.play_click_audio()
	game_manager.quit_game()
