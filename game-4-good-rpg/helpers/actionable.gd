extends Area2D

const CHAPTER_2_SCENE := "res://Scenes/chapter_2.tscn"

enum Chapter1Gate {
	NONE,
	## Quest 2 — Arden, Steven, Aurora: any order; only Quest 1 (three households) must be done first.
	QUEST2_OPINION,
	## Quest 3 — Villagers: needs all Quest 2 opinion dialogues (Arden, Steven, Aurora) finished, in any order.
	VILLAGERS_COUNCIL,
	## Council group sprite — [member dialogue_start] only after Quest 1, Quest 2, and Quest 3 (meeting announced).
	QUEST4_COUNCIL_GROUP,
	## Chapter 2 quest 1 members (Matt/Jessica) unlock only after Chapter 1 summary.
	CHAPTER2_QUEST1,
	## Chapter 2 follow-up interactions that require chapter 2 quest 1 done first.
	CHAPTER2_AFTER_QUEST1,
	## Chapter 3 quest 1 members unlock only after Chapter 2 summary.
	CHAPTER3_QUEST1,
	## Chapter 3 follow-up interactions that require chapter 3 quest 1 done first.
	CHAPTER3_AFTER_QUEST1,
	## Chapter 2 quest 4 group interaction (Matt + Kai + villagers).
	CHAPTER2_QUEST4_GROUP,
}

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
## Used with [constant VILLAGERS_COUNCIL] after Quest 4 is done, until Quest 5 dialogue completes (empty defaults to villagers_quest5).
@export var dialogue_after_quest4: String = ""
## Used with [constant VILLAGERS_COUNCIL] after Quest 5 is done (empty = [member _villagers_title_after_quest5]).
@export var dialogue_after_quest5: String = ""
## When set, [member _resolve_dialogue_start] enforces Chapter 1 quest order (not order within the same quest).
@export var chapter1_gate: Chapter1Gate = Chapter1Gate.NONE
## Optional chapter-specific dialogue title for repeated NPCs.
@export var dialogue_chapter2_start: String = ""
## Optional chapter-specific dialogue title used after Chapter 2 Quest 2 and before Quest 3 is complete.
@export var dialogue_chapter2_after_quest2: String = ""
## Optional chapter-specific dialogue title for repeated NPCs.
@export var dialogue_chapter3_start: String = ""
## Optional chapter-specific dialogue title used after Chapter 3 Quest 3 and before Quest 4 is complete.
@export var dialogue_chapter3_after_quest3: String = ""


func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, _resolve_dialogue_start())


