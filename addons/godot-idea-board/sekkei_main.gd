#01. tool
@tool
#02. class_name

#03. extends
extends HSplitContainer
#-----------------------------------------------------------
#04. # docstring
## GraphEditの初期化とサイドバーの処理

#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------
enum DIALOG_TYPE{
	ADD,
	DUPLICATE,
	RENAME,
	REMOVE_CONFIRM,
	SAVE_CONFIRM
}
#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------


#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var resource_previewer:EditorResourcePreview
var editor_interface:EditorInterface

var save_json_dir_path:String = ""

@onready var audio_stream_player = $AudioStreamPlayer

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
@onready var _S = preload("res://addons/godot-idea-board/translation/translation.gd").get_translation_singleton(self)

var _is_left:bool = true

var _left_selected_text:String = ""
var _right_selected_text:String = ""

var _selected_index:int = -1
var _dialog_type:int = 0

var _confirmed_exec:Callable
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var no_data_reference_rect = $HSplitContainer/NoDataReferenceRect
@onready var sekkei_graph_1 = %SekkeiGraph1
@onready var sekkei_graph_2 = %SekkeiGraph2
@onready var sekkei_graph_3 = %SekkeiGraph3
@onready var window:Window = $Window

@onready var sidebar_v_box_container = %SidebarVBoxContainer

@onready var window_button:Button = %WindowButton
@onready var split_button:Button = %SplitButton
@onready var left_button:Button = %LeftButton
@onready var right_button:Button = %RightButton
@onready var reload_button:Button = %ReloadButton

@onready var add_button:Button = %AddButton
@onready var duplicate_button:Button = %DuplicateButton
@onready var rename_button:Button = %RenameButton
@onready var remove_button:Button = %RemoveButton

@onready var saved_item_list:ItemList = %SavedItemList

@onready var main_path_edit_button:Button = %MainPathEditButton
@onready var main_path_line_edit:LineEdit = %MainPathLineEdit


@onready var file_name_dialog:ConfirmationDialog = %FileNameDialog
@onready var file_name_line_edit:LineEdit = %FileNameLineEdit
@onready var file_name_label:Label = %FileNameLabel
@onready var file_name_message_label:Label = %FileNameMessageLabel

@onready var confirmation_dialog:ConfirmationDialog = $ConfirmationDialog

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func _ready():
	saved_item_list.item_selected.connect(_on_item_selected)

	window_button.toggled.connect(_on_toggled_window_button)
	split_button.toggled.connect(_on_toggled_split_button)
	left_button.pressed.connect(_on_pressed_left_button)
	right_button.pressed.connect(_on_pressed_right_button)
	reload_button.pressed.connect(_on_pressed_reload_button)

	add_button.pressed.connect(_on_pressed_add_button)
	duplicate_button.pressed.connect(_on_pressed_duplicate_button)
	rename_button.pressed.connect(_on_pressed_rename_button)
	remove_button.pressed.connect(_on_pressed_remove_button)

	main_path_edit_button.pressed.connect(_on_pressed_main_path_edit_button)
	main_path_line_edit.focus_exited.connect(_on_focus_exited_main_path_line_edit)
	main_path_line_edit.text_submitted.connect(_on_text_submitted_main_path_line_edit)

	file_name_line_edit.text_changed.connect(_on_text_changed_file_name_line_edit)
	file_name_dialog.confirmed.connect(_on_confirmed_file_name_dialog)
	file_name_dialog.register_text_enter(file_name_line_edit)

	confirmation_dialog.confirmed.connect(_on_confirmed_confirmation_dialog)

	window.close_requested.connect(_on_close_requested_window)

	_translate()

func init():
	sekkei_graph_1.resource_previewer = resource_previewer
	sekkei_graph_1.editor_interface = editor_interface
	sekkei_graph_2.resource_previewer = resource_previewer
	sekkei_graph_2.editor_interface = editor_interface
	sekkei_graph_3.resource_previewer = resource_previewer
	sekkei_graph_3.editor_interface = editor_interface

	window_button.icon = sekkei_graph_1.get_icon("Window")
	left_button.icon = sekkei_graph_1.get_icon("PlayBackwards")
	right_button.icon = sekkei_graph_1.get_icon("Play")
	split_button.icon = sekkei_graph_1.get_icon("HSplitContainer")
	reload_button.icon = sekkei_graph_1.get_icon("Reload")

	main_path_edit_button.icon = sekkei_graph_1.get_icon("Edit")

	add_button.icon = sekkei_graph_1.get_icon("Add")
	duplicate_button.icon = sekkei_graph_1.get_icon("Duplicate")
	rename_button.icon = sekkei_graph_1.get_icon("Edit")
	remove_button.icon = sekkei_graph_1.get_icon("Remove")

