extends VehicleBody3D

@onready var game_manager: GameManager = get_node("/root/main/GameManager")
var config: CarConfig

func _ready():
	config = game_manager.active_car_config
	apply_config()
	config.config_changed.connect(_on_config_changed)

func _on_config_changed():
	apply_config()

func apply_config():
	# Chassis
	for c in get_node("ChassisBase").get_children():
		c.hide()
	match config.chassis_type:
		CarConfig.ChassisType.BATHTUB:
			get_node("ChassisBase/bathtub").show()
		CarConfig.ChassisType.MATTRESS:
			get_node("ChassisBase/mattress").show()
		CarConfig.ChassisType.TABLE:
			get_node("ChassisBase/table").show()

	# Steering
	var wheelholder = get_node("SteeringwheelBase/Wheelholder")
	for w in wheelholder.get_children():
		w.hide()
	match config.steering_type:
		CarConfig.SteeringType.TOILETPAPER:
			wheelholder.get_node("toiletpaper").show()
		CarConfig.SteeringType.PIZZA:
			wheelholder.get_node("pizza").show()
		CarConfig.SteeringType.LID:
			wheelholder.get_node("lid").show()