func _resolve_dialogue_start() -> String:
	if _is_on_chapter2_map() and not dialogue_chapter2_start.is_empty():
		match chapter1_gate:
			Chapter1Gate.CHAPTER2_AFTER_QUEST1:
				if not QuestState.chapter1_summary_shown:
					return "chapter2_locked_finish_chapter1"
				if not QuestState.is_chapter2_quest1_complete():
					return "chapter2_locked_finish_quest1"
				if QuestState.is_chapter2_quest2_complete():
					if not QuestState.chapter2_quest3_warehouse_done:
						return "chapter2_locked_finish_quest3"
					return "fishing_village_residents_ch2_repeat"
				return dialogue_start
			Chapter1Gate.CHAPTER2_QUEST4_GROUP:
				pass
			_:
				return _resolve_chapter2_quest1_npc_dialogue()

	var active_start := _resolve_active_dialogue_start()

	match chapter1_gate:
		Chapter1Gate.QUEST2_OPINION:
			# Aurora is reused across chapters but still configured with QUEST2_OPINION gate.
			# Handle Chapter 3 progression here so it does not fall back to Quest 1 dialogue.
			if _is_chapter3_unlocked() and dialogue_chapter3_start == "aurora_ch3_start":
				if QuestState.is_chapter3_quest1_complete() and not QuestState.chapter3_quest2_home_visits_done:
					return "aurora_ch3_q2_collect_needs_start"
				if QuestState.chapter3_quest1_aurora_done:
					return "aurora_ch3_repeat"
			if not QuestState.is_quest1_complete():
				return "chapter1_locked_finish_investigation"
			return active_start
		Chapter1Gate.VILLAGERS_COUNCIL:
			if QuestState.chapter2_summary_shown:
				if not QuestState.is_chapter3_quest1_complete():
					return "chapter3_locked_finish_quest1"
				if not QuestState.is_chapter3_quest2_complete():
					return "chapter3_locked_finish_quest2"
				if not QuestState.chapter3_quest3_festival_setup_done:
					return "chapter3_locked_finish_quest3"
				if not QuestState.chapter3_quest4_town_dialogue_done:
					return "villagers_ch3_festival_setup_start"
				if not QuestState.chapter3_quest5_celebration_done:
					return "villagers_ch3_celebration_start"
				return "villagers_ch3_celebration_repeat"
			if QuestState.chapter1_summary_shown:
				if not QuestState.is_chapter2_quest1_complete():
					return "chapter2_locked_finish_quest1"
				if not QuestState.is_chapter2_quest2_complete():
					return "chapter2_locked_finish_quest2"
				if not QuestState.chapter2_quest3_warehouse_done:
					return "villagers_ch2_warehouse_start"
				if not QuestState.chapter2_quest4_meeting_done:
					return "chapter2_locked_finish_quest4"
				if not QuestState.chapter2_quest5_cleanup_done:
					return "villagers_ch2_cleanup_start"
				return "villagers_ch2_cleanup_repeat"
			if not QuestState.is_quest2_complete():
				return "chapter1_locked_gather_all_views"
			if QuestState.needs_chapter1_bridge_repair():
				return "chapter1_locked_repair_bridge"
			if not QuestState.quest3_complete:
				return active_start
			if not QuestState.quest4_complete:
				return "chapter1_locked_finish_council_at_square"
			if not QuestState.quest5_complete:
				return dialogue_after_quest4 if not dialogue_after_quest4.is_empty() else "villagers_quest5"
			if not dialogue_after_quest5.is_empty():
				return dialogue_after_quest5
			return _villagers_title_after_quest5()
		Chapter1Gate.QUEST4_COUNCIL_GROUP:
			if QuestState.chapter2_summary_shown:
				if dialogue_chapter3_start.is_empty():
					return "chapter3_use_new_council_group"
				if not QuestState.is_chapter3_quest1_complete():
					return "chapter3_locked_finish_quest1"
				if not QuestState.is_chapter3_quest2_complete():
					return "chapter3_locked_finish_quest2"
				if not QuestState.chapter3_quest3_festival_setup_done:
					return active_start
				if not QuestState.chapter3_quest4_town_dialogue_done:
					return dialogue_chapter3_after_quest3 if not dialogue_chapter3_after_quest3.is_empty() else active_start
				if not QuestState.chapter3_quest5_celebration_done:
					return "villagers_ch3_celebration_start"
				return "villagers_ch3_celebration_repeat"
			if not QuestState.is_quest1_complete():
				return "chapter1_locked_finish_investigation"
			if not QuestState.is_quest2_complete():
				return "chapter1_locked_gather_all_views"
			if not QuestState.quest3_complete:
				return "chapter1_locked_announce_council_first"
			return active_start
		Chapter1Gate.CHAPTER2_QUEST1:
			return _resolve_chapter2_quest1_npc_dialogue()
		Chapter1Gate.CHAPTER2_AFTER_QUEST1:
			if not QuestState.chapter1_summary_shown:
				return "chapter2_locked_finish_chapter1"
			if not QuestState.is_chapter2_quest1_complete():
				return "chapter2_locked_finish_quest1"
			if QuestState.is_chapter2_quest2_complete():
				if not QuestState.chapter2_quest3_warehouse_done:
					return "chapter2_locked_finish_quest3"
				return "fishing_village_residents_ch2_repeat"
			return active_start
		Chapter1Gate.CHAPTER3_QUEST1:
			if not _is_chapter3_unlocked():
				return "chapter3_locked_finish_chapter2"
			if QuestState.is_chapter3_quest1_complete() and not QuestState.chapter3_quest2_home_visits_done:
				if dialogue_start == "advaita_ch3_start":
					return "advaita_ch3_q2_collect_needs_start"
				if dialogue_start == "sarina_ch3_start":
					return "sarina_ch3_q2_collect_needs_start"
				if dialogue_start == "aurora_ch3_start":
					return "aurora_ch3_q2_collect_needs_start"
			if dialogue_start == "advaita_ch3_start" and QuestState.chapter3_quest1_advaita_done:
				return "advaita_ch3_repeat"
			if dialogue_start == "sarina_ch3_start" and QuestState.chapter3_quest1_sarina_done:
				return "sarina_ch3_repeat"
			if dialogue_start == "aurora_ch3_start" and QuestState.chapter3_quest1_aurora_done:
				return "aurora_ch3_repeat"
			return active_start
		Chapter1Gate.CHAPTER3_AFTER_QUEST1:
			if not _is_chapter3_unlocked():
				return "chapter3_locked_finish_chapter2"
			if not QuestState.is_chapter3_quest1_complete():
				return "chapter3_locked_finish_quest1"
			return active_start
		Chapter1Gate.CHAPTER2_QUEST4_GROUP:
			if not QuestState.chapter1_summary_shown:
				return "chapter2_locked_finish_chapter1"
			if not QuestState.is_chapter2_quest1_complete():
				return "chapter2_locked_finish_quest1"
			if not QuestState.is_chapter2_quest2_complete():
				return "chapter2_locked_finish_quest2"
			if not QuestState.chapter2_quest3_warehouse_done:
				return "chapter2_locked_finish_quest3"
			if not QuestState.chapter2_quest4_meeting_done:
				return active_start
			if not QuestState.chapter2_quest5_cleanup_done:
				return "villagers_ch2_cleanup_start"
			return "villagers_ch2_cleanup_repeat"
		_:
			return active_start


