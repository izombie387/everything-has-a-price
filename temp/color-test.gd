extends Node2D

@onready var te: TextEdit = $te
func _ready() -> void:
	te.call_deferred("set_v_scroll", 99999)
