#01. tool
@tool
#02. class_name

#03. extends
extends GraphNode
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal end_node_move
signal load_completed
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

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var path:String = ""
var script_path:String = ""
var uid:String = ""
var id:int
var script_icon_path:String = ""
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _parent:GraphEdit
var graph_node_type = "File"
var icon_name:String = "File"



var snap: = true
var drag_start = null
var mouse_drag_start
var dragging: = false

var _type

var _stream:AudioStream # 音楽ファイルのときは読み込んでおく
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var tscn_h_box_container = %TscnHBoxContainer
@onready var tscn_icon_button:Button = %TscnIconButton
@onready var tscn_play_button:Button = %TscnPlayButton
@onready var sound_play_button:Button = %SoundPlayButton
@onready var locked_button = %LockedButton
@onready var tscn_label = %TscnLabel

@onready var script_h_box_container = %ScriptHBoxContainer
@onready var script_class_icon_button:Button = %ScriptClassIconButton
@onready var script_icon_button:Button = %ScriptIconButton
@onready var locked_button_2 = %LockedButton2
@onready var script_label = %ScriptLabel

@onready var h_separator = %HSeparator
@onready var texture_rect = %TextureRect

@onready var context_menu:PopupMenu = $ContextMenu

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------
#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(data:Dictionary):
	if data.has("id"):
		id = data.id
	if data.has("selectable"): #ロック
		if !data.selectable:
			context_menu.set_item_checked.bind(0,true).call_deferred()
			_on_toggle_lock_selected_context_menu.bind(true).call_deferred()
	if data.has("position_offset_x"):
		position_offset.x = data.position_offset_x
	if data.has("position_offset_y"):
		position_offset.y = data.position_offset_y
	if data.has("is_scene_play"):
		tscn_play_button.visible = data.is_scene_play
		if data.is_scene_play:
			context_menu.set_scene_play_check.bind(true).call_deferred()
	if data.has("script_icon_path"):
		script_icon_path = data.script_icon_path


	var file_path:String = data.path
	_parent = get_parent()
	path = file_path

	# ファイルの場所が変わったときはuidを読む
	if data.has("uid"):
		uid = data.uid

	if !data.has("position_offset_x"): #新規作成は空になってるのでそれで判定しておく、jsonロードはそうならない
		id = get_instance_id()

	tscn_play_button.icon = _parent.get_icon("PlayScene")
	sound_play_button.icon = _parent.get_icon("Play")
	locked_button.icon = _parent.get_icon("Lock")
	locked_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))
	locked_button_2.icon = _parent.get_icon("Lock")
	locked_button_2.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	locked_button_2.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))

	tooltip_text = file_path

	var error = OK

	var dir = DirAccess.open("res://")
	if dir.dir_exists(file_path):
#		ディレクトリ
		_type = ITEM_TYPE.DIR
		tscn_label.text = _get_path_name()
		tscn_icon_button.icon = _parent.get_icon("Folder")
		tscn_icon_button.add_theme_color_override("icon_normal_color", Color.from_string("6cbae0",Color.WHITE))
		tscn_icon_button.add_theme_color_override("icon_hover_color", Color.from_string("6cbae0",Color.WHITE))
		icon_name = "Folder"
		script_h_box_container.visible = false
	else:
		var textfiles = _parent.editor_interface.get_editor_settings().get("docks/filesystem/textfile_extensions")
