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

var line_handle_node = load("res://addons/godot-idea-board/line_handle_node.tscn")

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var _parent:GraphEdit

var id:int

var color_theme ="White"

var snap: = true
var drag_start = null
var mouse_drag_start
var dragging: = false

const context_menu_class = preload("res://addons/godot-idea-board/context_menu/line_handle_menu.gd")

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _children = []
var graph_node_type = "LineHandle"

var _from_node:GraphNode
var _to_node:GraphNode
var from_node_id
var to_node_id

var arrow_dir_from
var arrow_dir_to
var arrow_type:String = ""

var is_main_handle:bool = true
var handle_node_ids:Array[int] = []
var handle_nodes:Array[GraphNode] = []
var main_handle:GraphNode
var main_handle_id

var _is_show_arrow_from:bool = false
var _is_show_arrow_to:bool = false

var _line_color:Color

var _curve = Curve2D.new()
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var context_menu:PopupMenu = $ContextMenu
@onready var line_2d:Line2D = $Line2D
@onready var locked_button = %LockedButton
@onready var line_edit = %LineEdit
@onready var arrow_from = $ArrowFrom
@onready var arrow_to = $ArrowTo

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func init(data = {}):
	_parent = get_parent()

#	複数ハンドル
	if !data.has("is_main_handle"):
		#後方互換
		data.is_main_handle = true
		if data.has("id") and data.id != null:
			id = data.id
		else:
			data.id = get_instance_id()
		data.handle_node_ids = str(data.id)
		data.handle_nodes = [self]
	if data.has("is_main_handle"):
		is_main_handle = data.is_main_handle

		if is_main_handle:
#			自分を含む表示ハンドル カンマ区切り
			if data.has("handle_node_ids") and data.handle_node_ids != "":
				var ids:PackedStringArray = data.handle_node_ids.split(",")
				var ids_int:Array[int] = []
				for s in ids:
					ids_int.append(s.to_int())
				handle_node_ids = ids_int
#				まだない可能性があるので次のフレームで初期化する
				init_handles.call_deferred()
		elif data.has("main_handle_id"):
#			これはサブハンドル
			main_handle_id = data.main_handle_id
			main_handle = _parent.get_node_from_id(data.main_handle_id)
			data.is_show_arrow_from = false
			data.is_show_arrow_to = false
#			色を変えるTODO

	if data.has("from_node_id"):
		from_node_id = data.from_node_id
		_from_node = _parent.get_node_from_id(data.from_node_id)
		if _from_node:
			_from_node.position_offset_changed.connect(_on_position_offset_changed)
	if data.has("to_node_id"):
		to_node_id = data.to_node_id
		_to_node = _parent.get_node_from_id(data.to_node_id)
		if _to_node:
			_to_node.position_offset_changed.connect(_on_position_offset_changed)
	if data.has("text"):
		line_edit.text = data.text
	if data.has("is_show_editable_text"): #テキスト編集化
		if data.is_show_editable_text:
			context_menu.set_item_checked.bind(context_menu_class.INDEX_IS_SHOW_EDITABLE_TEXT,true).call_deferred()
			set_deferred("size",Vector2.ZERO)
		else:
			set_deferred("size",Vector2(size.x,size.x))
		_on_toggle_show_editable_text_context_menu(data.is_show_editable_text)
	elif data.has("is_hide_editable_text"): #テキスト編集化
		if data.is_hide_editable_text:
			context_menu.set_item_checked.bind(context_menu_class.INDEX_IS_SHOW_EDITABLE_TEXT,true).call_deferred()
			set_deferred("size",Vector2.ZERO)
		else:
			set_deferred("size",Vector2(size.x,size.x))
		_on_toggle_show_editable_text_context_menu(data.is_hide_editable_text)
	else:
		set_deferred("size",Vector2.ZERO)
		context_menu.set_item_checked.bind(context_menu_class.INDEX_IS_SHOW_EDITABLE_TEXT,false).call_deferred()
		_on_toggle_show_editable_text_context_menu(false)

	if data.has("is_show_arrow_from"):
		_is_show_arrow_from = data.is_show_arrow_from
		arrow_from.visible = _is_show_arrow_from
		if data.is_show_arrow_from:
			context_menu.set_item_checked.bind(context_menu_class.INDEX_IS_SHOW_ARROW_FROM,true).call_deferred()

	if data.has("is_show_arrow_to"):
		_is_show_arrow_to = data.is_show_arrow_to
		arrow_to.visible = _is_show_arrow_to
		if data.is_show_arrow_to:
			context_menu.set_item_checked.bind(context_menu_class.INDEX_IS_SHOW_ARROW_TO,true).call_deferred()
	else:
