@tool
extends VBoxContainer
@onready var groups = {
	"hud": $Hud,
	"characters": $Stuff/Characters,
	"items": $Stuff/Items,
	"equipment": $Equipment,
}
@export var characters: GridContainer
@export var flipped: = false:
	set(v):
		flipped = v
		if flipped:
			characters.move_to_front()
		else:
			$Stuff.move_child(characters, 0)
		
	#"knight": {
		#"items":["knife"],
		#"equipment":["shield"],
		#"hud":["hp_bar"],
		#"characters":["knight"],
func load_data(data):
	for group in data:
		var i=0
		for item in data[group]:
			add_item(item, group, i)
			i+=1


func add_item(
		item_name: String,
		group: String,
		index: int,
):
	var slot = groups[group].get_children()[index]
	if is_instance_valid(slot.item_node):
		slot.clear_item()
	slot.set_item(item_name)
