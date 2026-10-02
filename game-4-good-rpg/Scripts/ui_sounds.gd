extends Node

const HOVER_SOUND: AudioStream = preload("res://Music/Hover.mp3")
const CLICK_SOUND: AudioStream = preload("res://Music/Click.mp3")
const SFX_BUS := "SFX"
const VOLUME := 0.4 # 40%

var _hover_player: AudioStreamPlayer
var _click_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # keeps playing while the game is paused
	_hover_player = _make_player(HOVER_SOUND)
	_click_player = _make_player(CLICK_SOUND)
	get_tree().node_added.connect(_on_node_added)
	_hook_existing(get_tree().root)


func _make_player(stream: AudioStream) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = SFX_BUS
	player.volume_db = linear_to_db(VOLUME)
	add_child(player)
	return player


func _hook_existing(node: Node) -> void:
	for child in node.get_children():
		_on_node_added(child)
		_hook_existing(child)


func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		_hook_button(node)


func _hook_button(button: BaseButton) -> void:
	if button.has_meta("ui_sounds_hooked"):
		return
	button.set_meta("ui_sounds_hooked", true)
	button.mouse_entered.connect(_play_hover.bind(button))
	button.pressed.connect(_play_click)


func _play_hover(button: BaseButton) -> void:
	if not button.disabled:
		_hover_player.play()


func _play_click() -> void:
	_click_player.play()
