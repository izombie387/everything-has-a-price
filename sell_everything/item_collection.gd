@tool
extends VBoxContainer
@onready var groups = {
	"hud": $Hud,
	"characters": $Stuff/Characters,
	"items": $Stuff/Items,
	"actions": $Actions,
}
@export var character: PanelContainer
@export var flipped: = false:
	set(v):
		flipped = v
		if flipped:
			character.move_to_front()
		else:
			$Stuff.move_child(character, 0)
		

func add_item(
		item_name: String,
		group: String,
		index: int,
):
	var slot = groups[group].get_children()[index]
	if is_instance_valid(slot.item_node):
		print("need to free")
		slot.clear_item()
	slot.set_item(item_name)
