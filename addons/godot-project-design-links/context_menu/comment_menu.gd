#01. tool
@tool
#02. class_name

#03. extends
extends "res://addons/godot-project-design-links/context_menu/menu_base.gd"
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal toggle_lock_selected(is_enabled)
signal copied
signal deleted
signal edit_title_selected
signal checked(is_enabled)
signal save_pressed
signal changed_color(s)

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const INDEX_LOCK:int = 0
const INDEX_LINK:int = 1
const INDEX_COPY:int = 2
const INDEX_DELETE:int = 3
const SEPARATE_1:int = 4
const INDEX_EDIT:int = 5
const INDEX_CHECK:int = 6
const INDEX_SAVE:int = 7
const INDEX_BG_TR_LI:int = 8
const INDEX_BG_TR_DA:int = 9
const INDEX_BG_LI:int = 10
const INDEX_BG_DA:int = 11

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
@onready var parent = get_parent()

@onready var _S = preload("res://addons/godot-project-design-links/translation/translation.gd").get_translation_singleton(self)
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func _ready():
	super()
	add_icon_check_item(_parent.get_icon("Lock"), _S.tr("Lock"), INDEX_LOCK)
	add_icon_item(_parent.get_icon("SphereShape3D"), _S.tr("Copy Link"), INDEX_LINK)
	add_icon_item(_parent.get_icon("Duplicate"), _S.tr("Copy only this"), INDEX_COPY)
	add_icon_item(_parent.get_icon("Remove"), _S.tr("Delete"), INDEX_DELETE)
	add_separator("", SEPARATE_1)
	add_icon_item(_parent.get_icon("Edit"), _S.tr("Edit Title"), INDEX_EDIT)
	if parent.path != "":
		add_separator("",INDEX_CHECK)
		add_icon_item(_parent.get_icon("Save"), _S.tr("Save"), INDEX_SAVE)
	else:
		add_icon_check_item(_parent.get_icon("CheckBox"), _S.tr("Task"), INDEX_CHECK)
		add_separator("",INDEX_SAVE)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Bg Transparent Light"), INDEX_BG_TR_LI)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Bg Transparent Dark"), INDEX_BG_TR_DA)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Bg Light"), INDEX_BG_LI)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Bg Dark"), INDEX_BG_DA)


func _on_index_pressed(index:int):
	match index:
		INDEX_LOCK:#"Lock" めんどくさいので外からOFFにもすることにする
			set_item_checked(INDEX_LOCK,!is_item_checked(INDEX_LOCK))
			toggle_lock_selected.emit(is_item_checked(INDEX_LOCK))
		INDEX_LINK:#"Copy Link"
			var data = [{
				"node" : "Link",
				"position_offset_x" : 0,
				"position_offset_y" : 0,
				"id" : get_instance_id(),
				"name" : parent.header_line_edit.text,
				"target_id" : parent.id,
				"target_icon" : parent.icon_name,
				"graph_path" : parent.get_parent().save_json_file_path
			}]
			DisplayServer.clipboard_set(JSON.stringify(data))
		INDEX_COPY:
			copied.emit()
		INDEX_DELETE:
			deleted.emit()
		INDEX_EDIT:#"Edit Title"
			edit_title_selected.emit()
		INDEX_CHECK:
			set_item_checked(INDEX_CHECK,!is_item_checked(INDEX_CHECK))
			checked.emit(is_item_checked(INDEX_CHECK))
		INDEX_SAVE:#"Save"
			save_pressed.emit()
		INDEX_BG_TR_LI:# Bg Transparent Light
			changed_color.emit("TrLight")
		INDEX_BG_TR_DA:# Bg Transparent Dark
			changed_color.emit("TrDark")
		INDEX_BG_LI:# Bg Light
			changed_color.emit("Light")
		INDEX_BG_DA:# Bg Dark
			changed_color.emit("Dark")

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

