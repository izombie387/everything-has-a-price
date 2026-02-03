extends Node2D

func _draw() -> void:
	pass


func _physics_process(delta: float) -> void:
	var this = self
	this.velocity.x += 5
	this.move_and_slide()
