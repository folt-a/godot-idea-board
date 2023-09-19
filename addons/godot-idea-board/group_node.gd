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
const select_icon = preload("res://addons/godot-idea-board/icon/tool_select.svg")
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var _parent:GraphEdit

var id:int

var snap: = true
var drag_start = null
var mouse_drag_start
var dragging: = false
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _children = []
var graph_node_type = "Group"
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var margin_container = $MarginContainer

@onready var icon_texture_rect:TextureRect = %IconTextureRect
@onready var select_button:Button = %SelectButton
@onready var header_line_edit:LineEdit = %HeaderLineEdit
@onready var context_menu:PopupMenu = $ContextMenu

@onready var locked_button:Button = %LockedButton

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(data = {}):
	_parent = get_parent()
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
	if data.has("size_x"):
		size.x = data.size_x
	if data.has("size_y"):
		size.y = data.size_y
	if data.has("header_text"):
		header_line_edit.text = data.header_text

	if !data.has("position_offset_x"): #新規作成は空になってるのでそれで判定しておく、jsonロードはそうならない
		id = get_instance_id()

#	# 選択アイコンは大きい方がうれしいので2倍にする
#	var select_icon_image:Image = _parent.get_icon("ToolSelect").get_image()
#	select_icon_image.resize(select_icon_image.get_width() * 2, select_icon_image.get_height() * 2)
#	var select_icon = ImageTexture.create_from_image(select_icon_image)
	select_button.icon = select_icon
	select_button.add_theme_color_override("icon_normal_color", Color.from_string("65b5ff",Color.WHITE))
	select_button.add_theme_color_override("icon_pressed_color", Color.from_string("65b5ff",Color.WHITE))
	select_button.add_theme_color_override("icon_hover_color", Color.from_string("65b5ff",Color.WHITE))
	select_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("65b5ff",Color.WHITE))
	select_button.add_theme_color_override("icon_focus_color", Color.from_string("65b5ff",Color.WHITE))

#	icon_texture_rect.texture = _parent.get_icon("Window")
	locked_button.icon = _parent.get_icon("Lock")
	locked_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_pressed_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_focus_color", Color.from_string("fada79",Color.WHITE))

	context_menu.transient = !_parent.is_window
	context_menu.always_on_top = _parent.is_window

func _ready():
	for item in get_titlebar_hbox().get_children():
		item.visible = false
		item.size = Vector2.ZERO
	get_titlebar_hbox().visible = false
	get_titlebar_hbox().size = Vector2.ZERO
	header_line_edit.focus_exited.connect(_on_focus_exited_header_line_edit)
	resize_request.connect(_on_resize_request)
	select_button.pressed.connect(_on_pressed_select_button)
	locked_button.pressed.connect(_on_pressed_locked_button)

#	context_menu events
	context_menu.copied.connect(_on_copied_context_menu)
	context_menu.deleted.connect(_on_deleted_context_menu)
	context_menu.edit_title_selected.connect(_on_edit_title_selected_context_menu)
	context_menu.toggle_lock_selected.connect(_on_toggle_lock_selected_context_menu)
	context_menu.group_locked.connect(_on_group_locked_context_menu)
	context_menu.group_unlocked.connect(_on_group_unlocked_context_menu)


#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

func _gui_input(event):
	if !selectable:
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
				var this_rect:Rect2i = Rect2i(position_offset + mouse_drag_start,get_local_mouse_position() - mouse_drag_start).abs()
				for node in _get_group_nodes(this_rect):
					node.selected = true
				queue_redraw()
	#drag selected node
	elif dragging and event is InputEventMouseMotion:
#		position_offset += get_local_mouse_position() - mouse_drag_start
#		if snap:
#			position_offset = get_parent().snap(position_offset)
		get_parent().set_dirty()
	# コンテキストメニューを表示する
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_RIGHT\
	and !event.pressed\
	and selectable:
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
	and event.double_click\
	and selectable:
		_on_double_pressed_header_line_edit()