#		ファイルがあるかチェックする、なかったらuidをチェックしてあればファイルを更新
#		※スクリプトはUIDがない
		var is_exists = FileAccess.file_exists(file_path)
		var resource_exists = ResourceLoader.exists(file_path)

		if is_exists and resource_exists:
			uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(file_path))
		elif uid != "" :
			var int_id = ResourceUID.text_to_id(uid)
			if int_id != -1 and ResourceUID.has_id(int_id):
				file_path = ResourceUID.get_id_path(ResourceUID.text_to_id(uid))
				path = file_path
				is_exists = FileAccess.file_exists(file_path)

		var is_installed_dialogic:bool = FileAccess.file_exists("res://addons/dialogic/plugin.gd")

		if file_path.ends_with(".tscn") and is_exists:
	#		シーン
			_type = ITEM_TYPE.SCENE
			tscn_label.text = _get_path_name()

			ResourceLoader.load_threaded_request(file_path, "", false, 1)
			set_process(true)
			await self.load_completed
			var packedscene:PackedScene = ResourceLoader.load_threaded_get(path)
			if packedscene.can_instantiate():
				var instance:Node = packedscene.instantiate()

				var scn_script:Script = instance.get_script()

				var classname = instance.get_class()
				tscn_icon_button.icon = _parent.get_icon(classname)
				icon_name = classname
				if scn_script:
					script_path = scn_script.resource_path
					script_label.text = _get_script_name()
					script_icon_button.icon = _parent.get_icon("Script")
					_resize_script_class_icon.call_deferred()
					script_h_box_container.visible = true

					if script_icon_path == "":
						var icon_path = get_gori_oshi_icon_path(scn_script.resource_path)
						if icon_path != "":
							script_class_icon_button.icon = load(icon_path)
							script_icon_path = icon_path
						else:
							script_class_icon_button.icon = _parent.get_icon(classname)
							script_icon_path = classname
					elif script_icon_path.begins_with("res:"):
						script_class_icon_button.icon = load(script_icon_path)
					else:
						script_class_icon_button.icon = _parent.get_icon(script_icon_path)
				else:
					script_h_box_container.visible = false
			else:
				error = -1
				printerr(path + " can not instantiate.")


		elif file_path.ends_with(".gd") and is_exists:
	#		スクリプト
			_type = ITEM_TYPE.SCRIPT
			tscn_h_box_container.visible = false
			script_path = file_path
			script_label.text = _get_script_name()
			script_icon_button.icon = _parent.get_icon("Script")
			icon_name = "Script"
			var script_class = load(file_path)
			var classname = script_class.get_instance_base_type()
			_resize_script_class_icon.call_deferred()
			script_h_box_container.visible = true

			if script_icon_path == "":
				var icon_path = get_gori_oshi_icon_path(script_path)

				if icon_path != "":
					script_class_icon_button.icon = load(icon_path)
					script_icon_path = icon_path
				else:
					script_class_icon_button.icon = _parent.get_icon(classname)
					script_icon_path = classname
			elif script_icon_path.begins_with("res:"):
				script_class_icon_button.icon = load(script_icon_path)
			else:
				script_class_icon_button.icon = _parent.get_icon(script_icon_path)

		elif textfiles.contains(file_path.get_extension()) and is_exists:
	#		テキストファイル
				_type = ITEM_TYPE.TEXT
				tscn_h_box_container.visible = false
				script_h_box_container.visible = true
				script_path = file_path
				script_label.text = _get_script_name()
				script_icon_button.icon = _parent.get_icon("TextFile")
				icon_name = "TextFile"

		elif file_path.ends_with(".dtl") and is_installed_dialogic and is_exists:
	#		Dialogic タイムライン
			_type = ITEM_TYPE.DIALOGIC_TIMELINE
			script_h_box_container.visible = false
			tscn_label.text = _get_path_name()
			tscn_icon_button.icon = load("res://addons/dialogic/Editor/Images/plugin-icon.svg")
			icon_name = "File"
			context_menu.set_item_checked.bind(ITEM_TYPE.DIALOGIC_TIMELINE, true).call_deferred()
			_on_toggle_play_scene_selected_context_menu.bind(true).call_deferred()

		elif file_path.ends_with(".dch") and is_installed_dialogic and is_exists:
	#		Dialogic キャラクター
			_type = ITEM_TYPE.DIALOGIC_CHARA
			script_h_box_container.visible = false
			tscn_label.text = _get_path_name()
			tscn_icon_button.icon = load("res://addons/dialogic/Editor/Images/Resources/character.svg")
			icon_name = "File"

		elif !is_exists:
			script_h_box_container.visible = false
			tscn_label.text = _get_path_name()
