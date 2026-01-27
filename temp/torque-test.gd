extends RigidBody3D

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		apply_torque(Vector3.RIGHT)
