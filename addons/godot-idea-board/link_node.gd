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

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var target_id:int
var target_icon:String
var graph_path:String
#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _parent:GraphEdit
var graph_node_type = "Link"
var id:int

var drag_start = null
var mouse_drag_start
var dragging: = false

#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var h_box_container = %HBoxContainer
@onready var icon_button:Button = %IconButton
@onready var target_line_edit:LineEdit = %TargetLineEdit
@onready var arrow_target_icon_button:Button = %ArrowTargetIconButton
@onready var target_icon_button:Button = %TargetIconButton
@onready var locked_button:Button = %LockedButton

@onready var context_menu:PopupMenu = $ContextMenu

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(data:Dictionary):
	_parent = get_parent()

	if data.has("id"):
		id = data.id
	if data.has("target_id"):
		target_id = data.target_id
	if data.has("target_icon"):
		target_icon = data.target_icon
		target_icon_button.icon = _parent.get_icon(data.target_icon)
		target_icon_button.add_theme_color_override("icon_normal_color", Color.from_string("333",Color.WHITE))
		target_icon_button.add_theme_color_override("icon_pressed_color", Color.from_string("333",Color.WHITE))
		target_icon_button.add_theme_color_override("icon_hover_color", Color.from_string("333",Color.WHITE))
		target_icon_button.add_theme_color_override("icon_hover_pressed_color", Color.from_string("333",Color.WHITE))
		target_icon_button.add_theme_color_override("icon_focus_color", Color.from_string("333",Color.WHITE))

	if data.has("graph_path"):
		graph_path = data.graph_path
	if data.has("name"):
		target_line_edit.text = data.name
	if data.has("graph_path") and data.has("name"):
#		対象レイアウトが現在と別なら名前につける
		if data.graph_path != _parent.save_json_file_path:
			var filebasename = data.graph_path.get_file().left(-5)
			target_line_edit.text = filebasename + ":" + data.name


	if data.has("selectable"): #ロック
		if !data.selectable:
			context_menu.set_item_checked.bind(0,true).call_deferred()
			_on_toggle_lock_selected_context_menu.bind(true).call_deferred()
	if data.has("position_offset_x"):
		position_offset.x = data.position_offset_x
	if data.has("position_offset_y"):
		position_offset.y = data.position_offset_y

	if !data.has("position_offset_x"): #新規作成は空になってるのでそれで判定しておく、jsonロードはそうならない
		id = get_instance_id()

	icon_button.icon = _parent.get_icon("SphereShape3D")

	arrow_target_icon_button.icon = _parent.get_icon("ArrowRight")

	locked_button.icon = _parent.get_icon("Lock")
	locked_button.add_theme_color_override("icon_normal_color", Color.from_string("fada79",Color.WHITE))
	locked_button.add_theme_color_override("icon_hover_color", Color.from_string("fada79",Color.WHITE))

func _ready():
	for item in get_titlebar_hbox().get_children():
		item.visible = false
		item.size = Vector2.ZERO
	get_titlebar_hbox().visible = false
	get_titlebar_hbox().size = Vector2.ZERO
	icon_button.pressed.connect(_on_pressed_icon_button)
	target_icon_button.pressed.connect(_on_pressed_icon_button)
	arrow_target_icon_button.pressed.connect(_on_pressed_icon_button)


#	ロック
	locked_button.pressed.connect(_on_pressed_locked_button)

	target_line_edit.focus_exited.connect(_on_focus_exited_target_line_edit)
#	右クリックメニュー
	context_menu.copied.connect(_on_copied_context_menu)
	context_menu.deleted.connect(_on_deleted_context_menu)
	context_menu.toggle_lock_selected.connect(_on_toggle_lock_selected_context_menu)

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
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
		_focus_edit()

func _focus_edit():
	target_line_edit.grab_focus()
	target_line_edit.mouse_filter = Control.MOUSE_FILTER_STOP
	target_line_edit.mouse_default_cursor_shape = Control.CURSOR_IBEAM
func _on_focus_exited_target_line_edit():
	target_line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	target_line_edit.mouse_default_cursor_shape = Control.CURSOR_MOVE

## ジャンプする
func _on_pressed_icon_button():
	_parent.link_jump(graph_path,target_id)

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
		locked_button.visible = true
	else:
		_on_pressed_locked_button()
	pass

func _on_pressed_locked_button():
	context_menu.set_item_checked(0, false)#ロックのチェックを外す
	locked_button.visible = false
	self.selectable = true
	size = Vector2.ZERO

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
	var data_name = target_line_edit.text.trim_prefix(graph_path.get_file().left(-5) + ":")
	var data = {
		"node" : "Link",
		"id" : id,
		"name" : data_name,
		"selectable" : selectable,
		"position_offset_x" : position_offset.x,
		"position_offset_y" : position_offset.y,
		"target_id" : target_id,
		"target_icon" : target_icon,
		"graph_path" : graph_path
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
