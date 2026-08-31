extends Node
## Chapter 1 progression: each quest’s main dialogue unlocks only after the previous quest’s conversations are finished.

const CHAPTER_1_SCENE := "res://Chapter 1/Clear Stream Valley.tscn"
const CHAPTER1_SPRINKLER_MINIGAME_SCENE := preload("res://Scenes/ui/SprinklerInstallationMiniGame.tscn")

var quest1_maggie_done: bool = false
var quest1_kai_done: bool = false
var quest1_jessica_done: bool = false

var quest2_arden_done: bool = false
var quest2_steven_done: bool = false
var quest2_aurora_done: bool = false
## Set when the player confirms the Quest 2 completion panel (Chapter 1).
var chapter1_quest2_completion_acknowledged: bool = false

var quest3_complete: bool = false
var quest4_complete: bool = false
var quest5_complete: bool = false
var chapter1_sprinkler_minigame_completed: bool = false
var _chapter1_sprinkler_minigame_ui: CanvasLayer = null

var chapter2_quest1_matt_done: bool = false
var chapter2_quest1_kai_done: bool = false
var chapter2_quest1_jessica_done: bool = false
var chapter2_beach_cleanup_started: bool = false
var chapter2_beach_cleanup_done: bool = false
var chapter2_beach_collected_ids: Array[String] = []
var chapter2_quest2_residents_done: bool = false
var chapter2_quest3_matt_done: bool = false
var chapter2_quest3_kai_done: bool = false
var chapter2_quest3_warehouse_done: bool = false
var chapter2_quest4_meeting_done: bool = false
var chapter2_sign_assembled: bool = false
var chapter2_quest5_cleanup_done: bool = false
var chapter2_description_shown: bool = false
var chapter2_summary_shown: bool = false

var chapter3_quest1_advaita_done: bool = false
var chapter3_quest1_sarina_done: bool = false
var chapter3_quest1_aurora_done: bool = false
var chapter3_quest2_advaita_done: bool = false
var chapter3_quest2_sarina_done: bool = false
var chapter3_quest2_aurora_done: bool = false
var chapter3_quest2_home_visits_done: bool = false
var chapter3_quest3_festival_setup_done: bool = false
var chapter3_quest4_town_dialogue_done: bool = false
var chapter3_quest5_celebration_done: bool = false
var chapter3_description_shown: bool = false
var chapter3_summary_shown: bool = false

var chapter0_traveler_done: bool = false
var chapter0_family_done: bool = false
var chapter0_friend_done: bool = false
var chapter1_description_shown: bool = false
var chapter1_castle_gate_shown: bool = false
var chapter1_castle_puzzle_complete: bool = false
var chapter1_summary_shown: bool = false
var interaction_lock_count: int = 0

#bridge repair - Ayden Tran
var bridge_repaired := false
const BRIDGE_RETURN_POSITION_META := "bridge_puzzle_return_position"

## Chapter 1: broken bridge on the path toward Quest 3 (not part of Quest 2).
## Active only after Quest 2 is done, until the plank puzzle is finished.
func needs_chapter1_bridge_repair() -> bool:
	return is_quest2_complete() and not bridge_repaired


## Player may open the bridge plank puzzle (Quest 2 finished, bridge not yet repaired).
func can_repair_chapter1_bridge() -> bool:
	return needs_chapter1_bridge_repair()


func is_quest1_complete() -> bool:
	return quest1_maggie_done and quest1_kai_done and quest1_jessica_done


func is_quest2_complete() -> bool:
	return quest2_arden_done and quest2_steven_done and quest2_aurora_done


func is_chapter1_complete() -> bool:
	return is_quest1_complete() and is_quest2_complete() and quest3_complete and quest4_complete and quest5_complete


func is_chapter1_castle_puzzle_complete() -> bool:
	if chapter1_castle_puzzle_complete:
		return true
	var achievement_manager := get_node_or_null("/root/AchievementManager")
	if achievement_manager != null and achievement_manager.has_badge("puzzle_solver"):
		chapter1_castle_puzzle_complete = true
	return chapter1_castle_puzzle_complete


func mark_chapter1_castle_puzzle_complete() -> void:
	chapter1_castle_puzzle_complete = true
	var achievement_manager := get_node_or_null("/root/AchievementManager")
	if achievement_manager != null:
		achievement_manager.unlock_badge("puzzle_solver")


func is_chapter2_quest1_complete() -> bool:
	return chapter2_beach_cleanup_done


func is_chapter2_quest2_complete() -> bool:
	return chapter2_quest1_matt_done


