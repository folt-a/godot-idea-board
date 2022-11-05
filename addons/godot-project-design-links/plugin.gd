@tool
extends EditorPlugin

@onready var godot_sekkei = godot_sekkei_path.instantiate()
var godot_sekkei_path = preload("res://addons/godot-project-design-links/sekkei_main.tscn")

func _ready():
	init()

func _enter_tree():
	get_tree().set_meta("__editor_interface", get_editor_interface())
	get_tree().set_meta("__undo_redo", get_undo_redo())

func init():
	godot_sekkei.visible = false
	get_editor_interface().get_editor_main_screen().add_child(godot_sekkei)
	godot_sekkei.resource_previewer = get_editor_interface().get_resource_previewer()
	godot_sekkei.editor_interface = get_editor_interface()
	godot_sekkei.undo_redo = get_undo_redo()
	godot_sekkei.init()

func _exit_tree():
	get_editor_interface().get_editor_main_screen().remove_child(godot_sekkei)
	godot_sekkei.queue_free()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F4:
#		if event.pressed and event.scancode == KEY_SPACE && event.control:
			get_editor_interface().set_main_screen_editor("Design")


func _has_main_screen():
	return true


func _get_plugin_name():
	return "Design"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().theme.get_icon("GraphEdit", "EditorIcons")


func _make_visible(visible):
	godot_sekkei.visible = visible
	if visible:
		godot_sekkei.show()


func _apply_changes():
	godot_sekkei.save()


func _save_external_data():
#	godot_sekkei.save()
	pass
