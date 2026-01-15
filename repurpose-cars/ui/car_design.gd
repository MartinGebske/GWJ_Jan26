extends MarginContainer

@export var car : VehicleBody3D


enum category_selected{
	CHASSIS, WHEELS, STEERING
}

var current_category

var chassis_assebled = false
var wheels_assembled = false
var steering_assembled = false

@onready var game_manager: GameManager = get_node("/root/main/GameManager")

# Container and responsive UI Buttons
@onready var rounds_container: GridContainer = $background/MarginContainer/VBoxContainer/HBoxContainer/Rounds_Container
@onready var chassis_container: GridContainer = $background/MarginContainer/VBoxContainer/HBoxContainer/Chassis_Container
@onready var ready_btn: Button = $background/MarginContainer/VBoxContainer/Ready_Btn

@onready var state_label: Label = $background/MarginContainer/VBoxContainer/State_Label

# Car components
@onready var wheelholder = car.get_node("SteeringwheelBase/Wheelholder")
@onready var chassisbase = car.get_node("ChassisBase")

func _ready() -> void:
	rounds_container.visible = false
	chassis_container.visible = false
	ready_btn.disabled = true
	if chassisbase:
		print("is da")
	else:
		print("is NICHT da")

func check_for_assembly_comlete() -> void:
	if assembly_completed():
		ready_btn.disabled = false
	else:
		return

func assembly_completed() -> bool:
	if chassis_assebled and steering_assembled: # TODO: and wheels_assembled
		return true
	else:
		return false

# Category Buttons:

func _on_chassis_btn_pressed() -> void:
	if rounds_container.visible:
		rounds_container.visible = false
	chassis_container.visible = true
	state_label.text = "Assemble: Chassis"
	current_category = category_selected.CHASSIS

func _on_wheels_btn_pressed() -> void:
	if chassis_container.visible:
		chassis_container.visible = false
	rounds_container.visible = true
	state_label.text = "Assemble: Wheels"
	current_category = category_selected.WHEELS

func _on_steering_btn_pressed() -> void:
	if chassis_container.visible:
		chassis_container.visible = false
	rounds_container.visible = true
	state_label.text = "Assemble: Steering"
	current_category = category_selected.STEERING

# Selection Buttons





# ROUNDS:
func _on_paper_btn_pressed() -> void:
	if current_category == category_selected.STEERING:
		game_manager.active_car_config.steering_type = CarConfig.SteeringType.TOILETPAPER
		game_manager.active_car_config.emit_update()
		steering_assembled = true

	if current_category == category_selected.WHEELS:
		game_manager.active_car_config.wheel_type = CarConfig.WheelType.TOILETPAPER
		game_manager.active_car_config.emit_update()
	check_for_assembly_comlete()

func _on_pizza_btn_pressed() -> void:
	if current_category == category_selected.STEERING:
		game_manager.active_car_config.steering_type = CarConfig.SteeringType.PIZZA
		game_manager.active_car_config.emit_update()
		steering_assembled = true

	if current_category == category_selected.WHEELS:
		game_manager.active_car_config.wheel_type = CarConfig.WheelType.PIZZA
		game_manager.active_car_config.emit_update()
	check_for_assembly_comlete()

func _on_lid_btn_pressed() -> void:
	if current_category == category_selected.STEERING:
		game_manager.active_car_config.steering_type = CarConfig.SteeringType.LID
		game_manager.active_car_config.emit_update()
		steering_assembled = true

	if current_category == category_selected.WHEELS:
		game_manager.active_car_config.wheel_type = CarConfig.WheelType.LID
		game_manager.active_car_config.emit_update()
	check_for_assembly_comlete()




func _on_bathtub_btn_pressed() -> void:
	if current_category == category_selected.CHASSIS:
		game_manager.active_car_config.chassis_type = CarConfig.ChassisType.BATHTUB
		game_manager.active_car_config.emit_update()
		chassis_assebled = true
	check_for_assembly_comlete()


func _on_mattress_btn_pressed() -> void:
	if current_category == category_selected.CHASSIS:
		game_manager.active_car_config.chassis_type = CarConfig.ChassisType.MATTRESS
		game_manager.active_car_config.emit_update()
		chassis_assebled = true
	check_for_assembly_comlete()


func _on_table_btn_pressed() -> void:
	if current_category == category_selected.CHASSIS:
		game_manager.active_car_config.chassis_type = CarConfig.ChassisType.TABLE
		game_manager.active_car_config.emit_update()
		chassis_assebled = true
	check_for_assembly_comlete()


func _on_ready_btn_pressed() -> void:
	self.visible = false