#			読み込めなかった
			_type = ITEM_TYPE.NONE
			tscn_icon_button.icon = _parent.get_icon("FileBroken")
			icon_name = "FileBroken"
		else:
			ResourceLoader.load_threaded_request(file_path, "", true, 1)
			set_process(true)
			await self.load_completed
			var instance = ResourceLoader.load_threaded_get(path)
			script_h_box_container.visible = false
			tscn_label.text = _get_path_name()
			if instance is Texture2D:
	#		画像
				_type = ITEM_TYPE.TEXTURE
				tscn_icon_button.icon = _parent.get_icon("ImageTexture")
				tscn_icon_button.add_theme_color_override("icon_normal_color", Color.from_string("ff8ccc",Color.WHITE))
				tscn_icon_button.add_theme_color_override("icon_hover_color", Color.from_string("ff8ccc",Color.WHITE))
				icon_name = "ImageTexture"
				h_separator.visible = true
				texture_rect.visible = true
				texture_rect.texture = instance
				resizable = true
				if data.has("size_x"):
					size.x = data.size_x
				if data.has("size_y"):
					size.y = data.size_y
				else:
					size = instance.get_size() + Vector2(0,tscn_h_box_container.size.y)
					print(instance.get_size() + Vector2(0,tscn_h_box_container.size.y))
					print(size)
				_resize(size)
			elif instance is AudioStream:
				_type = ITEM_TYPE.SOUND
				sound_play_button.visible = true
				_stream = instance
				var classname = instance.get_class()
				tscn_icon_button.icon = _parent.get_icon(classname)
				icon_name = classname
			else:
	#		その他リソース
				_type = ITEM_TYPE.RESOURCE
				var classname = instance.get_class()
				tscn_icon_button.icon = _parent.get_icon(classname)
				icon_name = classname

	if error == -1:
		script_h_box_container.visible = false
		tscn_label.text = _get_path_name()
		# 読み込めなかった
		_type = ITEM_TYPE.NONE
		tscn_icon_button.icon = _parent.get_icon("FileBroken")
		icon_name = "FileBroken"
		pass

#	右クリックメニューの初期化
	context_menu.transient = !_parent.is_window
	context_menu.always_on_top = _parent.is_window
	context_menu.init(_type)


func _ready():
	for item in get_titlebar_hbox().get_children():
		item.visible = false
		item.size = Vector2.ZERO
	get_titlebar_hbox().visible = false
	get_titlebar_hbox().size = Vector2.ZERO
	tscn_icon_button.pressed.connect(_on_pressed_tscn_icon_button)
	tscn_play_button.pressed.connect(_on_pressed_tscn_play_button)
	sound_play_button.pressed.connect(_on_pressed_sound_play_button)
	script_icon_button.pressed.connect(_on_pressed_script_icon_button)

	resize_request.connect(_on_resize_request)

#	ロック
	locked_button.pressed.connect(_on_pressed_locked_button)
	locked_button_2.pressed.connect(_on_pressed_locked_button)

#	右クリックメニュー
	context_menu.copied.connect(_on_copied_context_menu)
	context_menu.deleted.connect(_on_deleted_context_menu)
	context_menu.toggle_lock_selected.connect(_on_toggle_lock_selected_context_menu)
	context_menu.filepath_copied.connect(_on_filepath_copied_context_menu)
	context_menu.toggle_play_scene_selected.connect(_on_toggle_play_scene_selected_context_menu)
	context_menu.make_edit.connect(_on_make_edit_context_menu)
	context_menu.add_files_in_dir.connect(_on_add_files_in_dir_context_menu)
	context_menu.add_files_recursive_in_dir.connect(_on_add_files_recursive_in_dir_context_menu)


#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _process(delta):
	var status = ResourceLoader.load_threaded_get_status(path)
	if status == 3: #ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED
		load_completed.emit()
		set_process(false)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#drag start
		if event.pressed:
#			selected = true
			drag_start = position_offset
			mouse_drag_start = get_local_mouse_position()
			dragging = true
		#reorder nodes so selected group is on top of other groups
			move_to_front()
			for node in get_parent().get_children():
				if node is GraphNode:
					node.move_to_front()
		else:
			selected = true
			end_node_move.emit()
			dragging = false
	#drag selected node
	elif dragging and event is InputEventMouseMotion:
#		position_offset += get_local_mouse_position() - mouse_drag_start
#		if snap:
#			position_offset = get_parent().snap(position_offset)
		get_parent().set_dirty()
	# コンテキストメニューを表示する
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_RIGHT\
	and !event.pressed:
		accept_event()
		context_menu.popup()
		var pa = _parent.get_parent()
		if pa is Window: #PopupGraphならWindowのぶんずらす
			context_menu.position = DisplayServer.mouse_get_position() + pa.position
		else:
			context_menu.position = DisplayServer.mouse_get_position()
		_parent.penetrate_nodes()


