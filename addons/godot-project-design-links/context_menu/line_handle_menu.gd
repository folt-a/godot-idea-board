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
signal changed_color(s)

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const INDEX_LOCK:int = 0
const INDEX_COPY:int = 1
const INDEX_DELETE:int = 2
const SEPARATE_1:int = 3
const INDEX_COLOR_WHITE:int = 4
const INDEX_COLOR_BLACK:int = 5

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
	add_icon_item(_parent.get_icon("Duplicate"), _S.tr("Copy only this"), INDEX_COPY)
	add_icon_item(_parent.get_icon("Remove"), _S.tr("Delete"), INDEX_DELETE)
	add_separator("", SEPARATE_1)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Color White"), INDEX_COLOR_WHITE)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Color Black"), INDEX_COLOR_BLACK)

func _on_index_pressed(index:int):
	match index:
		INDEX_LOCK:# めんどくさいので外からOFFにもする
			set_item_checked(INDEX_LOCK,!is_item_checked(INDEX_LOCK))
			toggle_lock_selected.emit(is_item_checked(INDEX_LOCK))
		INDEX_COPY:
			copied.emit()
		INDEX_DELETE:
			deleted.emit()
		INDEX_COLOR_WHITE:
			changed_color.emit("White")
		INDEX_COLOR_BLACK:
			changed_color.emit("Black")

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

