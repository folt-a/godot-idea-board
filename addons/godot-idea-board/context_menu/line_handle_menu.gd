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
signal added_point
signal removed_point
signal changed_color(s)
signal toggle_hide_editable_text(is_hide)
signal toggle_show_arrow_from(is_enabled)
signal toggle_show_arrow_to(is_enabled)

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
const INDEX_ADD_POINT:int = 4
#const INDEX_REMOVE_POINT:int = 5
const SEPARATE_2:int = 5
const INDEX_COLOR_WHITE:int = 6
const INDEX_COLOR_BLACK:int = 7
const SEPARATE_3:int = 8
const INDEX_IS_SHOW_EDITABLE_TEXT:int = 9
const SEPARATE_4:int = 10
const INDEX_IS_SHOW_ARROW_FROM:int = 11
const INDEX_IS_SHOW_ARROW_TO:int = 12
const SEPARATE_5:int = 13
const INDEX_ARROW_TYPE_NORMAL:int = 14

const arrow_icon = preload("res://addons/godot-idea-board/icon/arrow_normal.svg")
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
	add_icon_item(_parent.get_icon("Duplicate"), _S.tr("Copy only this"), INDEX_COPY)
	add_icon_item(_parent.get_icon("Remove"), _S.tr("Delete"), INDEX_DELETE)
	add_separator("", SEPARATE_1)
	add_icon_item(_parent.get_icon("Add"), _S.tr("Add Point"), INDEX_ADD_POINT)
#	add_icon_item(_parent.get_icon("Remove"), _S.tr("Remove Point"), INDEX_REMOVE_POINT)
	add_separator("", SEPARATE_2)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Color White"), INDEX_COLOR_WHITE)
	add_icon_item(_parent.get_icon("Color"),_S.tr("Color Black"), INDEX_COLOR_BLACK)
	add_separator("", SEPARATE_3)
	add_icon_check_item(_parent.get_icon("TextEdit"),_S.tr("Hide Editable Text"), INDEX_IS_SHOW_EDITABLE_TEXT)
	add_separator("", SEPARATE_4)
	add_icon_check_item(_parent.get_icon("ArrowLeft"),_S.tr("Arrow From"), INDEX_IS_SHOW_ARROW_FROM)
	add_icon_check_item(_parent.get_icon("ArrowRight"),_S.tr("Arrow To"), INDEX_IS_SHOW_ARROW_TO)
	add_separator("", SEPARATE_5)
	add_icon_radio_check_item(arrow_icon,_S.tr("Arrow Type Normal"), INDEX_ARROW_TYPE_NORMAL)

func _on_index_pressed(index:int):
	match index:
		INDEX_LOCK:# めんどくさいので外からOFFにもする
			set_item_checked(INDEX_LOCK,!is_item_checked(INDEX_LOCK))
			toggle_lock_selected.emit(is_item_checked(INDEX_LOCK))
		INDEX_ADD_POINT:
			added_point.emit()
#		INDEX_REMOVE_POINT:
#			removed_point.emit()
		INDEX_COPY:
			copied.emit()
		INDEX_DELETE:
			deleted.emit()
		INDEX_COLOR_WHITE:
			changed_color.emit("White")
		INDEX_COLOR_BLACK:
			changed_color.emit("Black")
		INDEX_IS_SHOW_EDITABLE_TEXT:
			set_item_checked(INDEX_IS_SHOW_EDITABLE_TEXT,!is_item_checked(INDEX_IS_SHOW_EDITABLE_TEXT))
			toggle_hide_editable_text.emit(is_item_checked(INDEX_IS_SHOW_EDITABLE_TEXT))
		INDEX_IS_SHOW_ARROW_FROM:# めんどくさいので外からOFFにもする
			set_item_checked(INDEX_IS_SHOW_ARROW_FROM,!is_item_checked(INDEX_IS_SHOW_ARROW_FROM))
			toggle_show_arrow_from.emit(is_item_checked(INDEX_IS_SHOW_ARROW_FROM))
		INDEX_IS_SHOW_ARROW_TO:# めんどくさいので外からOFFにもする
			set_item_checked(INDEX_IS_SHOW_ARROW_TO,!is_item_checked(INDEX_IS_SHOW_ARROW_TO))
			toggle_show_arrow_to.emit(is_item_checked(INDEX_IS_SHOW_ARROW_TO))
		INDEX_ARROW_TYPE_NORMAL:# めんどくさいので外からOFFにもする
			set_item_checked(INDEX_ARROW_TYPE_NORMAL,!is_item_checked(INDEX_ARROW_TYPE_NORMAL))
			toggle_show_arrow_to.emit(is_item_checked(INDEX_ARROW_TYPE_NORMAL))


#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

