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
#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const md_icon = preload("res://addons/godot-idea-board/icon/md.svg")
const bold_icon = preload("res://addons/godot-idea-board/icon/b.svg")
const h1_icon = preload("res://addons/godot-idea-board/icon/h1.svg")
const h2_icon = preload("res://addons/godot-idea-board/icon/h2.svg")

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var _parent:GraphEdit
var graph_node_type = "TextDocument"
var id:int
var icon_name = "Edit"
var color_theme ="TrDark"
var sub_color

var path:String = ""

var snap: = true
var drag_start = null
var mouse_drag_start
var dragging: = false
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
const Markdownlabel = preload("res://addons/godot-idea-board/md/markdownlabel.gd")
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var margin_container = $MarginContainer

# title_h_box_container
@onready var title_h_box_container:HBoxContainer = $MarginContainer/VB/TitleHBoxContainer
@onready var check_box:CheckBox = %CheckBox
@onready var icon_button:Button = %IconButton
@onready var markdown_toggled_button:Button = %MarkdownToggledButton
@onready var sub_color_button:Button = %SubColor
@onready var file_button:Button = %FileButton
@onready var save_button:Button = %SaveButton
@onready var locked_button:Button = %LockedButton
@onready var header_line_edit:LineEdit = %HeaderLineEdit
@onready var text_edit:TextEdit = %TextEdit
@onready var parsed_rich_text_label:RichTextLabel = %ParsedRichTextLabel

# menu_h_box_container
@onready var menu_h_box_container:HBoxContainer = $MarginContainer/VB/MenuHBoxContainer
@onready var bold_button = $MarginContainer/VB/MenuHBoxContainer/BoldButton
@onready var h_1_button = $MarginContainer/VB/MenuHBoxContainer/H1Button
@onready var h_2_button = $MarginContainer/VB/MenuHBoxContainer/H2Button
@onready var export_button = $MarginContainer/VB/MenuHBoxContainer/ExportButton

