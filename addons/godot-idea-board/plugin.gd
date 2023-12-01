@tool
extends EditorPlugin

@onready var godot_sekkei = godot_sekkei_path.instantiate()
var godot_sekkei_path = preload("res://addons/godot-idea-board/sekkei_main.tscn")

func _enter_tree():
	get_tree().set_meta("__editor_interface", get_editor_interface())

func _ready():
	init()

func init():
	godot_sekkei.visible = false
#	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, godot_sekkei)
#	add_control_to_bottom_panel(godot_sekkei,"BottomPanelPlugin")
#	godot_sekkei.name = "DockPlugin"
#	add_tool_menu_item("ToolPlugin",func():return)
#	add_tool_submenu_item("ToolSubPlugin", PopupMenu.new())

	get_editor_interface().get_editor_main_screen().add_child(godot_sekkei)
	godot_sekkei.resource_previewer = get_editor_interface().get_resource_previewer()
	godot_sekkei.editor_interface = get_editor_interface()
	godot_sekkei.init()

func _exit_tree():
	get_editor_interface().get_editor_main_screen().remove_child(godot_sekkei)
	godot_sekkei.queue_free()


func _has_main_screen():
	return true


func _get_plugin_name():
	return "Board"

func _get_plugin_icon():
	return get_editor_interface().get_editor_theme().get_icon("Panel", "EditorIcons")


func _make_visible(visible):
	godot_sekkei.visible = visible
	if visible:
		godot_sekkei.show()


func _apply_changes():
	godot_sekkei.save()


func _save_external_data():
#	godot_sekkei.save()
	pass
