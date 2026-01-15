extends PathFollow3D

@export var speed := 5.0
@export var target: Node3D

func _process(delta):
	progress += speed * delta
	if target:
		look_at(target.global_position, Vector3.UP)
