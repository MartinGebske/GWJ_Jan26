extends Resource
class_name CarConfig

enum ChassisType { BATHTUB, MATTRESS, TABLE }
enum SteeringType { TOILETPAPER, PIZZA, LID }
enum WheelType { LID, PIZZA, TOILETPAPER }

@export var chassis_type: ChassisType = ChassisType.BATHTUB
@export var steering_type: SteeringType = SteeringType.TOILETPAPER
@export var wheel_type: WheelType = WheelType.TOILETPAPER

# Resource-Update Signal
signal config_changed

func emit_update():
	emit_signal("config_changed")
