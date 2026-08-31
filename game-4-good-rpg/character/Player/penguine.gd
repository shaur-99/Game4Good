extends CharacterBody2D

const SPEED = 250.0
const ANIM_IDLE := "16 Idle"
const ANIM_RUN_EAST := "Run East"
const ANIM_RUN_NORTH := "Run North"
const ANIM_RUN_SOUTH := "Run South"
const ANIM_RUN_NE := "Run NorthEast"
const ANIM_RUN_SE := "Run SouthEast"

var is_in_dialogue := false

@onready var sprite: AnimatedSprite2D = $Penguine
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group("player")
	actionable_finder.add_to_group("player_interaction_area")
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _is_input_blocked() -> bool:
	return is_in_dialogue or QuestState.is_story_guide_blocking_input()


func _unhandled_input(_event: InputEvent) -> void:
	if _is_input_blocked():
		return

	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func _physics_process(_delta: float) -> void:
	if _is_input_blocked():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	velocity = input_vector * SPEED
	move_and_slide()

	_update_sprite_for_input(input_vector)

func _update_sprite_for_input(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO:
		sprite.flip_h = false
		if String(sprite.animation) != ANIM_IDLE:
			sprite.play(ANIM_IDLE)
		return

	var x := input_vector.x
	var y := input_vector.y
	var abs_x := absf(x)
	var abs_y := absf(y)

	if abs_x > 0.35 and abs_y > 0.35:
		var want_flip := x < 0.0
		if y < 0.0:
			if String(sprite.animation) != ANIM_RUN_NE or sprite.flip_h != want_flip:
				sprite.flip_h = want_flip
				sprite.play(ANIM_RUN_NE)
		else:
			if String(sprite.animation) != ANIM_RUN_SE or sprite.flip_h != want_flip:
				sprite.flip_h = want_flip
				sprite.play(ANIM_RUN_SE)
	elif abs_x > abs_y:
		var want_flip := x < 0.0
		if String(sprite.animation) != ANIM_RUN_EAST or sprite.flip_h != want_flip:
			sprite.flip_h = want_flip
			sprite.play(ANIM_RUN_EAST)
	else:
		sprite.flip_h = false
		if y < 0.0:
			_play_if_needed(ANIM_RUN_NORTH)
		else:
			_play_if_needed(ANIM_RUN_SOUTH)

func _play_if_needed(anim_name: String) -> void:
	if String(sprite.animation) != anim_name:
		sprite.play(anim_name)

func _on_dialogue_started(_resource) -> void:
	is_in_dialogue = true
	sprite.flip_h = false
	sprite.play(ANIM_IDLE)

func _on_dialogue_ended(_resource) -> void:
	is_in_dialogue = false