func is_chapter2_quest3_complete() -> bool:
	return chapter2_quest3_matt_done and chapter2_quest3_kai_done


func is_chapter2_complete() -> bool:
	return is_chapter2_quest1_complete() and is_chapter2_quest2_complete() and chapter2_quest3_warehouse_done and chapter2_quest4_meeting_done and chapter2_quest5_cleanup_done


func is_chapter3_quest1_complete() -> bool:
	return chapter3_quest1_advaita_done and chapter3_quest1_sarina_done and chapter3_quest1_aurora_done


func is_chapter3_quest2_complete() -> bool:
	return chapter3_quest2_advaita_done and chapter3_quest2_sarina_done and chapter3_quest2_aurora_done


func is_chapter3_complete() -> bool:
	return is_chapter3_quest1_complete() and chapter3_quest2_home_visits_done and chapter3_quest3_festival_setup_done and chapter3_quest4_town_dialogue_done and chapter3_quest5_celebration_done


func mark_quest1_maggie_done() -> void:
	quest1_maggie_done = true


func mark_quest1_kai_done() -> void:
	quest1_kai_done = true


func mark_quest1_jessica_done() -> void:
	quest1_jessica_done = true


func mark_quest2_arden_done() -> void:
	quest2_arden_done = true
	_notify_chapter1_quest2_complete()


func mark_quest2_steven_done() -> void:
	quest2_steven_done = true
	_notify_chapter1_quest2_complete()


func mark_quest2_aurora_done() -> void:
	quest2_aurora_done = true
	_notify_chapter1_quest2_complete()


func _notify_chapter1_quest2_complete() -> void:
	if not is_quest2_complete() or chapter1_quest2_completion_acknowledged:
		return
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	for node in tree.get_nodes_in_group("story_guide_panel"):
		if node.has_method("_queue_chapter1_quest2_completion_panel"):
			node.call_deferred("_queue_chapter1_quest2_completion_panel")
			return


func acknowledge_chapter1_quest2_completion() -> void:
	chapter1_quest2_completion_acknowledged = true


func mark_quest3_complete() -> void:
	quest3_complete = true


func mark_quest4_complete() -> void:
	quest4_complete = true


func mark_quest5_complete() -> void:
	if _should_open_chapter1_sprinkler_minigame():
		_open_chapter1_sprinkler_minigame()
		return
	quest5_complete = true


func _should_open_chapter1_sprinkler_minigame() -> bool:
	if chapter1_sprinkler_minigame_completed or quest5_complete:
		return false
	if not quest4_complete:
		return false
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.current_scene == null:
		return false
	return tree.current_scene.scene_file_path == CHAPTER_1_SCENE


func _open_chapter1_sprinkler_minigame() -> void:
	if is_instance_valid(_chapter1_sprinkler_minigame_ui):
		return
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null or tree.current_scene == null:
		return
	_chapter1_sprinkler_minigame_ui = CHAPTER1_SPRINKLER_MINIGAME_SCENE.instantiate()
	tree.current_scene.add_child(_chapter1_sprinkler_minigame_ui)
	_chapter1_sprinkler_minigame_ui.completed.connect(_on_chapter1_sprinkler_minigame_completed)


func _on_chapter1_sprinkler_minigame_completed() -> void:
	chapter1_sprinkler_minigame_completed = true
	quest5_complete = true
	_chapter1_sprinkler_minigame_ui = null


func mark_chapter2_quest1_matt_done() -> void:
	chapter2_quest1_matt_done = true
	_notify_chapter2_cast_refresh()


func mark_chapter2_quest1_kai_done() -> void:
	chapter2_quest1_kai_done = true
	_update_chapter2_quest1_completion()


func mark_chapter2_quest1_jessica_done() -> void:
	chapter2_quest1_jessica_done = true
	_update_chapter2_quest1_completion()


func mark_chapter2_beach_cleanup_started() -> void:
	chapter2_beach_cleanup_started = true
	_notify_beach_cleanup_refresh()
	_notify_chapter2_cast_refresh()


func mark_chapter2_beach_cleanup_done() -> void:
	chapter2_beach_cleanup_done = true
	_notify_chapter2_cast_refresh()


func collect_beach_trash_item(item_id: String) -> void:
	if item_id.is_empty() or item_id in chapter2_beach_collected_ids:
		return
	chapter2_beach_collected_ids.append(item_id)


func is_beach_trash_collected(item_id: String) -> bool:
	return item_id in chapter2_beach_collected_ids


func get_beach_trash_collected_count() -> int:
	return chapter2_beach_collected_ids.size()


