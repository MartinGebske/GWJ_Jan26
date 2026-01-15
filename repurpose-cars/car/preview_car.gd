extends VehicleBody3D

@export var wheel_scenes : Array[PackedScene]

@onready var game_manager: GameManager = get_node("/root/main/GameManager")
var config: CarConfig

func _ready():
	config = game_manager.active_car_config
	apply_config()
	apply_wheels()
	config.config_changed.connect(_on_config_changed)

func _on_config_changed():
	apply_config()
	apply_wheels()

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

func apply_wheels():
	var wheel_nodes = {
		"Wheel_FR": get_node("wheel_FR"),
		"Wheel_FL": get_node("wheel_FL"),
		"Wheel_RR": get_node("wheel_RR"),
		"Wheel_RL": get_node("wheel_RL")
	}

	# Alte Children löschen
	for wn in wheel_nodes.values():
		for c in wn.get_children():
			c.queue_free()

	# Richtige PackedScene wählen
	var index = int(config.wheel_type) # TYPE1 = 0, TYPE2 = 1, TYPE3 = 2
	var wheel_scene = wheel_scenes[index]

	# Neue Wheel Instances an die Nodes parenten
	for name in wheel_nodes.keys():
		var wn = wheel_nodes[name]
		var instance = wheel_scene.instantiate()
		wn.add_child(instance)

		# Links drehen
		if name.ends_with("_FR") or name.ends_with("_RR"):
			var rot = instance.rotation_degrees
			rot.y = 180
			instance.rotation_degrees = rot