@onready var context_menu:PopupMenu = $ContextMenu

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(data:Dictionary = {}):
	_parent = get_parent()
	if data.has("id"):
		id = data.id
	if data.has("node") and data.node == "Label":
		icon_name = "Label"
		# ラベルノード
		title_h_box_container.size_flags_vertical = HBoxContainer.SIZE_EXPAND_FILL
		header_line_edit.expand_to_text_length = true
		header_line_edit.alignment = HORIZONTAL_ALIGNMENT_LEFT
		markdown_toggled_button.visible = false
		text_edit.visible = false
		parsed_rich_text_label.visible = false
		text_edit.custom_minimum_size = Vector2.ZERO
		parsed_rich_text_label.custom_minimum_size = Vector2.ZERO
		custom_minimum_size = Vector2.ZERO
		size = Vector2(size.x,0)
	if data.has("is_visible_check"):
		check_box.visible = data.is_visible_check
	if data.has("check"):
		check_box.button_pressed = data.check
	if data.has("color_theme"):
		color_theme = data.color_theme
	else:
		color_theme = _parent.default_text_color_theme
	_on_changed_color_context_menu(color_theme)

	if data.has("sub_color"):
		sub_color = Color.from_string(data.sub_color,Color.WHITE)
		_on_changed_sub_color_context_menu.bind(sub_color).call_deferred()

	if "is_md" in data and data.is_md:
		markdown_toggled_button.button_pressed = true
		_on_toggled_markdown_toggled_button.bind(true).call_deferred()
	if data.has("selectable"): #ロック
		if !data.selectable:
			context_menu.set_item_checked.bind(0,true).call_deferred()
			_on_toggle_lock_selected_context_menu.bind(true).call_deferred()
	if data.has("position_offset_x"):
		position_offset.x = data.position_offset_x
	if data.has("position_offset_y"):
		position_offset.y = data.position_offset_y
	if data.has("size_x"):
		size.x = data.size_x
	if data.has("size_y"):
		size.y = data.size_y
	if data.has("header_text"):
		header_line_edit.text = data.header_text
	if data.has("text_edit_text"):
		text_edit.text = data.text_edit_text
	if data.has("path") and data.path != "":
		text_edit.gutters_draw_line_numbers = true
		path = data.path
		file_button.visible = true
		save_button.visible = true
		if "is_md" in data and data.is_md:
			markdown_toggled_button.visible = true
		else:
			markdown_toggled_button.visible = false

	sub_color_button.icon = _parent.get_icon("Panels1")

	markdown_toggled_button.icon = _parent.get_icon("Edit")
	markdown_toggled_button.add_theme_color_override("icon_normal_color", Color.from_string("e589a4",Color.WHITE))
	markdown_toggled_button.add_theme_color_override("icon_pressed_color", Color.from_string("e589a4",Color.WHITE))
	markdown_toggled_button.add_theme_color_override("icon_hover_color", Color.from_string("e589a4",Color.WHITE))
	markdown_toggled_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("e589a4",Color.WHITE))
	markdown_toggled_button.add_theme_color_override("icon_focus_color", Color.from_string("e589a4",Color.WHITE))

	save_button.icon = _parent.get_icon("Save")
	save_button.add_theme_color_override("icon_normal_color", Color.from_string("dc9520",Color.WHITE))
	save_button.add_theme_color_override("icon_pressed_color", Color.from_string("dc9520",Color.WHITE))
	save_button.add_theme_color_override("icon_hover_color", Color.from_string("dc9520",Color.WHITE))
	save_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("dc9520",Color.WHITE))
	save_button.add_theme_color_override("icon_focus_color", Color.from_string("dc9520",Color.WHITE))

	file_button.icon = _parent.get_icon("File")

	locked_button.icon = _parent.get_icon("Lock")
	locked_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_pressed_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_focus_color", Color.from_string("fada79",Color.WHITE))

	bold_button.icon = bold_icon
	h_1_button.icon = h1_icon
	h_2_button.icon = h2_icon

	# 初期はタイトル入力状態にする
	if !data.has("position_offset_x"): #新規作成は空になってるのでそれで判定しておく、jsonロードはそうならない
		_on_pressed_icon_button()
		id = get_instance_id()
#	_resize.bind(size).call_deferred()
	_resize(size)

	context_menu.transient = !_parent.is_window
	context_menu.always_on_top = _parent.is_window


func _ready():
	for item in get_titlebar_hbox().get_children():
		item.visible = false
		item.size = Vector2.ZERO
	get_titlebar_hbox().visible = false
	get_titlebar_hbox().size = Vector2.ZERO
	icon_button.pressed.connect(_on_pressed_icon_button)
	header_line_edit.focus_exited.connect(_on_focus_exited_header_line_edit)
	resize_request.connect(_on_resize_request)
	markdown_toggled_button.toggled.connect(_on_toggled_markdown_toggled_button)
	save_button.pressed.connect(_on_pressed_save_button)
	file_button.pressed.connect(_on_pressed_file_button)
	locked_button.pressed.connect(_on_pressed_locked_button)

	text_edit.gui_input.connect(_text_edit_gui_input)

#	context_menu events
	context_menu.copied.connect(_on_copied_context_menu)
	context_menu.deleted.connect(_on_deleted_context_menu)
	context_menu.edit_title_selected.connect(_on_edit_title_selected_context_menu)
	context_menu.checked.connect(_on_checked_context_menu)
	context_menu.toggle_lock_selected.connect(_on_toggle_lock_selected_context_menu)
	context_menu.save_pressed.connect(_on_save_pressed_context_menu)
	context_menu.changed_color.connect(_on_changed_color_context_menu)
	context_menu.changed_sub_color.connect(_on_changed_sub_color_context_menu)
	context_menu.deleted_sub_color.connect(_on_deleted_sub_color_context_menu)

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _gui_input(event):
	#click node
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

	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.double_click:
		_on_pressed_icon_button()

func _text_edit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP\
		or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#			accept_event()
			pass

func _on_resize_request(new_minsize):
	_resize(new_minsize)
	get_parent().set_dirty()