func _resolve_chapter2_quest1_npc_dialogue() -> String:
	if not QuestState.chapter1_summary_shown:
		return "chapter2_locked_finish_chapter1"
	if not QuestState.is_chapter2_quest1_complete():
		var quest1_title := dialogue_chapter2_start if not dialogue_chapter2_start.is_empty() else dialogue_start
		if quest1_title.is_empty():
			return "chapter2_locked_finish_quest1"
		return _resolve_chapter2_quest1_dialogue(quest1_title)
	var active_ch2_title := dialogue_chapter2_start if not dialogue_chapter2_start.is_empty() else dialogue_start
	if not QuestState.is_chapter2_quest2_complete():
		match active_ch2_title:
			"jessica_ch2_start":
				return "jessica_ch2_cleanup_done"
			"matt_ch2_start":
				if QuestState.chapter2_quest1_matt_done:
					return "matt_ch2_repeat"
				return "matt_ch2_start"
			"kai_ch2_start":
				return "chapter2_locked_finish_quest2"
		return "chapter2_locked_finish_quest2"
	if not QuestState.chapter2_quest3_warehouse_done:
		if dialogue_chapter2_after_quest2.is_empty():
			return "chapter2_locked_finish_quest3"
		return _resolve_chapter2_quest3_dialogue(dialogue_chapter2_after_quest2)
	if not QuestState.chapter2_quest4_meeting_done:
		return "chapter2_locked_finish_quest4"
	if not QuestState.chapter2_quest5_cleanup_done:
		return "chapter2_locked_finish_quest4"
	return dialogue_chapter2_start if not dialogue_chapter2_start.is_empty() else dialogue_start


func _resolve_chapter2_quest1_dialogue(quest1_title: String) -> String:
	if quest1_title.begins_with("kai_ch2"):
		return "chapter2_locked_finish_quest1"
	match quest1_title:
		"matt_ch2_start":
			if not QuestState.chapter2_beach_cleanup_done:
				return "chapter2_locked_finish_beach_cleanup"
			if QuestState.chapter2_quest1_matt_done:
				return "matt_ch2_repeat"
			return "matt_ch2_start"
		"jessica_ch2_start":
			if QuestState.chapter2_beach_cleanup_done:
				return "jessica_ch2_cleanup_done"
			if QuestState.chapter2_beach_cleanup_started:
				return "jessica_ch2_repeat"
			return "jessica_ch2_start"
	return quest1_title


func _resolve_chapter2_quest3_dialogue(quest3_title: String) -> String:
	match quest3_title:
		"matt_ch2_quest3_start":
			if QuestState.chapter2_quest3_matt_done:
				return "matt_ch2_quest3_repeat"
			if QuestState.chapter2_quest3_kai_done:
				return "matt_ch2_quest3_finish"
			return "matt_ch2_quest3_start"
		"kai_ch2_quest3_start":
			if QuestState.chapter2_quest3_kai_done:
				return "kai_ch2_quest3_repeat"
			if QuestState.chapter2_quest3_matt_done:
				return "kai_ch2_quest3_finish"
			return "kai_ch2_quest3_start"
	return quest3_title


func _resolve_active_dialogue_start() -> String:
	if _is_chapter3_unlocked() and not dialogue_chapter3_start.is_empty():
		return dialogue_chapter3_start
	if _is_on_chapter2_map() and QuestState.chapter1_summary_shown and not dialogue_chapter2_start.is_empty():
		return dialogue_chapter2_start
	return dialogue_start


func _is_on_chapter2_map() -> bool:
	var scene := get_tree().current_scene
	return scene != null and scene.scene_file_path == CHAPTER_2_SCENE


func _villagers_title_after_quest5() -> String:
	return "villagers_quest5_repeat"


func _is_chapter3_unlocked() -> bool:
	return QuestState.is_chapter0_complete() and QuestState.chapter1_summary_shown and QuestState.chapter2_summary_shown