#	メインのディレクトリパスを指定する

#	初期起動時はないので追加する
	if ProjectSettings.has_setting("godot_project_design_links/directory_path"):
		ProjectSettings.set_setting("godot_idea_board/directory_path", ProjectSettings.get_setting("godot_project_design_links/directory_path"))
		ProjectSettings.clear("godot_project_design_links/directory_path")
		ProjectSettings.clear("godot_project_design_links")
	if !ProjectSettings.has_setting("godot_idea_board/directory_path"):
		ProjectSettings.set_setting("godot_idea_board/directory_path", "res://addons/godot-idea-board/savedata/")
		var property_info = {
			"name": "godot_idea_board/directory_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
			"hint_string": ""
		}
		ProjectSettings.add_property_info(property_info)
		ProjectSettings.save()

	save_json_dir_path = ProjectSettings.get_setting("godot_idea_board/directory_path")
	main_path_line_edit.text = save_json_dir_path

	var dir = DirAccess.open("res://")
	if dir.dir_exists(save_json_dir_path):
		dir.make_dir_recursive(save_json_dir_path)

	sekkei_graph_1.init(self)
	sekkei_graph_2.init(self)
	sekkei_graph_3.init(self)
	update_saved_item_list()

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _on_item_selected(index:int):
	if _selected_index != -1:
		saved_item_list.select(_selected_index, true)
	# 編集中だったら確認ダイアログを出す
	if no_data_reference_rect.visible:
		_selected_sekkei_graph_update(index)
	elif (_is_left and sekkei_graph_1.dirty) or (!_is_left and sekkei_graph_2.dirty):
		_dialog_type = DIALOG_TYPE.SAVE_CONFIRM
		confirmation_dialog.title = _S.tr("Edited data will not be saved.")
		confirmation_dialog.dialog_text = _S.tr("Edited data will not be saved.text")
		_confirmed_exec = _selected_sekkei_graph_update.bind(index)
		confirmation_dialog.popup_centered()
	else:
		_selected_sekkei_graph_update(index)

func _on_pressed_left_button():
	_is_left = true

func _on_pressed_right_button():
	_is_left = false

func _on_toggled_window_button(button_pressed:bool):
	if button_pressed:
		var file = FileAccess.open(sekkei_graph_1.save_json_file_path,FileAccess.READ)
		var json_str = file.get_as_text()
		var datas = JSON.parse_string(json_str)
		sekkei_graph_3.save_json_file_path = sekkei_graph_1.save_json_file_path
		sekkei_graph_3.reset(datas)
		var base_size = editor_interface.get_base_control().size / 2

		var win:int = DisplayServer.window_get_current_screen()
		var pos:Vector2i = DisplayServer.window_get_position()
		window.show()
		window.position = pos + Vector2i(32,32)
		window.size = base_size
	else:
		if window.visible:
			if sekkei_graph_3.dirty:
				_dialog_type = DIALOG_TYPE.SAVE_CONFIRM
				confirmation_dialog.title = _S.tr("Edited data will not be saved.")
				confirmation_dialog.dialog_text = _S.tr("Edited data will not be saved.text")
				_confirmed_exec = _close_window
				confirmation_dialog.popup_centered()
			else:
				_close_window()


func _on_toggled_split_button(button_pressed:bool):
	_is_left = true
	if button_pressed:
		# 左右を有効化する
		left_button.disabled = false
		right_button.disabled = false
		left_button.button_pressed = true

		# 右を現在の選択で初期化
		_is_left = false
		_on_item_selected(_selected_index)
		_is_left = true

		sekkei_graph_2.visible = true

		window_button.disabled = true
	else:
		right_button.disabled = true
		left_button.disabled = true
		sekkei_graph_2.visible = false

		window_button.disabled = false

func _on_pressed_reload_button():
	save_json_dir_path = ProjectSettings.get_setting("godot_idea_board/directory_path")
	update_saved_item_list()

func _on_pressed_add_button():
	_dialog_type = DIALOG_TYPE.ADD
	file_name_dialog.title = _S.tr("Add json file.")
	file_name_dialog.dialog_text = "\n\n" + _S.tr("Add json file.")
	file_name_line_edit.text = ""
	file_name_message_label.text = ""
	file_name_dialog.popup_centered()
	_on_text_changed_file_name_line_edit(file_name_line_edit.text)
	file_name_line_edit.grab_focus()