func _on_pressed_icon_button():
	header_line_edit.grab_focus()
	header_line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	header_line_edit.mouse_default_cursor_shape = Control.CURSOR_IBEAM
func _on_focus_exited_header_line_edit():
	header_line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header_line_edit.mouse_default_cursor_shape = Control.CURSOR_MOVE

## Markdownパースする
func _on_toggled_markdown_toggled_button(button_pressed:bool):
	if button_pressed:
		text_edit.visible = false
		parsed_rich_text_label.visible = true
		#var parsed_bb_code_text = _parent.markdown_parser.parse(text_edit.text, size.x)
		parsed_rich_text_label.markdown_text = text_edit.text
		markdown_toggled_button.icon = md_icon
	else:
		text_edit.visible = true
		parsed_rich_text_label.visible = false
		markdown_toggled_button.icon = _parent.get_icon("Edit")
	_resize(size)

func _on_pressed_save_button():
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path,FileAccess.WRITE)
		file.store_string(text_edit.text)
	else:
		printerr("path " + path + "is not read.")
	pass

func _on_pressed_file_button():
	var interface = _parent.editor_interface
	var file_dock:FileSystemDock = interface.get_file_system_dock()
	_collapse_selected(file_dock)
	file_dock.navigate_to_path(path)
	_expand_selected(file_dock)
	pass
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
			if item:
#				if item.get_text(0) == main_resource.resource_name: TODO
#					item.collapsed = false
				pass
		_expand_selected(child, depth + 1)

func _on_copied_context_menu():
	var data = get_data()
	data.position_offset_x = 0
	data.position_offset_y = 0
	DisplayServer.clipboard_set(JSON.stringify([data]))

func _on_deleted_context_menu():
	_parent.delete_node(self)

func _on_edit_title_selected_context_menu():
	_on_pressed_icon_button()

func _on_save_pressed_context_menu():

	pass

func _on_changed_color_context_menu(color_str:String):
	color_theme = color_str
	var font_color:Color
	var bg_color:Color
	var header_bg_style:StyleBox
	var header_bg_style_focus:StyleBox
	var bg_style:StyleBox
	match color_theme:
		"TrLight":
			font_color = Color.from_string("393939",Color.WHITE)
			header_bg_style = preload("res://addons/godot-idea-board/theme/transparent_title_line_edit.tres")
			header_bg_style_focus = preload("res://addons/godot-idea-board/theme/transparent_title_selected_line_edit.tres")
			bg_style = preload("res://addons/godot-idea-board/theme/transparent_style_box_line.tres")
			bg_color = Color.from_string("cfd0d119",Color.WHITE)
		"TrDark":
			font_color = Color.from_string("ccced1",Color.WHITE)
			header_bg_style = preload("res://addons/godot-idea-board/theme/transparent_title_line_edit.tres")
			header_bg_style_focus = preload("res://addons/godot-idea-board/theme/transparent_title_selected_line_edit.tres")
			bg_style = preload("res://addons/godot-idea-board/theme/transparent_style_box_line.tres")
			bg_color = Color.from_string("1d222919",Color.WHITE)
		"Light":
			font_color = Color.from_string("393939",Color.WHITE)
			header_bg_style = preload("res://addons/godot-idea-board/theme/text_light_title_line_edit.tres")
			header_bg_style_focus = preload("res://addons/godot-idea-board/theme/text_light_title_selected_line_edit.tres")
			bg_style = preload("res://addons/godot-idea-board/theme/text_light_style_box_line.tres")
			bg_color = Color.from_string("cfd0d1",Color.WHITE)
		"Dark":
			font_color = Color.from_string("ccced1",Color.WHITE)
			header_bg_style = preload("res://addons/godot-idea-board/theme/text_dark_title_line_edit.tres")
			header_bg_style_focus = preload("res://addons/godot-idea-board/theme/text_dark_title_selected_line_edit.tres")
			bg_style = preload("res://addons/godot-idea-board/theme/text_dark_style_box_line.tres")
			bg_color = Color.from_string("1d2229",Color.WHITE)

	header_line_edit.add_theme_color_override("font_color",font_color)
	header_line_edit.add_theme_color_override("caret_color",font_color)
	header_line_edit.add_theme_stylebox_override("normal",header_bg_style)
	header_line_edit.add_theme_stylebox_override("focus",header_bg_style_focus)
	text_edit.add_theme_color_override("font_color",font_color)
	text_edit.add_theme_color_override("background_color",bg_color)
	parsed_rich_text_label.add_theme_color_override("default_color", font_color)
	parsed_rich_text_label.add_theme_stylebox_override("normal",bg_style)
	parsed_rich_text_label.add_theme_stylebox_override("focus",bg_style)
	parsed_rich_text_label.add_theme_color_override("table_row_odd_bg", bg_color)
	parsed_rich_text_label.add_theme_color_override("table_row_even_bg", bg_color)

	# 初期設定色テーマを置き換える
	_parent.default_text_color_theme = color_theme
	_parent.set_dirty()

