@tool
extends VBoxContainer

@export var character: Panel
@export var flipped: = false:
	set(v):
		flipped = v
		if flipped:
			character.move_to_front()
		else:
			$Stuff.move_child(character, 0)
		

func add_item(item_name: String):
	$"Stuff/Items/1".set_item(item_name)
