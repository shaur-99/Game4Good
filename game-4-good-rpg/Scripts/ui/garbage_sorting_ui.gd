extends CanvasLayer

signal all_sorted

const CARD_SCENE := preload("res://Scenes/ui/DraggableTrashCard.tscn")
const BIN_SCENE := preload("res://Scenes/ui/TrashBinDropZone.tscn")

@onready var items_container: Control = $Root/Panel/MarginContainer/MainVBox/ItemsRow/ItemsPanel/ItemsGrid
@onready var bins_container: HBoxContainer = $Root/Panel/MarginContainer/MainVBox/BinsRow
@onready var helper_label: Label = $Root/Panel/MarginContainer/MainVBox/HelperLabel
@onready var success_label: Label = $Root/Panel/MarginContainer/MainVBox/SuccessLabel
@onready var title_label: Label = $Root/Panel/MarginContainer/MainVBox/TitleLabel

var _sorted_count := 0
var _total_count := 0
var _is_open := false


func _ready() -> void:
	add_to_group("garbage_sorting_ui")
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	layer = 120
	QuestState.push_interaction_input_lock()
	helper_label.text = ""
	success_label.visible = false
	title_label.text = "Sort the collected trash into the correct bags"
	open_with_collected_items()


func _exit_tree() -> void:
	QuestState.pop_interaction_input_lock()


func open_with_collected_items() -> void:
	if _is_open:
		return
	_is_open = true
	get_tree().paused = true
	_populate_bins()
	_populate_items()


func _populate_bins() -> void:
	for child in bins_container.get_children():
		child.queue_free()
	for bin_data in BeachCleanupConfig.BINS:
		var bin: PanelContainer = BIN_SCENE.instantiate()
		bins_container.add_child(bin)
		bin.setup(bin_data)
		bin.item_sorted.connect(_on_item_sorted)
		bin.wrong_drop.connect(_on_wrong_drop)


func _populate_items() -> void:
	for child in items_container.get_children():
		child.queue_free()
	var items := QuestState.get_beach_trash_collected_items()
	_total_count = items.size()
	_sorted_count = 0
	var x_offset := 0.0
	const CARD_WIDTH := 128.0
	const CARD_GAP := 12.0
	for item in items:
		var card: PanelContainer = CARD_SCENE.instantiate()
		items_container.add_child(card)
		card.setup(item)
		card.position = Vector2(x_offset, 0.0)
		x_offset += CARD_WIDTH + CARD_GAP
	await get_tree().process_frame
	for card in items_container.get_children():
		if card.has_method("remember_home_position"):
			card.remember_home_position()


func _on_item_sorted(_item_id: String) -> void:
	_sorted_count += 1
	success_label.text = BeachCleanupConfig.SUCCESS_MESSAGE
	success_label.visible = true
	helper_label.text = ""
	await get_tree().create_timer(0.8).timeout
	if not is_inside_tree():
		return
	success_label.visible = false
	if _sorted_count >= _total_count:
		close_and_complete()


func _on_wrong_drop() -> void:
	helper_label.text = BeachCleanupConfig.WRONG_DROP_MESSAGE


func close_and_complete() -> void:
	if not _is_open:
		return
	_is_open = false
	get_tree().paused = false
	all_sorted.emit()
	queue_free()


func close_without_complete() -> void:
	if not _is_open:
		return
	_is_open = false
	get_tree().paused = false
	queue_free()
