#01. tool
@tool
#02. class_name

#03. extends
extends "res://addons/godot-idea-board/context_menu/menu_base.gd"
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal toggle_lock_selected(is_enabled)
signal copied
signal deleted
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

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
@onready var _S = preload("res://addons/godot-idea-board/translation/translation.gd").get_translation_singleton(self)
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

func _on_index_pressed(index:int):
	match index:
		INDEX_LOCK:#"Lock" めんどくさいので外からOFFにもすることにする
			set_item_checked(INDEX_LOCK,!is_item_checked(INDEX_LOCK))
			toggle_lock_selected.emit(is_item_checked(INDEX_LOCK))
		INDEX_LINK:# Copy Link
			var data = [{
				"node" : "Link",
				"position_offset_x" : 0,
				"position_offset_y" : 0,
				"id" : get_instance_id(),
				"name" : get_parent().target_line_edit.text,
				"target_id" : get_parent().id,
				"target_icon" : "SphereShape3D",
				"graph_path" : get_parent().get_parent().save_json_file_path
			}]
			DisplayServer.clipboard_set(JSON.stringify(data))
		INDEX_COPY:
			copied.emit()
		INDEX_DELETE:
			deleted.emit()
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

