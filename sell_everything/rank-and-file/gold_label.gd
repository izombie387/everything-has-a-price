extends Label
	
func _ready() -> void:
	update(Globals.get_gold())
	Globals.gold_changed.connect(update)

func update(g):
	text = "Gold %d" % g