func _on_pressed_duplicate_button():
	if _selected_index == -1: return
	save()
	file_name_dialog.title = _S.tr("Duplicate json file.")
	file_name_dialog.dialog_text = "\n\n" + _S.tr("Duplicate json file.")+"\nOrg : " + saved_item_list.get_item_metadata(_selected_index)
	file_name_line_edit.text = saved_item_list.get_item_text(_selected_index)
	file_name_message_label.text = ""
	_dialog_type = DIALOG_TYPE.DUPLICATE
	file_name_dialog.popup_centered()
	_on_text_changed_file_name_line_edit(file_name_line_edit.text)
	file_name_line_edit.grab_focus()

func _on_pressed_rename_button():
	if _selected_index == -1: return
	save()
	file_name_dialog.title = _S.tr("Rename json file.")
	file_name_dialog.dialog_text = "\n\n" + _S.tr("Rename json file.")+"\nOrg : " + saved_item_list.get_item_metadata(_selected_index)
	file_name_line_edit.text = saved_item_list.get_item_text(_selected_index)
	file_name_message_label.text = ""
	_dialog_type = DIALOG_TYPE.RENAME
	file_name_dialog.popup_centered()
	_on_text_changed_file_name_line_edit(file_name_line_edit.text)
	file_name_line_edit.grab_focus()

func _on_pressed_remove_button():
	if _selected_index == -1: return
	save()
	_dialog_type = DIALOG_TYPE.REMOVE_CONFIRM
	confirmation_dialog.title = _S.tr("Delete json file.")
	confirmation_dialog.dialog_text = _S.tr("Delete json file.")
	confirmation_dialog.popup_centered()


func _on_pressed_main_path_edit_button():
	main_path_edit_button.release_focus()
	main_path_line_edit.editable = true
	main_path_line_edit.grab_focus()
	main_path_line_edit.select_all()
	main_path_line_edit.mouse_filter = Control.MOUSE_FILTER_PASS

func _on_focus_exited_main_path_line_edit():
	if !main_path_line_edit.text.ends_with("/"):
		main_path_line_edit.text = main_path_line_edit.text + "/"
	var new_text = main_path_line_edit.text
	main_path_line_edit.editable = false
	var dir = DirAccess.open("res://")
	if !dir.dir_exists(new_text):
		printerr(_S.tr("main_dir_not_exists") % new_text)
		return
	ProjectSettings.set_setting("godot_idea_board/directory_path", new_text)
	ProjectSettings.save()
	print(_S.tr("main_changed_dir_path") % ProjectSettings.get_setting("godot_idea_board/directory_path"))
	save_json_dir_path = new_text
	main_path_line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_text_submitted_main_path_line_edit(_new_text:String):
	main_path_line_edit.release_focus()

func _on_text_changed_file_name_line_edit(new_text:String):
	if new_text.is_valid_filename() or new_text == "":
		file_name_message_label.text = ""
	else:
		file_name_message_label.text = _S.tr("[{0}.json] is invalid name.") % new_text

	var filepath = save_json_dir_path + file_name_line_edit.text + ".json"
	if FileAccess.file_exists(filepath):
		file_name_message_label.text = _S.tr("[{0}] is already exists.") % filepath


func _on_confirmed_file_name_dialog():
	var filepath = save_json_dir_path + file_name_line_edit.text + ".json"
	if !file_name_line_edit.text.is_valid_filename():
		printerr(tr("[{0}] is invalid filepath.") % file_name_line_edit.text)
		return
	if FileAccess.file_exists(filepath):
		printerr(tr("[{0}] is already exists.", filepath))
		return

	match _dialog_type:
		DIALOG_TYPE.ADD:
			var file = FileAccess.open(filepath,FileAccess.WRITE)
			file.store_string("{}")
		DIALOG_TYPE.DUPLICATE:
			var dir = DirAccess.open("res://")
			var old_filepath = saved_item_list.get_item_metadata(_selected_index)
			dir.copy(old_filepath, filepath)
			pass
		DIALOG_TYPE.RENAME:
			var dir = DirAccess.open("res://")
			var old_filepath = saved_item_list.get_item_metadata(_selected_index)
			dir.rename(old_filepath, filepath)
	editor_interface.get_resource_filesystem().scan()
	_on_pressed_reload_button.call_deferred()


func _on_confirmed_confirmation_dialog():
	match _dialog_type:
		DIALOG_TYPE.REMOVE_CONFIRM:
			# 削除確定
			var filepath = saved_item_list.get_item_metadata(_selected_index)
			if !FileAccess.file_exists(filepath):
				printerr(_S.tr("[{0}] is not exists.") % filepath)
				_on_pressed_reload_button.call_deferred()
				return
			var dir = DirAccess.open("res://")
			dir.remove(filepath)

			_on_pressed_reload_button.call_deferred()
			# 非表示状態にする
			sekkei_graph_1.visible = false
			no_data_reference_rect.visible = true
		DIALOG_TYPE.SAVE_CONFIRM:
			_confirmed_exec.call()
			pass
		_:
			pass


