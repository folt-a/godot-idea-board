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
signal edit_title_selected
signal checked(is_enabled)
signal save_pressed
signal changed_color(s)
signal changed_sub_color(color:Color)
signal deleted_sub_color()

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
const INDEX_COLOR:int = 5
const INDEX_EDIT:int = 6
const INDEX_CHECK:int = 7
const INDEX_SAVE:int = 8
const INDEX_BG_TR_LI:int = 9
const INDEX_BG_TR_DA:int = 10
const INDEX_BG_LI:int = 11
const INDEX_BG_DA:int = 12

const SUB_INDEX_REMOVE:int = 0
const SUB_INDEX_BLACK:int = 1
const SUB_INDEX_WHITE:int = 2
const SUB_INDEX_RED:int = 3
const SUB_INDEX_ORANGE:int = 4
const SUB_INDEX_YELLOW:int = 5
const SUB_INDEX_GREEN:int = 6
const SUB_INDEX_BLUE:int = 7
const SUB_INDEX_PURPLE:int = 8
const SUB_INDEX_CUSTOM:int = 9

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
@onready var parent:GraphNode = get_parent()

@onready var _S = preload("res://addons/godot-idea-board/translation/translation.gd").get_translation_singleton(self)
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var sub_color_menu:PopupMenu = $ColorMenu
@onready var color_picker_control:Control = %ColorPickerControl
@onready var color_picker:ColorPicker = %ColorPicker
@onready var color_fix_button:Button = %ColorFixButton

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

	sub_color_menu.add_icon_item(_parent.get_icon("Remove"),_S.tr("Delete"),0)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.BLACK),_S.tr("Black"),SUB_INDEX_BLACK)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.WHITE),_S.tr("White"),SUB_INDEX_WHITE)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.RED),_S.tr("Red"),SUB_INDEX_RED)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.ORANGE),_S.tr("Orange"),SUB_INDEX_ORANGE)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.YELLOW),_S.tr("Yellow"),SUB_INDEX_YELLOW)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.GREEN),_S.tr("Green"),SUB_INDEX_GREEN)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.BLUE),_S.tr("Blue"),SUB_INDEX_BLUE)
	sub_color_menu.add_icon_item(_parent.get_color_rect_image(Color.PURPLE),_S.tr("Purple"),SUB_INDEX_PURPLE)
	sub_color_menu.add_icon_item(_parent.get_icon("CanvasItemMaterial"),_S.tr("Custom"),SUB_INDEX_CUSTOM)
	add_submenu_item(_S.tr("Color"),"ColorMenu",INDEX_COLOR)
	sub_color_menu.index_pressed.connect(_on_index_pressed_sub_color)
	color_fix_button.pressed.connect(_on_pressed_color_fix_button)

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

func _on_index_pressed_sub_color(index:int):
	var color:Color
	match index:
		SUB_INDEX_REMOVE:
			deleted_sub_color.emit()
			return
		SUB_INDEX_BLACK:
			color = Color.BLACK
		SUB_INDEX_WHITE:
			color = Color.WHITE
		SUB_INDEX_RED:
			color = Color.RED
		SUB_INDEX_ORANGE:
			color = Color.ORANGE
		SUB_INDEX_YELLOW:
			color = Color.YELLOW
		SUB_INDEX_GREEN:
			color = Color.GREEN
		SUB_INDEX_BLUE:
			color = Color.BLUE
		SUB_INDEX_PURPLE:
			color = Color.PURPLE
		SUB_INDEX_CUSTOM:
			color_picker_control.position = Vector2(parent.margin_container.size.x / 2, -parent.margin_container.size.y)
			color_picker_control.visible = true
	changed_sub_color.emit(color)

func _on_pressed_color_fix_button():
	changed_sub_color.emit(color_picker.color)
	color_picker_control.visible = false

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

