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
const select_icon = preload("res://addons/godot-project-design-links/icon/tool_select.svg")
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var _parent:GraphEdit

var id

var color_theme ="White"

var snap: = true
var drag_start = null
var mouse_drag_start
var dragging: = false
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _children = []
var graph_node_type = "LineHandle"

var _from_node
var _to_node
var _from_node_id
var _to_node_id
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var context_menu:PopupMenu = $ContextMenu
@onready var line_2d:Line2D = $Line2D
@onready var locked_button = %LockedButton
@onready var line_edit = %LineEdit

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(data = {}):
	_parent = get_parent()
	if data.has("from_node_id"):
		_from_node_id = data.from_node_id
		_from_node = _parent.get_node_from_id(data.from_node_id)
		_from_node.position_offset_changed.connect(_on_position_offset_changed)
	if data.has("to_node_id"):
		_to_node_id = data.to_node_id
		_to_node = _parent.get_node_from_id(data.to_node_id)
		_to_node.position_offset_changed.connect(_on_position_offset_changed)
	if data.has("text"):
		line_edit.text = data.text
	if data.has("color_theme"):
		color_theme = data.color_theme
	else:
		color_theme = _parent.default_line_color_theme
	if data.has("id"):
		id = data.id
	if data.has("selectable"): #ロック
		if !data.selectable:
			context_menu.set_item_checked.bind(0,true).call_deferred()
	if data.has("position_offset_x"):
		position_offset.x = data.position_offset_x
	if data.has("position_offset_y"):
		position_offset.y = data.position_offset_y

	if !data.has("position_offset_x"): #新規作成は空になってるのでそれで判定しておく、jsonロードはそうならない
		id = get_instance_id()

	locked_button.icon = _parent.get_icon("Lock")
	locked_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))

	size = Vector2(size.x,size.x)

#	line_edit.add_theme_font_size_override("font_size", int(size.y/1.5))

	_on_changed_color_context_menu(color_theme)

	context_menu.transient = !_parent.is_window
	context_menu.always_on_top = _parent.is_window

func _ready():
	position_offset_changed.connect(_on_position_offset_changed)

	line_edit.focus_exited.connect(_on_focus_exited_line_edit)

#	ロック
	locked_button.pressed.connect(_on_pressed_locked_button)

#	右クリックメニュー
	context_menu.toggle_lock_selected.connect(_on_toggle_lock_selected_context_menu)
	context_menu.changed_color.connect(_on_changed_color_context_menu)

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.double_click:
		#drag start
		if event.pressed:
#			selected = true
			drag_start = position_offset
			mouse_drag_start = get_local_mouse_position()
			dragging = true
		#reorder nodes so selected group is on top of other groups

			# グループを後ろに、その他を前に持っていく
			for node in get_parent().get_children():
				if node is GraphNode and node.graph_node_type == "Group" and node != self:
					node.move_to_front.call_deferred()
			move_to_front()
			for node in get_parent().get_children():
				if node is GraphNode and node.graph_node_type != "Group" and node != self:
					node.move_to_front.call_deferred()
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

#	ダブルクリック
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.double_click:
		_on_pressed_icon_button()

func _on_position_offset_changed():
	var to_pos = ((_from_node.position_offset - self.position_offset + _from_node.size / 2) / _parent.zoom ) * _parent.zoom
	var self_pos = size / 2
	var from_pos = ((_to_node.position_offset - self.position_offset + _to_node.size / 2) / _parent.zoom ) * _parent.zoom
	line_2d.clear_points()
	line_2d.add_point(to_pos)
	line_2d.add_point(self_pos)
	line_2d.add_point(from_pos)

func _on_toggle_lock_selected_context_menu(is_enabled:bool):
	if is_enabled:
		self.selectable = false
		locked_button.visible = true
	else:
		_on_pressed_locked_button()

func _on_pressed_locked_button():
	context_menu.set_item_checked(0, false)#ロックのチェックを外す
	locked_button.visible = false
	self.selectable = true
	size = Vector2(_parent.snap_distance, _parent.snap_distance) * 2


func _on_changed_color_context_menu(color_str:String):
	color_theme = color_str
	var line_grad:Gradient
	var handle_style_box:StyleBoxFlat
	var selected_handle_style_box:StyleBoxFlat
	var font_color:Color
	var bg_style:StyleBox
	var bg_style_focus:StyleBox
	match color_theme:
		"White":
			line_grad = preload("res://addons/godot-project-design-links/theme/white_gradient.tres")
			handle_style_box = preload("res://addons/godot-project-design-links/theme/line_handle_frame_white_stylebox.tres")
			selected_handle_style_box = preload("res://addons/godot-project-design-links/theme/line_handle_selected_white_stylebox.tres")
			font_color = Color.from_string("393939",Color.WHITE)
			bg_style = preload("res://addons/godot-project-design-links/theme/text_light_title_line_edit.tres")
			bg_style_focus = preload("res://addons/godot-project-design-links/theme/text_light_title_selected_line_edit.tres")
		"Black":
			line_grad = preload("res://addons/godot-project-design-links/theme/black_gradient.tres")
			handle_style_box = preload("res://addons/godot-project-design-links/theme/line_handle_frame_black_stylebox.tres")
			selected_handle_style_box = preload("res://addons/godot-project-design-links/theme/line_handle_selected_black_stylebox.tres")
			font_color = Color.from_string("ccced1",Color.WHITE)
			bg_style = preload("res://addons/godot-project-design-links/theme/text_dark_title_line_edit.tres")
			bg_style_focus = preload("res://addons/godot-project-design-links/theme/text_dark_title_selected_line_edit.tres")
	line_2d.gradient = line_grad
	add_theme_stylebox_override("frame",handle_style_box)
	add_theme_stylebox_override("selected_frame",selected_handle_style_box)

	line_edit.add_theme_color_override("font_color",font_color)
	line_edit.add_theme_color_override("caret_color",font_color)
	line_edit.add_theme_stylebox_override("normal",bg_style)
	line_edit.add_theme_stylebox_override("focus",bg_style_focus)

	# 初期設定色テーマを置き換える
	_parent.default_line_color_theme = color_theme
	_parent.set_dirty()

func _on_pressed_icon_button():
	line_edit.grab_focus()
	line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	line_edit.mouse_default_cursor_shape = Control.CURSOR_IBEAM
func _on_focus_exited_line_edit():
	line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line_edit.mouse_default_cursor_shape = Control.CURSOR_MOVE
	line_edit.size.x = 0
	self.size.x = 0

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
		"node" : "LineHandle",
		"id" : id,
		"selectable" : selectable,
		"position_offset_x" : position_offset.x,
		"position_offset_y" : position_offset.y,
		"color_theme" : color_theme,
		"text" : line_edit.text,
		"from_node_id" : _from_node_id,
		"to_node_id" : _to_node_id,
	}
	return data

func change_text_font(header_font_size,label_font_size):
	line_edit.add_theme_font_size_override("font_size", header_font_size)

func lock():
#	_on_index_pressed(index:int):の処理
	context_menu.set_item_checked(0, true)
	context_menu.toggle_lock_selected.emit(context_menu.is_item_checked(0))

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
