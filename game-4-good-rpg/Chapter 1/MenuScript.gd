extends CanvasLayer

@onready var settings_button = $SettingsButton
@onready var settings_menu = $SettingsMenu
@onready var volume_slider = $SettingsMenu/VolumeSlider
var music_player: AudioStreamPlayer
var player: Node2D

var menu_open := false
var _settings_input_locked := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	settings_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	music_player = get_parent().get_node_or_null("MusicPlayer") as AudioStreamPlayer
	player = _resolve_player()
	# Start with menu hidden
	settings_menu.visible = false
	load_settings()
	# Optional: set default volume
	AudioServer.set_bus_volume_db(0, volume_slider.value)

func _set_settings_menu_open(open: bool) -> void:
	menu_open = open
	settings_menu.visible = open
	get_tree().paused = open
	if open:
		if not _settings_input_locked:
			QuestState.push_interaction_input_lock()
			_settings_input_locked = true
	elif _settings_input_locked:
		QuestState.pop_interaction_input_lock()
		_settings_input_locked = false

# 🔘 When settings button is pressed
func _on_settings_button_pressed():
	_set_settings_menu_open(not menu_open)

# 🔊 When volume slider changes
func _on_volume_slider_value_changed(value):
	if value <= -40:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, value)


func _on_close_pressed():
	_set_settings_menu_open(false)


func _on_change_skin_pressed() -> void:
	if player:
		player.cycle_skin()
		player.save_current_skin()


func _on_save_pressed() -> void:
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("audio", "volume", volume_slider.value)
	if player:
		config.set_value("player", "skin", player.current_skin_index)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		volume_slider.value = config.get_value("audio", "volume", 0)

func _resolve_player() -> Node2D:
	var scene := get_tree().current_scene
	if scene == null:
		return null
	var found: Node2D = scene.get_node_or_null("Player") as Node2D
	if found == null:
		found = scene.get_node_or_null("CharacterBody2D") as Node2D
	return found
