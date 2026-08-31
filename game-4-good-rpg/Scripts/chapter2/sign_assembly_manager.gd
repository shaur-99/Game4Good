extends Node2D

const SIGN_SCENE := preload("res://Scenes/chapter2/SignAssemblyInteractable.tscn")
const PUZZLE_UI_SCENE := preload("res://Scenes/ui/SignAssemblyPuzzleUI.tscn")
const SIGN_POSITION := Vector2(3450, -700)

var _sign_instance: Area2D = null
var _puzzle_ui: CanvasLayer = null
var _snap_quest4_done := false
var _snap_sign_done := false
var _snap_quest5_done := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	call_deferred("_ensure_sign")
	call_deferred("_sync_state")


func _process(_delta: float) -> void:
	var quest4_done := QuestState.chapter2_quest4_meeting_done
	var sign_done := QuestState.chapter2_sign_assembled
	var quest5_done := QuestState.chapter2_quest5_cleanup_done
	if (
		quest4_done == _snap_quest4_done
		and sign_done == _snap_sign_done
		and quest5_done == _snap_quest5_done
	):
		return
	_sync_state()


func _ensure_sign() -> void:
	if is_instance_valid(_sign_instance):
		return
	_sign_instance = SIGN_SCENE.instantiate()
	_sign_instance.global_position = SIGN_POSITION
	get_tree().current_scene.add_child(_sign_instance)
	_sign_instance.puzzle_requested.connect(_open_puzzle_ui)


func _sync_state() -> void:
	_ensure_sign()
	var quest4_done := QuestState.chapter2_quest4_meeting_done
	var sign_done := QuestState.chapter2_sign_assembled
	var quest5_done := QuestState.chapter2_quest5_cleanup_done
	var sign_available := quest4_done and not sign_done and not quest5_done
	if is_instance_valid(_sign_instance):
		_sign_instance.set_sign_state(sign_available, sign_done or quest5_done)
	_snap_quest4_done = quest4_done
	_snap_sign_done = sign_done
	_snap_quest5_done = quest5_done


func _open_puzzle_ui() -> void:
	if QuestState.chapter2_sign_assembled:
		return
	if is_instance_valid(_puzzle_ui):
		return
	_puzzle_ui = PUZZLE_UI_SCENE.instantiate()
	get_tree().current_scene.add_child(_puzzle_ui)
	_puzzle_ui.sign_assembly_completed.connect(_on_sign_assembly_completed)


func _on_sign_assembly_completed() -> void:
	_puzzle_ui = null
	QuestState.mark_chapter2_sign_assembled()
	QuestState.mark_chapter2_quest5_cleanup_done()
	_sync_state()