#		デフォルトは終端矢印
		_is_show_arrow_to = true
		context_menu.set_item_checked.bind(context_menu_class.INDEX_IS_SHOW_ARROW_TO,true).call_deferred()

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

#	arrow_from.size = Vector2(_parent.snapping_distance, _parent.snapping_distance) * 3
#	arrow_to.size = Vector2(_parent.snapping_distance, _parent.snapping_distance) * 3


#	line_edit.add_theme_font_size_override("font_size", int(size.y/1.5))

	context_menu.transient = !_parent.is_window
	context_menu.always_on_top = _parent.is_window

	await get_tree().create_timer(0.1).timeout
	_on_changed_color_context_menu.bind(color_theme).call_deferred()
	_on_position_offset_changed()

func init_handles():
	handle_nodes = []
	for handle_node_id in handle_node_ids:
		handle_nodes.append(_parent.get_node_from_id(handle_node_id))

func _ready():
	for item in get_titlebar_hbox().get_children():
		item.visible = false
		item.size = Vector2.ZERO
	get_titlebar_hbox().visible = false
	get_titlebar_hbox().size = Vector2.ZERO
	position_offset_changed.connect(_on_position_offset_changed)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	line_edit.focus_exited.connect(_on_focus_exited_line_edit)

#	ロック
	locked_button.pressed.connect(_on_pressed_locked_button)

#	右クリックメニュー
	context_menu.copied.connect(_on_copied_context_menu)
	context_menu.deleted.connect(_on_deleted_context_menu)
	context_menu.toggle_lock_selected.connect(_on_toggle_lock_selected_context_menu)
	context_menu.added_point.connect(_on_added_point_context_menu)
#	context_menu.removed_point.connect(_on_removed_point_context_menu)
	context_menu.changed_color.connect(_on_changed_color_context_menu)
	context_menu.toggle_hide_editable_text.connect(_on_toggle_show_editable_text_context_menu)

	context_menu.toggle_show_arrow_from.connect(_on_toggle_show_arrow_from_context_menu)
	context_menu.toggle_show_arrow_to.connect(_on_toggle_show_arrow_to_context_menu)

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

			# # グループを後ろに、その他を前に持っていく
			# for node in get_parent().get_children():
			# 	if node is GraphNode and node.graph_node_type == "Group" and node != self:
			# 		node.move_to_front.call_deferred()
			# move_to_front()
			# for node in get_parent().get_children():
			# 	if node is GraphNode and node.graph_node_type != "Group" and node != self:
			# 		node.move_to_front.call_deferred()
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
		var pa = _parent.get_parent()
		if is_main_handle:
			context_menu.popup()
			if pa is Window: #PopupGraphならWindowのぶんずらす
				context_menu.position = DisplayServer.mouse_get_position() + pa.position
			else:
				context_menu.position = DisplayServer.mouse_get_position()
		else:
			main_handle.context_menu.popup()
			if pa is Window: #PopupGraphならWindowのぶんずらす
				main_handle.context_menu.position = DisplayServer.mouse_get_position() + pa.position
			else:
				main_handle.context_menu.position = DisplayServer.mouse_get_position()
		_parent.penetrate_nodes()

#	ダブルクリック
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.double_click:
		_on_pressed_icon_button()

func get_intersect_point(self_pos, node, pos) -> Vector2:
	# GraphNodeの矩形と交わる交点を取る
	# 矩形の4つの辺と
	var from_pos_ori = node.position_offset - self.position_offset
	var from_tl = from_pos_ori
	var from_tr = from_pos_ori + Vector2(node.size.x,0)
	var from_bl = from_pos_ori + Vector2(0,node.size.y)
	var from_br = from_pos_ori + Vector2(node.size.x,node.size.y)

	var from_top = Geometry2D.segment_intersects_segment(pos,self_pos,from_tl, from_tr)
	var from_left = Geometry2D.segment_intersects_segment(pos,self_pos,from_tl, from_bl)
	var from_right = Geometry2D.segment_intersects_segment(pos,self_pos,from_tr, from_br)
	var from_bottom = Geometry2D.segment_intersects_segment(pos,self_pos,from_bl, from_br)

#	一番近い交点を求める 近かったら上書きしていく
	var from_intersect_point:Vector2 = Vector2.ZERO
	var from_distance:float = 999999999.0
	if from_top is Vector2:
		from_distance = pos.distance_to(from_top)
		from_intersect_point = from_top + Vector2(0, -(_parent.snapping_distance + 12))

	if from_left is Vector2 and pos.distance_to(from_left) < from_distance:
		from_distance = pos.distance_to(from_left)
		from_intersect_point = from_left + Vector2(-(_parent.snapping_distance + 12),0)

	if from_right is Vector2 and pos.distance_to(from_right) < from_distance:
		from_distance = pos.distance_to(from_right)
		from_intersect_point = from_right + Vector2((_parent.snapping_distance + 12),0)

	if from_bottom is Vector2 and pos.distance_to(from_bottom) < from_distance:
		from_distance = pos.distance_to(from_bottom)
		from_intersect_point = from_bottom + Vector2(0, (_parent.snapping_distance + 12))

	return from_intersect_point

