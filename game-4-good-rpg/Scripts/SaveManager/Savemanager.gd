extends Node

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1


func save_game() -> bool:
	var save_data := {
		"save_version": SAVE_VERSION,
		"updated_at":
			Time.get_datetime_string_from_system(true),
		"progress": QuestState.to_dict(),
		"achievements":
			AchievementManager.to_dict(),
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

	QuestState.load_from_dict(progress)
	AchievementManager.load_from_dict(
		achievements
	)

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
