extends Control

# Range: {Cell: cells in range}
@export var instructions: Label
@export var fight_button: Button
@export var next_button: Button
@export var drop_sell: PanelContainer
@export var actions: Control
@export var player_hp_bar: ProgressBar
@export var enemy_hp_bar: ProgressBar

@onready var debug_layer: CanvasLayer = $DebugLayer
@onready var player: Control = $Margin/VBox/HBox/Player
@onready var enemy: Control = $Margin/VBox/HBox/Enemy
@onready var users = [player, enemy]
@onready var char_buttons = {
	"knight": $Margin/VBox/HBox/Enemy/CharSelect/VBox/Buttons/Knight,
	"archer": $Margin/VBox/HBox/Enemy/CharSelect/VBox/Buttons/Archer,
	"theif": $Margin/VBox/HBox/Enemy/CharSelect/VBox/Buttons/Theif,
}
var current_index: = 0
var hovering_cell = null
var group_sizes: = {
	"back": 1,
	"middle": 2,
	"front": 3,
}
var cells: = []
var active_targets = {}
var phase: = "":
	set(v):
		phase = v
		instructions.text = "Select character"
		print("Phase: ", phase)
		Cell.set_phase(phase)
		match phase:
			"character_select":
				pass
			"arrange":
				instructions.text =\
					"Drag to arrange\nFight when ready"
				fight_button.disabled = false
				next_button.disabled = true
				actions.show()
				instructions.theme_type_variation = "hilighted_label"
			"fight":
				instructions.text =\
					"Fight until it's over"
			"scoring":
				pass
			"shop":
				instructions.text =\
					"Drag to board (buy)\nDrag to shop ↓ (sell)"\
					+"\nNext when ready"
				fight_button.disabled = true
				next_button.disabled = false


func _ready() -> void:
	$DebugLayer/Score.hide()
	phase = "character_select"
	actions.hide()
	await get_tree().process_frame
	cells = player.cells + enemy.cells
	var i = 0
	for cell in cells:
		cell.clear_item()
		cell.clicked.connect(_cell_clicked)
		cell.mouse_entered.connect(_cell_hovered.bind(cell))
		cell.mouse_exited.connect(_cell_unhovered.bind(cell))
		cell.index = i
		i += 1
	for char_name in char_buttons:
		var btn = char_buttons[char_name]
		btn.pressed.connect(start_game)
		btn.pressed.connect(Globals.play_sfx.bind("click"))
		btn.mouse_entered.connect(
			(func(u,c):
				clear_items(u)
				loadout_user(u, c)
				).bind(player, char_name)
		)
	actions.get_node("Fight").pressed.connect(on_fight_pressed)
	for sellable: Control in get_tree().get_nodes_in_group("sellables"):
		sellable.set_script(load(
				"res://sell_everything/sellable.gd"))


func on_fight_pressed():
	if phase == "arrange":
		phase = "fight"
		populate_targets()
		if active_targets.is_empty():
			end_fight()
			return
	if phase == "fight":
		process_next_cell()
			

func populate_targets():
	var active_cells = cells.filter(
			func(c): return is_active(c))
	var p_targets = []
	var e_targets = []
	for cell in active_cells:
		var target = get_target(cell, cell.item_name)
		if target:
			if cell.user == "player":
				p_targets.append([cell,target])
			elif cell.user == "enemy":
				e_targets.append([cell,target])
	active_targets.clear()
	for i in max(p_targets.size(), e_targets.size()):
		if i < p_targets.size():
			active_targets[p_targets[i][0]] = p_targets[i][1]
		if i < e_targets.size():
			active_targets[e_targets[i][0]] = e_targets[i][1]


func start_game():
	var char_select = $Margin/VBox/HBox/Enemy/CharSelect
	char_select.hide()
	clear_items(enemy)
	loadout_random(enemy)
	phase = "arrange"
	
	var player_hp = 0
	for cell in player.cells:
		player_hp += cell.hp
	player_hp_bar.max_value = player_hp
	player_hp_bar.value = player_hp
	
	var enemy_hp = 0
	for cell in player.cells:
		enemy_hp += cell.hp
	enemy_hp_bar.max_value = enemy_hp
	enemy_hp_bar.value = enemy_hp
		