func _on_position_offset_changed():
	if !is_main_handle and main_handle != null:
#		サブハンドルならメインハンドルを発火して再描画してもらう
		main_handle._on_position_offset_changed()
		return
	if !_from_node or !_to_node: return

	var from_pos = ((_from_node.position_offset - self.position_offset + _from_node.size / 2) / _parent.zoom ) * _parent.zoom
	var self_pos = size / 2
	var to_pos = ((_to_node.position_offset - self.position_offset + _to_node.size / 2) / _parent.zoom ) * _parent.zoom

	arrow_from.visible = _is_show_arrow_from
	arrow_to.visible = _is_show_arrow_to

	line_2d.clear_points()

	if handle_node_ids.is_empty():
#		中継点ハンドルなし
		var from_to_dir = from_pos.direction_to(to_pos)

		var from_intersect_point = get_intersect_point(self_pos + to_pos, _from_node, from_pos)
		var to_intersect_point = get_intersect_point(self_pos + from_pos, _to_node, to_pos)

		line_2d.add_point(from_intersect_point)
		line_2d.add_point(to_intersect_point)
	#	矢印の向きを変更
		arrow_from.position = from_intersect_point
		arrow_from.rotation = to_intersect_point.angle_to_point(from_intersect_point)
		arrow_to.position = to_intersect_point
		arrow_to.rotation = from_intersect_point.angle_to_point(to_intersect_point)
	else:
#		中継点ハンドルあり
#		[from] -> [main] -> (...[sub]...) -> [to]
		if handle_nodes.is_empty(): return
		var from_intersect_point = get_intersect_point(self_pos, _from_node, from_pos)

		var rely_points:Array[Vector2] = []
		for handle_node in handle_nodes:
			var rely_pos = ((handle_node.position_offset - self.position_offset + handle_node.size / 2) / _parent.zoom ) * _parent.zoom
			rely_points.append(rely_pos)

		var first_pos = ((handle_nodes[0].position_offset - self.position_offset + handle_nodes[0].size / 2) / _parent.zoom ) * _parent.zoom
		var last_pos = ((handle_nodes.back().position_offset - self.position_offset + handle_nodes.back().size / 2) / _parent.zoom ) * _parent.zoom
		var to_intersect_point = get_intersect_point(last_pos, _to_node, to_pos)

	#	矢印の向きを変更
		arrow_from.position = from_intersect_point
		arrow_from.rotation = first_pos.angle_to_point(from_intersect_point)
		arrow_to.position = to_intersect_point
		arrow_to.rotation = last_pos.angle_to_point(to_intersect_point)

		line_2d.add_point(from_intersect_point)
		for rely_point in rely_points:
			line_2d.add_point(rely_point)
		line_2d.add_point(to_intersect_point)

func _on_mouse_entered():
	if is_main_handle:
		line_2d.width = 20.0
	else:
		main_handle._on_mouse_entered()

func _on_mouse_exited():
	if is_main_handle:
		line_2d.width = 10.0
	else:
		main_handle._on_mouse_exited()

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

func _on_pressed_locked_button():
	context_menu.set_item_checked(0, false)#ロックのチェックを外す
	locked_button.visible = false
	self.selectable = true
	size = Vector2(_parent.snapping_distance, _parent.snapping_distance) * 2

func _on_added_point_context_menu():
#	1つ目はサブハンドルを追加せず自分自身の表示切替のみ。
	if handle_node_ids.is_empty():
		handle_node_ids.append(id)
		handle_nodes.append(self)
		_on_position_offset_changed()
		return

	var node = line_handle_node.instantiate()
	_parent.add_child(node)
	node.init({
		"id": node.get_instance_id(),
		"from_node_id": -1,
		"to_node_id": -1,
		"is_main_handle": false,
		"main_handle_id": id
		})
	handle_node_ids.append(node.get_instance_id())

	## 2点の真ん中に置く
	var from = handle_nodes.back()
	handle_nodes.append(node)
	var pos_1 = from.position_offset + (from.size / 2)
	var pos_2 = _to_node.position_offset + (_to_node.size / 2)
	node.position_offset = (pos_1 + pos_2) / 2

#func _on_removed_point_context_menu():
#	if handle_node_ids.is_empty(): return
#
##	1個なら自分の切替のみ
#	if handle_node_ids.size() == 1:
#		handle_node_ids = []
#		handle_nodes = []
#		_on_position_offset_changed()
#		return
#
#	var remove_node = handle_nodes.pop_back()
#	var remove_node_id = handle_node_ids.pop_back()
#	remove_node.queue_free()

