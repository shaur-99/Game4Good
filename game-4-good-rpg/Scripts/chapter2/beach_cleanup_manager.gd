extends Node2D

const TRASH_ITEM_SCENE := preload("res://Scenes/chapter2/TrashItem.tscn")
const SORTING_UI_SCENE := preload("res://Scenes/ui/GarbageSortingUI.tscn")
const DIALOGUE := preload("res://dialogue.dialogue")

@onready var trash_container: Node2D = $TrashItems

var _sorting_ui: CanvasLayer = null
var _completion_pending := false


func _ready() -> void:
	add_to_group("beach_cleanup_manager")
	_spawn_trash_items()
	call_deferred("_sync_scene_state")


func _spawn_trash_items() -> void:
	for child in trash_container.get_children():
		child.queue_free()
	for item_data in BeachCleanupConfig.TRASH_ITEMS:
		var trash_item: Area2D = TRASH_ITEM_SCENE.instantiate()
		trash_item.item_id = item_data.get("item_id", "")
		trash_item.display_name = item_data.get("display_name", "Trash")
		trash_item.trash_type = item_data.get("trash_type", "")
		trash_item.position = item_data.get("position", Vector2.ZERO)
		trash_item.collected.connect(_on_trash_collected)
		trash_container.add_child(trash_item)


func _sync_scene_state() -> void:
	if QuestState.chapter2_beach_cleanup_done:
		_hide_all_trash()
		return
	for trash_item in get_tree().get_nodes_in_group("beach_trash_item"):
		if trash_item.has_method("refresh_state"):
			trash_item.refresh_state()
	if QuestState.has_collected_all_beach_trash():
		_open_sorting_ui()


func refresh_trash_visibility() -> void:
	if QuestState.chapter2_beach_cleanup_done:
		_hide_all_trash()
		return
	for trash_item in get_tree().get_nodes_in_group("beach_trash_item"):
		if trash_item.has_method("refresh_state"):
			trash_item.refresh_state()


func _hide_all_trash() -> void:
	for trash_item in get_tree().get_nodes_in_group("beach_trash_item"):
		trash_item.queue_free()


func _on_trash_collected(_item_id: String) -> void:
	if QuestState.has_collected_all_beach_trash():
		_open_sorting_ui()


func _open_sorting_ui() -> void:
	if QuestState.chapter2_beach_cleanup_done:
		return
	if _sorting_ui != null and is_instance_valid(_sorting_ui):
		return
	if get_tree().get_first_node_in_group("garbage_sorting_ui") != null:
		return
	_sorting_ui = SORTING_UI_SCENE.instantiate()
	get_tree().current_scene.add_child(_sorting_ui)
	_sorting_ui.all_sorted.connect(_on_all_sorted)


func _on_all_sorted() -> void:
	if QuestState.chapter2_beach_cleanup_done or _completion_pending:
		return
	_completion_pending = true
	QuestState.mark_chapter2_beach_cleanup_done()
	_hide_all_trash()
	DialogueManager.show_example_dialogue_balloon(DIALOGUE, BeachCleanupConfig.COMPLETION_DIALOGUE_TITLE)
	_sorting_ui = null
	_completion_pending = false