func _on_close_requested_window():
	if sekkei_graph_3.dirty:
		window.always_on_top = false
		_dialog_type = DIALOG_TYPE.SAVE_CONFIRM
		confirmation_dialog.title = _S.tr("Edited data will not be saved.")
		confirmation_dialog.dialog_text = _S.tr("Edited data will not be saved.text")
		_confirmed_exec = _close_window
		confirmation_dialog.popup_centered()
		window.always_on_top = true
	else:
		_close_window()

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func save():
#	HeaderLarge
	if sekkei_graph_1.visible:
		sekkei_graph_1.save()
	if sekkei_graph_2.visible:
		sekkei_graph_2.save()

func get_save_files() -> Array[String]:
	var files:Array[String] = []
	var dir = DirAccess.open(save_json_dir_path)
	for file in dir.get_files():
		if file.get_extension() == "json":
			files.append(file)
		pass
	return files

func update_saved_item_list():
	var save_file_paths = get_save_files()
#	var selected_texts:Array[String] = []
#	for index in saved_item_list.get_selected_items():
#		selected_texts.append(saved_item_list.get_item_text(index))
	saved_item_list.clear()
	var index:int = 0
	for json_path in save_file_paths:
		saved_item_list.add_item(json_path.get_basename())
		saved_item_list.set_item_metadata(index, save_json_dir_path + json_path)
		saved_item_list.set_item_tooltip(index, save_json_dir_path + json_path)
		index += 1

	if index == 0:
		# 空だったら非表示にする
		sekkei_graph_1.visible = false
		no_data_reference_rect.visible = true
	else:
		sekkei_graph_1.visible = true
		no_data_reference_rect.visible = false

#	読み込みなおす
	var exists_left = false
	for item_index in saved_item_list.item_count:
		if saved_item_list.get_item_text(item_index) == _left_selected_text:
			_on_item_selected(item_index)
			exists_left = true
		if split_button.button_pressed and saved_item_list.get_item_text(item_index) == _right_selected_text:
			var now_pressed = _is_left
			_is_left = false
			_on_item_selected(item_index)
			_is_left = now_pressed

	# 開くファイルがなければGraphEditを表示しない
	if !exists_left:
		sekkei_graph_1.visible = false
		no_data_reference_rect.visible = true

	main_path_line_edit.text = save_json_dir_path

func select_by_json_path(path:String) -> bool:
	for index in saved_item_list.item_count:
		if saved_item_list.get_item_metadata(index) == path:
			_selected_sekkei_graph_update(index)
			return true
	return false

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

## GraphEditのデータを選択したjsonのデータで初期化する
func _selected_sekkei_graph_update(index:int):
	_selected_index = index
	var json_path = saved_item_list.get_item_metadata(index)
	if json_path == null:
		return
	var file = FileAccess.open(json_path,FileAccess.READ)
	var json_str = file.get_as_text()
	var datas = JSON.parse_string(json_str)

	if _is_left:
		sekkei_graph_1.save_json_file_path = json_path
		sekkei_graph_1.reset(datas)
		_left_selected_text = saved_item_list.get_item_text(index)
		sekkei_graph_1.visible = true
		no_data_reference_rect.visible = false
	else:
		sekkei_graph_2.save_json_file_path = json_path
		sekkei_graph_2.reset(datas)
		_right_selected_text = saved_item_list.get_item_text(index)
		no_data_reference_rect.visible = false
	saved_item_list.select(index, true)

func _close_window():
	window.hide()
	window_button.button_pressed = false

#
# 翻訳
#
func _translate():
	window_button.tooltip_text = _S.tr("tooltip_main_window_button")
	split_button.tooltip_text = _S.tr("tooltip_main_split_button")
	left_button.tooltip_text = _S.tr("tooltip_main_left_button")
	right_button.tooltip_text = _S.tr("tooltip_main_right_button")
	reload_button.tooltip_text = _S.tr("tooltip_main_reload_button")
	add_button.tooltip_text = _S.tr("tooltip_main_add_button")
	duplicate_button.tooltip_text = _S.tr("tooltip_main_duplicate_button")
	rename_button.tooltip_text = _S.tr("tooltip_main_rename_button")
	remove_button.tooltip_text = _S.tr("tooltip_main_remove_button")
	main_path_line_edit.tooltip_text = _S.tr("tooltip_main_main_path_line_edit")
	main_path_edit_button.tooltip_text = _S.tr("tooltip_main_main_path_line_edit")
