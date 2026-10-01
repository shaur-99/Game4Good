extends Node

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1

# Pending restore state populated by load_game(), consumed by scenes.
var _pending_scene_path := ""
var _pending_player_state: Dictionary = {}


func save_game() -> bool:
	var save_data := {
		"save_version": SAVE_VERSION,
		"updated_at":
			Time.get_datetime_string_from_system(true),
		"progress": QuestState.to_dict(),
		"achievements":
			AchievementManager.to_dict(),
		"dialogue_choices":
			DialogueChoices.to_dict(),
		"scene_path": _capture_current_scene_path(),
		"player": _capture_player_state(),
	}

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:
		push_error(
            "Could not open save file: %s"
			% FileAccess.get_open_error()
		)
		return false

	file.store_string(
		JSON.stringify(save_data, "\t")
	)
	file.close()

	print("[SaveManager] Game saved")
	return true


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[SaveManager] No save file")
		return false

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if file == null:
		push_error(
            "Could not read save file"
		)
		return false

	var content := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(content)

	if parsed == null or parsed is not Dictionary:
		push_error(
            "[SaveManager] Invalid save JSON"
		)
		return false

	var save_data := parsed as Dictionary

	var version := int(
		save_data.get("save_version", 0)
	)

	if version != SAVE_VERSION:
		push_warning(
            "[SaveManager] Unsupported version: %d"
			% version
		)
		return false

	var progress: Dictionary = save_data.get(
		"progress",
		{}
	)

	var achievements: Dictionary = save_data.get(
		"achievements",
		{}
	)

	var dialogue_choices: Dictionary = save_data.get(
		"dialogue_choices",
		{}
	)

	QuestState.load_from_dict(progress)
	AchievementManager.load_from_dict(
		achievements
	)
	DialogueChoices.load_from_dict(
		dialogue_choices
	)

	_pending_scene_path = str(save_data.get("scene_path", ""))
	var player_dict: Variant = save_data.get("player", {})
	_pending_player_state = player_dict if player_dict is Dictionary else {}
	print("[SaveManager] Game loaded")
	return true


func delete_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return true

	var result := DirAccess.remove_absolute(
		ProjectSettings.globalize_path(SAVE_PATH)
	)

	if result != OK:
		push_error(
            "[SaveManager] Could not delete save"
		)
		return false

	return true



func _capture_current_scene_path() -> String:
	var scene := get_tree().current_scene
	if scene == null:
		return ""
	return scene.scene_file_path


func _capture_player_state() -> Dictionary:
	var scene := get_tree().current_scene
	if scene == null:
		return {}
	var player := scene.get_node_or_null("Player") as Node2D
	if player == null:
		player = scene.get_node_or_null("CharacterBody2D") as Node2D
	if player == null:
		return {}
	var state := {
		"position": [player.global_position.x, player.global_position.y],
	}
	return state


func get_pending_scene_path() -> String:
	return _pending_scene_path


func take_pending_player_state() -> Dictionary:
	var s := _pending_player_state
	_pending_player_state = {}
	return s