func _on_resize_request(new_minsize):
	_resize(new_minsize)

func _on_pressed_select_button():
	selected = true
	for node in _get_group_nodes():
		node.selected = true
	select_button.release_focus()
	_parent.grab_focus.call_deferred()

func _on_double_pressed_header_line_edit():
	header_line_edit.grab_focus()
	header_line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	header_line_edit.mouse_default_cursor_shape = Control.CURSOR_IBEAM

func _on_focus_exited_header_line_edit():
	header_line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header_line_edit.mouse_default_cursor_shape = Control.CURSOR_MOVE

func _on_copied_context_menu():
	var data = get_data()
	data.position_offset_x = 0
	data.position_offset_y = 0
	DisplayServer.clipboard_set(JSON.stringify([data]))

func _on_deleted_context_menu():
	_parent.delete_node(self)

func _on_edit_title_selected_context_menu():
	_on_double_pressed_header_line_edit()

func _on_toggle_lock_selected_context_menu(is_enabled:bool):
	if is_enabled:
		locked_button.visible = true
		self.selectable = false
#		self.mouse_filter = Control.MOUSE_FILTER_IGNORE
#		margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		self.mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		_on_pressed_locked_button()

## 範囲内のロックをする
func _on_group_locked_context_menu():

	for node in _get_group_nodes():
		node.context_menu.set_item_checked.bind(0,true).call_deferred()
		node._on_toggle_lock_selected_context_menu.bind(true).call_deferred()
	self.context_menu.set_item_checked.bind(0,true).call_deferred()
	self._on_toggle_lock_selected_context_menu.bind(true).call_deferred()

## 範囲内のロック解除をする
func _on_group_unlocked_context_menu():
	for node in _get_group_nodes():
		node._on_pressed_locked_button()
	self._on_pressed_locked_button()

func _on_pressed_locked_button():
	context_menu.set_item_checked(0, false)#ロックのチェックを外す
	locked_button.visible = false
	self.selectable = true
#	self.mouse_filter = Control.MOUSE_FILTER_STOP
#	margin_container.mouse_filter = Control.MOUSE_FILTER_PASS
	self.mouse_default_cursor_shape = Control.CURSOR_MOVE

func _draw():
	if dragging:
		draw_rect(Rect2i(mouse_drag_start,get_local_mouse_position() - mouse_drag_start),Color(0, 1, 1, 0.5),true)

func _process(delta):
	if dragging:
		queue_redraw()

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
		"node" : "Group",
		"id" : id,
		"selectable" : selectable,
		"position_offset_x" : position_offset.x,
		"position_offset_y" : position_offset.y,
		"size_x" : size.x,
		"size_y" : size.y,
		"header_text" : header_line_edit.text,
	}
	return data

func is_node_child(node,this_rect):
	# 全点が矩形内にはいっているか確認する
	var node_points = [
		node.position_offset,
		Vector2(node.position_offset.x + node.size.x,node.position_offset.y),
		Vector2(node.position_offset.x,node.position_offset.y + node.size.y),
		node.position_offset + node.size,
		]
	var is_intersect:bool = this_rect.has_point(node_points[0])\
	and this_rect.has_point(node_points[1])\
	and this_rect.has_point(node_points[2])\
	and this_rect.has_point(node_points[3])
	return is_intersect and node != self

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
	self.custom_minimum_size = get_parent().snap(size)
	self.size = get_parent().snap(size)
	get_parent().set_dirty()

func _get_group_nodes(this_rect:Rect2i = Rect2i()):
	if this_rect == Rect2i():
		this_rect = Rect2i(position_offset,size)
	var nodes = []
	for child in _parent.get_children():
		if child is GraphNode:
			if is_node_child(child,this_rect):
				nodes.append(child)
	return nodes

#func on_file_node_moved(node):
#	if is_node_child(node):
#		if not _children.has(node):
#			_children.append(node)
#	else:
#		if _children.has(node):
#			_children.erase(node)