func _on_changed_sub_color_context_menu(color:Color):
#	sub_color_button.add_theme_color_override("icon_normal_color", color)
	sub_color_button.icon = _parent.get_color_rect_image(color)
	sub_color_button.visible = true
	sub_color = color

func _on_deleted_sub_color_context_menu():
	sub_color_button.visible = false
	sub_color = null

func _on_toggle_lock_selected_context_menu(is_enabled:bool):
	if is_enabled:
		locked_button.visible = true
		self.selectable = false
	else:
		_on_pressed_locked_button()

func _on_pressed_locked_button():
	context_menu.set_item_checked(0, false)#ロックのチェックを外す
	locked_button.visible = false
	self.selectable = true

func _on_checked_context_menu(is_enabled:bool):
	check_box.visible = is_enabled

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func show():
	self.visible = true
	self.selectable = true

func hide():
	self.visible = false
	self.selectable = false

func change_text_font(header_font_size,label_font_size):
	text_edit.add_theme_font_size_override("font_size", label_font_size)
	header_line_edit.add_theme_font_size_override("font_size", header_font_size)

func get_data() -> Dictionary:
	if icon_name == "Label":
		var data = {
			"node" : "Label",
			"id" : id,
			"selectable" : selectable,
			"position_offset_x" : position_offset.x,
			"position_offset_y" : position_offset.y,
			"size_x" : size.x,
			"size_y" : size.y,
			"header_text" : header_line_edit.text,
			"text_edit_text" : text_edit.text,
			"color_theme" : color_theme,
			"is_visible_check" : check_box.visible,
			"check" : check_box.button_pressed,
			"path" : path,
		}
		if sub_color != null:
			data.sub_color = sub_color.to_html(true)
		return data
	else:
		var data = {
			"node" : "TextDocument",
			"id" : id,
			"is_md" : markdown_toggled_button.button_pressed,
			"selectable" : selectable,
			"position_offset_x" : position_offset.x,
			"position_offset_y" : position_offset.y,
			"size_x" : size.x,
			"size_y" : size.y,
			"header_text" : header_line_edit.text,
			"text_edit_text" : text_edit.text,
			"color_theme" : color_theme,
			"is_visible_check" : check_box.visible,
			"check" : check_box.button_pressed,
			"path" : path,
		}
		if sub_color != null:
			data.sub_color = sub_color.to_html(true)
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
func _resize(size):
#	margin_container.custom_minimum_size = Vector2(size.x - 60, size.y - 40)
#	margin_container.size = Vector2(size.x - 60, size.y - 40)
	size = get_parent().snap(size)
	self.custom_minimum_size = size
	self.size = size
	text_edit.custom_minimum_size = size - Vector2(0,title_h_box_container.size.y) - Vector2(0,menu_h_box_container.size.y)
	text_edit.size =  size - Vector2(0,title_h_box_container.size.y) - Vector2(0,menu_h_box_container.size.y)

	get_parent().set_dirty()
	# ラベルはフォントサイズも追従する
	if icon_name == "Label":
		header_line_edit.add_theme_font_size_override("font_size", int(size.y/2))
		pass
