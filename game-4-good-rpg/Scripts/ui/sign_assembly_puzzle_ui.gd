extends CanvasLayer

signal sign_assembly_completed

@onready var helper_label: Label = $Root/Panel/MarginContainer/MainVBox/HelperLabel
@onready var slot_1: Button = $Root/Panel/MarginContainer/MainVBox/SlotsRow/SignSlot1
@onready var slot_2: Button = $Root/Panel/MarginContainer/MainVBox/SlotsRow/SignSlot2
@onready var slot_3: Button = $Root/Panel/MarginContainer/MainVBox/SlotsRow/SignSlot3
@onready var piece_protect: Button = $Root/Panel/MarginContainer/MainVBox/PiecesRow/PieceProtect
@onready var piece_the_blue: Button = $Root/Panel/MarginContainer/MainVBox/PiecesRow/PieceTheBlue
@onready var piece_coast: Button = $Root/Panel/MarginContainer/MainVBox/PiecesRow/PieceCoast

var _selected_piece := ""
var _slot_contents := {
	1: "",
	2: "",
	3: "",
}


func _ready() -> void:
	# Must be ALWAYS: game is not paused while this UI is open.
	process_mode = Node.PROCESS_MODE_ALWAYS
	_apply_process_mode_recursive(self, Node.PROCESS_MODE_ALWAYS)
	layer = 130
	_configure_mouse_filters()
	QuestState.push_interaction_input_lock()
	_bind_piece(piece_protect, "Protect")
	_bind_piece(piece_the_blue, "the Blue")
	_bind_piece(piece_coast, "Coast")
	slot_1.pressed.connect(_on_slot_pressed.bind(1))
	slot_2.pressed.connect(_on_slot_pressed.bind(2))
	slot_3.pressed.connect(_on_slot_pressed.bind(3))
	_refresh_piece_highlight()


func _exit_tree() -> void:
	QuestState.pop_interaction_input_lock()


func _configure_mouse_filters() -> void:
	var root: Control = $Root
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	$Root/Dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	$Root/Panel.mouse_filter = Control.MOUSE_FILTER_STOP


func _apply_process_mode_recursive(node: Node, mode: Node.ProcessMode) -> void:
	node.process_mode = mode
	for child in node.get_children():
		_apply_process_mode_recursive(child, mode)


func _bind_piece(button: Button, piece_text: String) -> void:
	button.pressed.connect(_on_piece_selected.bind(piece_text))


func _on_piece_selected(piece_text: String) -> void:
	if _is_piece_placed(piece_text):
		return
	_selected_piece = piece_text
	helper_label.text = "Selected: %s. Choose a slot." % piece_text
	_refresh_piece_highlight()


func _on_slot_pressed(slot_index: int) -> void:
	if _selected_piece.is_empty():
		helper_label.text = "Select a piece first."
		return
	if not _slot_contents[slot_index].is_empty():
		helper_label.text = "This slot is already filled."
		return
	if not _is_correct_for_slot(_selected_piece, slot_index):
		helper_label.text = "Try another spot. The sign should read: Protect the Blue Coast."
		return
	_slot_contents[slot_index] = _selected_piece
	_lock_piece(_selected_piece)
	_update_slot_text(slot_index, _selected_piece)
	helper_label.text = "Good placement."
	_selected_piece = ""
	_refresh_piece_highlight()
	if _all_slots_correct():
		_finish_success()


func _refresh_piece_highlight() -> void:
	var pieces := [
		{"button": piece_protect, "text": "Protect"},
		{"button": piece_the_blue, "text": "the Blue"},
		{"button": piece_coast, "text": "Coast"},
	]
	for entry in pieces:
		var button: Button = entry["button"]
		if button.disabled:
			button.modulate = Color(0.75, 0.75, 0.75, 1.0)
		elif entry["text"] == _selected_piece:
			button.modulate = Color(1.15, 1.1, 0.65, 1.0)
		else:
			button.modulate = Color.WHITE


func _is_correct_for_slot(piece_text: String, slot_index: int) -> bool:
	if slot_index == 1:
		return piece_text == "Protect"
	if slot_index == 2:
		return piece_text == "the Blue"
	return piece_text == "Coast"


func _update_slot_text(slot_index: int, piece_text: String) -> void:
	if slot_index == 1:
		slot_1.text = "Slot 1: %s" % piece_text
	elif slot_index == 2:
		slot_2.text = "Slot 2: %s" % piece_text
	else:
		slot_3.text = "Slot 3: %s" % piece_text


func _lock_piece(piece_text: String) -> void:
	var button := _piece_button(piece_text)
	if button == null:
		return
	button.disabled = true
	button.text = "%s ✓" % piece_text
	_refresh_piece_highlight()


func _piece_button(piece_text: String) -> Button:
	match piece_text:
		"Protect":
			return piece_protect
		"the Blue":
			return piece_the_blue
		"Coast":
			return piece_coast
		_:
			return null


func _is_piece_placed(piece_text: String) -> bool:
	return _slot_contents[1] == piece_text or _slot_contents[2] == piece_text or _slot_contents[3] == piece_text


func _all_slots_correct() -> bool:
	return (
		_slot_contents[1] == "Protect"
		and _slot_contents[2] == "the Blue"
		and _slot_contents[3] == "Coast"
	)


func _finish_success() -> void:
	helper_label.text = "The sign is ready!"
	slot_1.disabled = true
	slot_2.disabled = true
	slot_3.disabled = true
	piece_protect.disabled = true
	piece_the_blue.disabled = true
	piece_coast.disabled = true
	await get_tree().create_timer(0.7).timeout
	if not is_inside_tree():
		return
	sign_assembly_completed.emit()
	queue_free()
