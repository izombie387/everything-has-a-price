@tool
extends Control

@onready var ranks: HBoxContainer = $Ranks
@onready var back: VBoxContainer = $Ranks/Back
@onready var middle: VBoxContainer = $Ranks/Middle
@onready var front: VBoxContainer = $Ranks/Front


@export var flipped: = false:
	set(v):
		flipped = v
		if flipped:
			ranks.move_child(back, -1)
			ranks.move_child(front, 0)