func _on_pressed_tscn_icon_button():
	_resource_activated(path)

func _on_pressed_tscn_play_button():
	match _type:
		ITEM_TYPE.SCENE:
			_parent.editor_interface.play_custom_scene(path)
		ITEM_TYPE.DIALOGIC_TIMELINE:

			ProjectSettings.set_setting('dialogic/editor/current_timeline_path', path)
			ProjectSettings.save()
			var tree: SceneTree = Engine.get_main_loop()
			if tree.get_root().get_child(0).has_node('DialogicPlugin'):
				tree.get_root().get_child(0).get_node('DialogicPlugin').editor_interface.play_custom_scene("res://addons/dialogic/Editor/TimelineEditor/test_timeline_scene.tscn")

func _on_pressed_sound_play_button():
	var audio_stream_player:AudioStreamPlayer = _parent._main.audio_stream_player
	audio_stream_player.stream = _stream.duplicate()
	audio_stream_player.play()

func _on_pressed_script_icon_button():
	var interface = _parent.editor_interface
	var resource = ResourceLoader.load(script_path)
	interface.edit_resource(resource)
	if resource is Script:
		interface.set_main_screen_editor("Script")

func _on_resize_request(new_minsize):
	_resize(new_minsize)
	get_parent().set_dirty()

func _on_copied_context_menu():
	var data = get_data()
	data.position_offset_x = 0
	data.position_offset_y = 0
	DisplayServer.clipboard_set(JSON.stringify([data]))

func _on_deleted_context_menu():
	_parent.delete_node(self)

func _on_toggle_lock_selected_context_menu(is_enabled:bool):
	if is_enabled:
		self.selectable = false

		if _type == ITEM_TYPE.SCRIPT:
			locked_button_2.visible = true
		else:
			locked_button.visible = true
	else:
		_on_pressed_locked_button()

func _on_filepath_copied_context_menu():
	DisplayServer.clipboard_set(path)

func _on_make_edit_context_menu():
	_parent.make_edit(self)

func _on_pressed_locked_button():
	context_menu.set_item_checked(0, false)#ロックのチェックを外す
	locked_button.visible = false
	locked_button_2.visible = false
	self.selectable = true
	size = Vector2.ZERO

## シーンプレイボタンの表示切替え
func _on_toggle_play_scene_selected_context_menu(is_enabled:bool):
	tscn_play_button.visible = is_enabled
	size = Vector2.ZERO

## ディレクトリ内のファイルをすべて追加する
func _on_add_files_in_dir_context_menu():
	var file_paths:Array[String] = []
	var dir = DirAccess.open(path)
	if dir.get_open_error() == OK:
		for file in dir.get_files():
			if file.begins_with("."): continue
			if file.ends_with(".import"): continue
			file_paths.append(path + file)
#	print(file_paths)
#	for file_path in file_paths:
	_parent._drop_data(position + size, {"files":file_paths})

## ディレクトリ内のファイルをすべて追加する
func _on_add_files_recursive_in_dir_context_menu():
	var file_paths:Array[String] = []
	_get_file_paths_recursive(file_paths, path)
	_parent._drop_data(position + size, {"files":file_paths})