func _on_changed_color_context_menu(color_str:String):
	for node in handle_nodes:
		if node != self:
			node._on_changed_color_context_menu.bind(color_str).call_deferred()

	color_theme = color_str
	var line_color:Color
	var handle_style_box:StyleBoxFlat
	var selected_handle_style_box:StyleBoxFlat
	var font_color:Color
	var bg_style:StyleBox
	var bg_style_focus:StyleBox
	match color_theme:
		"White":
#			line_grad = preload("res://addons/godot-idea-board/theme/white_gradient.tres")
			line_color = Color.WHITE_SMOKE
			handle_style_box = preload("res://addons/godot-idea-board/theme/line_handle_frame_white_stylebox.tres")
			selected_handle_style_box = preload("res://addons/godot-idea-board/theme/line_handle_selected_white_stylebox.tres")
			font_color = Color.from_string("393939",Color.WHITE)
			bg_style = preload("res://addons/godot-idea-board/theme/text_light_title_line_edit.tres")
			bg_style_focus = preload("res://addons/godot-idea-board/theme/text_light_title_selected_line_edit.tres")
		"Black":
#			line_grad = preload("res://addons/godot-idea-board/theme/black_gradient.tres")
			line_color = Color.from_string("393939",Color.WHITE)
			handle_style_box = preload("res://addons/godot-idea-board/theme/line_handle_frame_black_stylebox.tres")
			selected_handle_style_box = preload("res://addons/godot-idea-board/theme/line_handle_selected_black_stylebox.tres")
			font_color = Color.from_string("ccced1",Color.WHITE)
			bg_style = preload("res://addons/godot-idea-board/theme/text_dark_title_line_edit.tres")
			bg_style_focus = preload("res://addons/godot-idea-board/theme/text_dark_title_selected_line_edit.tres")
	line_2d.default_color = line_color
	arrow_from.modulate = line_color
	arrow_to.modulate = line_color
	add_theme_stylebox_override("frame",handle_style_box)
	add_theme_stylebox_override("selected_frame",selected_handle_style_box)

	line_edit.add_theme_color_override("font_color",font_color)
	line_edit.add_theme_color_override("caret_color",font_color)
	line_edit.add_theme_stylebox_override("normal",bg_style)
	line_edit.add_theme_stylebox_override("focus",bg_style_focus)

	# 初期設定色テーマを置き換える
	_parent.default_line_color_theme = color_theme
	_parent.set_dirty()

func _on_toggle_show_editable_text_context_menu(is_show):
	for node in handle_nodes:
		if node != self:
			node._on_toggle_show_editable_text_context_menu.bind(is_show).call_deferred()
	line_edit.visible = is_show
	if is_show:
		set_deferred("size",Vector2.ZERO)
	else:
		set_deferred("size",Vector2(_parent.snapping_distance, _parent.snapping_distance)*1.1)

	call_deferred("_on_position_offset_changed")

func _on_toggle_show_arrow_from_context_menu(is_show):
	_is_show_arrow_from = is_show
	_on_position_offset_changed()

func _on_toggle_show_arrow_to_context_menu(is_show):
	_is_show_arrow_to = is_show
	_on_position_offset_changed()

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
		"from_node_id" : from_node_id,
		"to_node_id" : to_node_id,
		"is_show_editable_text" : line_edit.visible,
		"is_show_arrow_from" : _is_show_arrow_from,
		"is_show_arrow_to" : _is_show_arrow_to,
		"is_main_handle" : is_main_handle,
		"main_handle_id" : main_handle_id,
		"handle_node_ids" : ""
	}
	if handle_node_ids.is_empty():
		data.handle_node_ids = ""
	else:
		var ids_str:Array = handle_node_ids.map(func(i): return str(i))
		data.handle_node_ids = ",".join(ids_str)
	return data

func change_text_font(header_font_size,label_font_size):
	line_edit.add_theme_font_size_override("font_size", header_font_size)

func lock():
#	_on_index_pressed(index:int):の処理
	context_menu.set_item_checked(0, true)
	context_menu.toggle_lock_selected.emit(context_menu.is_item_checked(0))

func remove():
	if is_main_handle:
		for handle_node in handle_nodes:
			handle_node.queue_free()
	else:
		main_handle.remove_sub_handle(id, self)

func remove_sub_handle(sub_id,sub_handle):
	if handle_node_ids.has(sub_id):
		handle_node_ids.erase(sub_id)
	if handle_nodes.has(sub_handle):
		handle_nodes.erase(sub_handle)
	_on_position_offset_changed()

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