func get_beach_trash_collected_items() -> Array[Dictionary]:
	return BeachCleanupConfig.get_collected_items(chapter2_beach_collected_ids)


func has_collected_all_beach_trash() -> bool:
	return get_beach_trash_collected_count() >= BeachCleanupConfig.TRASH_ITEMS.size()


func mark_chapter2_quest2_residents_done() -> void:
	chapter2_quest2_residents_done = true
	_notify_chapter2_cast_refresh()


func _update_chapter2_quest1_completion() -> void:
	if is_chapter2_quest1_complete():
		_notify_chapter2_cast_refresh()


func mark_chapter2_quest3_matt_done() -> void:
	chapter2_quest3_matt_done = true
	_update_chapter2_quest3_completion()


func mark_chapter2_quest3_kai_done() -> void:
	chapter2_quest3_kai_done = true
	_update_chapter2_quest3_completion()


func mark_chapter2_quest3_warehouse_done() -> void:
	chapter2_quest3_matt_done = true
	chapter2_quest3_kai_done = true
	chapter2_quest3_warehouse_done = true


func _update_chapter2_quest3_completion() -> void:
	if is_chapter2_quest3_complete():
		chapter2_quest3_warehouse_done = true
		_notify_chapter2_cast_refresh()


func _notify_chapter2_cast_refresh() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	for node in tree.get_nodes_in_group("story_guide_panel"):
		if node.has_method("_refresh_chapter2_cast_visibility"):
			node.call_deferred("_refresh_chapter2_cast_visibility")
			return


func _notify_beach_cleanup_refresh() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	for node in tree.get_nodes_in_group("beach_cleanup_manager"):
		if node.has_method("refresh_trash_visibility"):
			node.call_deferred("refresh_trash_visibility")


func mark_chapter2_quest4_meeting_done() -> void:
	chapter2_quest4_meeting_done = true
	_notify_chapter2_cast_refresh()


func mark_chapter2_quest5_cleanup_done() -> void:
	if not chapter2_sign_assembled:
		return
	chapter2_quest5_cleanup_done = true
	_notify_chapter2_cast_refresh()


func mark_chapter2_sign_assembled() -> void:
	chapter2_sign_assembled = true


func mark_chapter3_quest1_advaita_done() -> void:
	chapter3_quest1_advaita_done = true


func mark_chapter3_quest1_sarina_done() -> void:
	chapter3_quest1_sarina_done = true


func mark_chapter3_quest1_aurora_done() -> void:
	chapter3_quest1_aurora_done = true


func mark_chapter3_quest2_home_visits_done() -> void:
	chapter3_quest2_home_visits_done = true


func mark_chapter3_quest2_advaita_done() -> void:
	chapter3_quest2_advaita_done = true
	_update_chapter3_quest2_completion()


func mark_chapter3_quest2_sarina_done() -> void:
	chapter3_quest2_sarina_done = true
	_update_chapter3_quest2_completion()


func mark_chapter3_quest2_aurora_done() -> void:
	chapter3_quest2_aurora_done = true
	_update_chapter3_quest2_completion()


func mark_chapter3_quest3_festival_setup_done() -> void:
	chapter3_quest3_festival_setup_done = true


func mark_chapter3_quest4_town_dialogue_done() -> void:
	chapter3_quest4_town_dialogue_done = true


func mark_chapter3_quest5_celebration_done() -> void:
	chapter3_quest5_celebration_done = true


func mark_chapter0_traveler_done() -> void:
	chapter0_traveler_done = true


func mark_chapter0_family_done() -> void:
	chapter0_family_done = true


func mark_chapter0_friend_done() -> void:
	chapter0_friend_done = true


func is_chapter0_complete() -> bool:
	return chapter0_traveler_done and chapter0_family_done and chapter0_friend_done


## True while story guide / quest description panel is open (blocks player movement).
func is_story_guide_blocking_input() -> bool:
	if is_interaction_input_locked():
		return true
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return false
	for node in tree.get_nodes_in_group("story_guide_panel"):
		if "is_guide_open" in node and node.is_guide_open:
			return true
	return false


func push_interaction_input_lock() -> void:
	interaction_lock_count += 1


func pop_interaction_input_lock() -> void:
	interaction_lock_count = maxi(0, interaction_lock_count - 1)


func is_interaction_input_locked() -> bool:
	return interaction_lock_count > 0


func _update_chapter3_quest2_completion() -> void:
	if is_chapter3_quest2_complete():
		chapter3_quest2_home_visits_done = true