func _get_file_paths_recursive(file_paths:Array[String], dir_path:String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir.get_open_error() == OK:
		var files = dir.get_files()
		var dirs = dir.get_directories()
		dirs.append_array(files)
		for file in dir.get_files():
			if file.begins_with("."): continue
			if file.ends_with(".import"): continue
			file_paths.append(dir_path + file)
		for dir_child_path in dir.get_directories():
			if dir_child_path.begins_with("."): continue
			if dir_child_path.ends_with(".import"): continue
			_get_file_paths_recursive(file_paths,dir_path + dir_child_path)
#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func show():
	self.visible = true
	self.selectable = true

func hide():
	self.visible = false
	self.selectable = false

func get_data() -> Dictionary:
	var data = {
		"node" : "File",
		"id" : id,
		"selectable" : selectable,
		"position_offset_x" : position_offset.x,
		"position_offset_y" : position_offset.y,
		"size_x" : size.x,
		"size_y" : size.y,
		"path" : path,
		"uid" : uid,
		"is_scene_play" : tscn_play_button.visible,
		"script_path" : script_path,
		"script_icon_path" : script_icon_path
	}
	return data

func lock():
#	_on_index_pressed(index:int):の処理
	context_menu.set_item_checked(0, true)
	context_menu.toggle_lock_selected.emit(context_menu.is_item_checked(0))

func unlock():
#	_on_index_pressed(index:int):の処理
	context_menu.set_item_checked(0, false)
	context_menu.toggle_lock_selected.emit(context_menu.is_item_checked(0))

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
func _get_path_name():
	var split:Array = path.split("/")
	var name = split.pop_back()
	if name.length() == 0:
		name = split.pop_back()
	return name

func _get_script_name():
	var split:Array = script_path.split("/")
	var name = split.pop_back()
	if name.length() == 0:
		name = split.pop_back()
	return name


func _resource_activated(class_resource_path):
	var interface = _parent.editor_interface
	match _type:
		ITEM_TYPE.SCENE:
			if true: #TODO 3D OR 2D
				interface.set_main_screen_editor("2D")
			else:
				interface.set_main_screen_editor("3D")
			interface.open_scene_from_path(class_resource_path)
		ITEM_TYPE.DIR:
			var file_dock:FileSystemDock = interface.get_file_system_dock()
			_collapse_selected(file_dock)
			file_dock.navigate_to_path(class_resource_path)
			_expand_selected(file_dock)
		ITEM_TYPE.TEXT:
			var file_dock:FileSystemDock = interface.get_file_system_dock()
			_collapse_selected(file_dock)
			file_dock.navigate_to_path(class_resource_path)
			_expand_selected(file_dock)
	#		interface.set_main_screen_editor("Script")
		ITEM_TYPE.NONE:
			return
		_:
			var resource = ResourceLoader.load(class_resource_path)
			interface.edit_resource(resource)
			if resource is Script:
				interface.set_main_screen_editor("Script")

func _collapse_selected(node, depth = 1):
	for child in node.get_children():
		if child is Tree:
			var item:TreeItem = child.get_selected()
			if item:
				item.collapsed = true
		_collapse_selected(child, depth + 1)

func _expand_selected(node, depth = 1):
	for child in node.get_children():
		if child is Tree:
			var item:TreeItem = child.get_selected()
#			if item:
#				if item.get_text(0) == main_resource.resource_name: TODO
#					item.collapsed = false
#				pass
		_expand_selected(child, depth + 1)

func _resize(size):
	self.custom_minimum_size = get_parent().snap(size)
	self.size = get_parent().snap(size)
	texture_rect.custom_minimum_size = get_parent().snap(Vector2(size.x,size.y - tscn_h_box_container.size.y))
	texture_rect.size = get_parent().snap(Vector2(size.x,size.y - tscn_h_box_container.size.y))
	get_parent().set_dirty()
#	custom_minimum_size = size + Vector2(0,32)
#	self.size = size + Vector2(0,32)

func get_gori_oshi_icon_path(path:String) -> String:
	var file = FileAccess.open(path,FileAccess.READ)
	var line := file.get_line()
	var icon_path:String = ""
	while !file.eof_reached():
		icon_path = _load_line(line)
		if icon_path != "":
			break
		line = file.get_line()

	if icon_path == "":
		return ""

	return icon_path

func _load_line(line:String) -> String:
#	コメントチェック
	var regex_comment = RegEx.new()
	regex_comment.compile("\\s*#.*")
	var result_comment = regex_comment.search(line)
	if result_comment:
		return ""

#	@icon("res://icon.svg")
#	iconsチェック
	var regex_icon = RegEx.new()
	regex_icon.compile("\\s*@icon\\(.*")
	var result_icon = regex_icon.search(line)
	if result_icon:
		var icon_pos := line.find("@icon(")
		var icon_path = line.substr(icon_pos + 7).trim_suffix(" ").trim_prefix(" ").trim_suffix(")").trim_suffix("\"")
		return icon_path

	return ""

func _resize_script_class_icon():
	script_class_icon_button.size = script_icon_button.size
	script_class_icon_button.custom_minimum_size = script_icon_button.size
