extends Node2D


func _ready() -> void:
	Input.action_press("test")
	print([2,3]==[2,3])
	var a = [2,3]
	var b = [2,3]
	print(a==b)
