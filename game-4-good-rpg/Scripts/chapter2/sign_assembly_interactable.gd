extends Area2D

signal puzzle_requested

const PLAYER_INTERACTION_LAYER := 16
const WORLD_COLLISION_LAYER := 1
const SIGN_TEXTURE := preload("res://Assets/Chapter2/incomplete_coast_sign.png")
const SIGN_DISPLAY_SCALE := Vector2(0.38, 0.38)
## Physical blocker around the sign sprite (world layer 1).
const SIGN_BODY_SIZE := Vector2(220, 340)
const SIGN_BODY_OFFSET := Vector2(0, 10)
## Larger than the sprite so Space interaction is easier to trigger.
const INTERACTION_RADIUS := 170.0

@onready var incomplete_sign: Node2D = $IncompleteSign
@onready var completed_sign: Node2D = $CompletedSign
@onready var incomplete_sprite: Sprite2D = $IncompleteSign/SignSprite
@onready var completed_sprite: Sprite2D = $CompletedSign/SignSprite
@onready var sign_body: StaticBody2D = $SignCollider
@onready var sign_body_shape: CollisionShape2D = $SignCollider/CollisionShape2D
@onready var interaction_shape: CollisionShape2D = $InteractionCollision
@onready var hint_panel: Control = $TalkHintLayer/TalkHintPanel
@onready var hint_label: Label = $TalkHintLayer/TalkHintPanel/TalkHintLabel

var _player_near := false
var _available := false
var _completed := false


func _ready() -> void:
	collision_mask = 1
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	_setup_sign_sprites()
	_setup_collision_shapes()
	_refresh_visual_state()


func _setup_sign_sprites() -> void:
	if SIGN_TEXTURE == null:
		push_warning("SignAssemblyInteractable: missing sign texture at res://Assets/Chapter2/incomplete_coast_sign.png")
		return
	incomplete_sprite.texture = SIGN_TEXTURE
	completed_sprite.texture = SIGN_TEXTURE
	incomplete_sprite.scale = SIGN_DISPLAY_SCALE
	completed_sprite.scale = SIGN_DISPLAY_SCALE
	_fit_collision_to_sprite()


func _setup_collision_shapes() -> void:
	var body_rect := RectangleShape2D.new()
	body_rect.size = SIGN_BODY_SIZE
	sign_body_shape.shape = body_rect
	sign_body_shape.position = SIGN_BODY_OFFSET

	var interact_circle := CircleShape2D.new()
	interact_circle.radius = INTERACTION_RADIUS
	interaction_shape.shape = interact_circle


func _fit_collision_to_sprite() -> void:
	if SIGN_TEXTURE == null:
		return
	var tex_size := SIGN_TEXTURE.get_size() * SIGN_DISPLAY_SCALE
	var body_size := Vector2(tex_size.x * 0.88, tex_size.y * 0.82)
	var body_rect := sign_body_shape.shape as RectangleShape2D
	if body_rect != null:
		body_rect.size = body_size
		sign_body_shape.position = Vector2(0, tex_size.y * 0.04)

	var interact_circle := interaction_shape.shape as CircleShape2D
	if interact_circle != null:
		interact_circle.radius = maxf(tex_size.length() * 0.42, INTERACTION_RADIUS)


func set_sign_state(available: bool, completed: bool) -> void:
	_available = available
	_completed = completed
	_refresh_visual_state()


func action() -> void:
	if not _available or _completed or not _player_near:
		return
	puzzle_requested.emit()


func _refresh_visual_state() -> void:
	var show_sign := _available or _completed
	visible = show_sign
	incomplete_sign.visible = _available and not _completed
	completed_sign.visible = _completed

	var can_interact := _available and not _completed
	monitoring = can_interact
	monitorable = can_interact
	collision_layer = PLAYER_INTERACTION_LAYER if can_interact else 0

	sign_body.set_deferred("collision_layer", WORLD_COLLISION_LAYER if show_sign else 0)
	sign_body.visible = show_sign

	if not can_interact:
		_player_near = false
		hint_panel.visible = false


func _on_area_entered(area: Area2D) -> void:
	if not _available or _completed:
		return
	if area.is_in_group("player_interaction_area"):
		_player_near = true
		hint_panel.visible = true
		hint_label.text = "Press Space to assemble the sign"


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_interaction_area"):
		_player_near = false
		hint_panel.visible = false
