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
signal toggle_play_scene_selected
signal filepath_copied
signal make_edit
signal add_files_in_dir
signal add_files_recursive_in_dir

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------
enum ITEM_TYPE{
	DIR,
	SCENE,
	SCRIPT,
	TEXTURE,
	SOUND,
	RESOURCE,
	TEXT,
	DIALOGIC_TIMELINE,
	DIALOGIC_CHARA,
	NONE
}
#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const INDEX_LOCK:int = 0
const INDEX_LINK:int = 1
const INDEX_COPY:int = 2
const INDEX_DELETE:int = 3
const SEPARATE_1:int = 4
const INDEX_COPY_PATH:int = 5

const INDEX_SCENE_PLAY:int = 6

const INDEX_EDIT:int = 6

const INDEX_DIALOGIC_TIMELINE_PLAY:int = 6
const INDEX_DIALOGIC_EDIT:int = 7

const INDEX_ADD_FILES_IN_DIR:int = 6
const INDEX_ADD_FILES_RECURSIVE_IN_DIR:int = 7

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _item_type:int

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

func init(item_type:int):
	self._item_type = item_type
	add_icon_check_item(_parent.get_icon("Lock"), _S.tr("Lock"), INDEX_LOCK)
	add_icon_item(_parent.get_icon("SphereShape3D"), _S.tr("Copy Link"), INDEX_LINK)
	add_icon_item(_parent.get_icon("Duplicate"), _S.tr("Copy only this"), INDEX_COPY)
	add_icon_item(_parent.get_icon("Remove"), _S.tr("Delete"), INDEX_DELETE)
	add_separator("", SEPARATE_1)
	add_icon_item(_parent.get_icon("Duplicate"), _S.tr("Copy Path"), INDEX_COPY_PATH)
	match item_type:
		ITEM_TYPE.DIR:
			add_icon_item(_parent.get_icon("Folder"), _S.tr("Make Files"), INDEX_ADD_FILES_IN_DIR)
#			add_icon_item(_parent.get_icon("Folder"), _S.tr("Make Files Recursive"), INDEX_ADD_FILES_IN_DIR) TODO 再帰！
		ITEM_TYPE.SCENE:
			add_icon_check_item(_parent.get_icon("PlayScene"), _S.tr("Show Play Scene Button"), INDEX_SCENE_PLAY)
		ITEM_TYPE.SCRIPT:
			add_icon_item(_parent.get_icon("Edit"), _S.tr("Make TxtDoc"), INDEX_EDIT)
		ITEM_TYPE.TEXTURE:
			pass
		ITEM_TYPE.SOUND:
			pass
		ITEM_TYPE.TEXT:
			add_icon_item(_parent.get_icon("Edit"), _S.tr("Make TxtDoc"), INDEX_EDIT)
		ITEM_TYPE.DIALOGIC_TIMELINE:
#			add_icon_check_item(_parent.get_icon("PlayScene"), _S.tr("Play Dialogic Timeline"), INDEX_DIALOGIC_TIMELINE_PLAY)
			add_separator("",INDEX_DIALOGIC_TIMELINE_PLAY)
			add_icon_item(_parent.get_icon("Edit"), _S.tr("Make TxtDoc"), INDEX_DIALOGIC_EDIT)
		_:
			pass


func _on_index_pressed(index:int):
	match index:
		INDEX_LOCK:# めんどくさいので外からOFFにもする
			set_item_checked(INDEX_LOCK,!is_item_checked(INDEX_LOCK))
			toggle_lock_selected.emit(is_item_checked(INDEX_LOCK))
		INDEX_LINK:
			var data = [{
				"node" : "Link",
				"position_offset_x" : 0,
				"position_offset_y" : 0,
				"id" : get_instance_id(),
				"name" : get_parent().tscn_label.text,
				"target_id" : get_parent().id,
				"target_icon" : get_parent().icon_name,
				"graph_path" : get_parent().get_parent().save_json_file_path
			}]
			DisplayServer.clipboard_set(JSON.stringify(data))
		INDEX_COPY:
			copied.emit()
		INDEX_DELETE:
			deleted.emit()
	match _item_type:
		ITEM_TYPE.DIR:
			match index:
				INDEX_ADD_FILES_IN_DIR:
					add_files_in_dir.emit()
				INDEX_ADD_FILES_RECURSIVE_IN_DIR:
					add_files_recursive_in_dir.emit()
		ITEM_TYPE.SCENE:
			match index:
				INDEX_SCENE_PLAY:
					set_item_checked(INDEX_SCENE_PLAY,!is_item_checked(INDEX_SCENE_PLAY))
					toggle_play_scene_selected.emit(is_item_checked(INDEX_SCENE_PLAY))
		ITEM_TYPE.SCRIPT:
			match index:
				INDEX_EDIT:
					make_edit.emit()
		ITEM_TYPE.TEXTURE:
			pass
		ITEM_TYPE.SOUND:
			pass
		ITEM_TYPE.TEXT:
			match index:
				INDEX_EDIT:
					make_edit.emit()
		ITEM_TYPE.DIALOGIC_TIMELINE:
			match index:
				INDEX_DIALOGIC_TIMELINE_PLAY:
					set_item_checked(INDEX_DIALOGIC_TIMELINE_PLAY,!is_item_checked(INDEX_DIALOGIC_TIMELINE_PLAY))
					toggle_play_scene_selected.emit(is_item_checked(INDEX_DIALOGIC_TIMELINE_PLAY))
				INDEX_DIALOGIC_EDIT:
					make_edit.emit()
		_:
			pass



#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func set_scene_play_check(is_pressed:bool):
	match _item_type:
		ITEM_TYPE.SCENE:
			set_item_checked(INDEX_SCENE_PLAY,is_pressed)
		ITEM_TYPE.DIALOGIC_TIMELINE:
			set_item_checked(INDEX_DIALOGIC_TIMELINE_PLAY,is_pressed)
		_:
			pass

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