func end_fight():
	phase = "scoring"
	
	var player_hp_lost = player_hp_bar.max_value - player_hp_bar.value
	var enemy_hp_lost = enemy_hp_bar.max_value - enemy_hp_bar.value
	var points = []
	points.append(int(
		player_hp_lost < enemy_hp_lost))
	points.append(int(
		player_hp_lost == 0))
	points.append(int(
		current_index < 10))
	
	
	var score_text = str(
		"Gold won:",
		"\nBetter Hp: {0}",
		"\nPerfect Hp: {1}",
		"\nUnder 10 turns: {2}",
	).format(points)
	$DebugLayer/Score/VBox/Label.text = score_text
	
	$DebugLayer/Score.show()
	await $DebugLayer/Score/VBox/Ok.pressed
	
	var gold_won = points.reduce(func(a,b): return a+b)
	Globals.add_gold(gold_won)
	
	$DebugLayer/Score.hide()
	phase = "shop"


func _cell_hovered(cell):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if cell.item_name:
		hovering_cell = cell
		hilight_cell(cell)


func _cell_unhovered(cell):
	if hovering_cell:
		hovering_cell = null
		hilight_cell(cell, false)


func hilight_cell(cell, hilight = true):
	var item_name = cell.item_name
	for idx in Data.get_adjacencies(cell.index, item_name):
		cells[idx].hilight(hilight)


func loadout_user(_user, loadout_name):
	var list = Data.loadouts[loadout_name]
	for index in list:
		cells[index].set_item(list[index])


func loadout_random(user: MarginContainer):
	var enemies = 0
	while enemies < 3:
		for cell in user.cells:
			if randf() < 0.5:
				continue
			cell.set_item(Data.random_item_name()	)
			enemies += 1


func _cell_clicked(clicked_cell):
	debug_layer.list.show()
	var item_name: String = await debug_layer.item_selected
	match item_name:
		"none":
			clicked_cell.clear_item()
		"cancel":
			return
		"clear_all":
			for cell in cells:
				cell.clear_item()
		"random_enemy":
			clear_items(enemy)
			loadout_random(enemy)
		_:
			if "load/" in item_name:
				var loadout = item_name.trim_prefix("load/")
				clear_items()
				loadout_user(player, loadout)
			else:
				clicked_cell.set_item(item_name)
	
	
func clear_items(user = null):
	var to_clear = user.cells if user else cells
	to_clear.map(func(c): c.clear_item())


func poke_cells():
	for cell in cells:
		cell.get_node("AnimationPlayer").play("shine")
		await get_tree().create_timer(0.10).timeout


func is_active(cell):
	var item_name = cell.item_name
	if item_name == null or cell.hp <= 0:
		return false
	var item_data = Data.get_item(item_name)
	return "active" in item_data
	
	
func get_target(cell, item_name):
	var target = null
	for adj_index in Data.get_adjacencies(cell.index, item_name):
		var adj_cell = cells[adj_index]
		if adj_cell.item_name and \
				adj_cell.user != cell.user and \
				adj_cell.hp > 0:
			target = adj_cell
			break
	return target


func process_cell(cell, target):
	var active = Data.get_item(cell.item_name)["active"]
	var attack_amount = active["attack"]
	cell.attack_target(target, attack_amount)
	target.recieve_damage_from(cell, attack_amount)
	
	if target.user == "player":
		player_hp_bar.value -= attack_amount
	elif target.user == "enemy":
		enemy_hp_bar.value -= attack_amount


func fill_random(node: Node) -> void:
	for group in group_sizes:
		var count = group_sizes[group]
		for i in count:
			node.add_item(
				Data.rand_by_group(group),
				group, i)


func process_next_cell():
	var target = active_targets.values()[current_index]
	process_cell(
			active_targets.keys()[current_index],
			target)
	if target.hp <= 0:
		populate_targets()
		if active_targets.is_empty():
			end_fight()
			return
	current_index = (current_index + 1) % active_targets.size()
			

	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_D:
				clear_items()
				loadout_random(player)
				loadout_random(enemy)
			KEY_P:
				process_next_cell()
			KEY_R:
				get_tree().reload_current_scene()
			KEY_F:
				var w: = get_window()
				if w.mode == w.MODE_FULLSCREEN:
					w.mode = w.MODE_WINDOWED
				else:
					w.mode = w.MODE_FULLSCREEN
			KEY_C:
				var loadout = {}
				for cell in cells:
					if cell.item_name:
						loadout[cell.index] = cell.item_name


func _on_next_pressed() -> void:
	if phase == "shop":
		for cell in cells:
			cell.revive()
		start_game()
