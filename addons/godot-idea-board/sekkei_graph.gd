#01. tool
@tool
#02. class_name

#03. extends
extends GraphEdit
#-----------------------------------------------------------
#04. # docstring
## hoge
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
var file_node = preload("res://addons/godot-idea-board/file_node.tscn")
var script_node = preload("res://addons/godot-idea-board/file_node.tscn")
var group_node = preload("res://addons/godot-idea-board/group_node.tscn")
var comment_node = preload("res://addons/godot-idea-board/comment_node.tscn")
var link_node = preload("res://addons/godot-idea-board/link_node.tscn")
var line_handle_node = preload("res://addons/godot-idea-board/line_handle_node.tscn")
#var main_font = preload("res://addons/godot-idea-board/font/ZenMaruGothic-Bold-Subset.ttf")

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var resource_previewer:EditorResourcePreview
var editor_interface:EditorInterface

var save_json_file_path:String = ""

var is_window:bool

var dirty = false
var _data_init_completed:bool  =false

var is_first:bool = false

## テキストの色テーマ初期設定
var default_text_color_theme = "TrLight"
var default_line_color_theme = "White"

var add_group: = false
var add_text_document: = false
var add_label: = false

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
var _main
var _canvas_menu

var _is_right_dragging:bool = false

var _selected_nodes:Array = []

@onready var _S = preload("res://addons/godot-idea-board/translation/translation.gd").get_translation_singleton(self)
#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var context_menu = $ContextMenu

@onready var _right_click_line:Line2D = $DragPath
@onready var _right_click_line_anim:AnimationPlayer = $DragPath/AnimationPlayer



#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func init(main):
	_main = main
	var hbox:HBoxContainer = get_menu_hbox()
	hbox.size_flags_horizontal = HBoxContainer.SIZE_EXPAND_FILL

	var canvas_menu = preload("res://addons/godot-idea-board/canvas_menu.tscn").instantiate()
	hbox.add_child(canvas_menu)
	canvas_menu.init(self)
	_canvas_menu = canvas_menu

	_canvas_menu.pressed_save_button.connect(_on_pressed_save_button)
	_canvas_menu.pressed_group_button.connect(_on_pressed_group_button)
	_canvas_menu.pressed_text_document_button.connect(_on_pressed_text_document_button)
	_canvas_menu.pressed_label_button.connect(_on_pressed_label_document_button)
	_canvas_menu.color_changed_bg_color_picker_button.connect(_on_color_changed_bg_color_picker_button)
	_canvas_menu.color_changed_grid_color_picker_button.connect(_on_color_changed_grid_color_picker_button)

	_canvas_menu.pressed_lock_button.connect(_on_pressed_lock_button)
	_canvas_menu.pressed_unlock_button.connect(_on_pressed_unlock_button)

	_canvas_menu.pressed_connect_button.connect(_on_pressed_connect_button)

	_canvas_menu.aligned.connect(_on_aligned)
	_canvas_menu.distribute_h_aligned.connect(_on_distribute_h_aligned)
	_canvas_menu.distribute_v_aligned.connect(_on_distribute_v_aligned)
	_canvas_menu.changed_volume.connect(_on_changed_volume)

	_canvas_menu.pressed_sound_play_button.connect(_on_pressed_sound_play_button)
	_canvas_menu.pressed_sound_stop_button.connect(_on_pressed_sound_stop_button)
	_canvas_menu.toggled_sound_loop_button.connect(_on_toggled_sound_loop_button)

	context_menu.init()

	context_menu.copied.connect(_on_copy_nodes_request)
	context_menu.pasted.connect(_on_paste_nodes_request)
	context_menu.deleted.connect(_on_delete_nodes_request)

	is_window = get_parent() is Window

func _ready():

	resized.connect(_on_resized)
	delete_nodes_request.connect(_on_delete_nodes_request)
	copy_nodes_request.connect(_on_copy_nodes_request)
	paste_nodes_request.connect(_on_paste_nodes_request)
	node_selected.connect(_on_node_selected)
	node_deselected.connect(_on_node_deselected)

	is_first = true
	await get_tree().create_timer(1).timeout
	is_first = false
	dirty = false



#	# TODO SCROLL ANIMATION
#	var bg_scrool_animation = get_node_or_null("MarginContainer/TextureRect/AnimationPlayer")
#	if bg_scrool_animation != null:
#		bg_scrool_animation.play("scroll")

#	エディタのWindowにファイルドロップのシグナルをつける おくらいり
#	get_viewport().files_dropped.connect(_on_files_dropped_editor_window)


#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _on_resized():
	pass

func _can_drop_data(at_position, data):
	return true

func _drop_data(at_position, data):
	at_position = snap(at_position / zoom) * zoom
	for file_path in data.files:
		var node:GraphNode
		if file_path.ends_with(".gd") or file_path.ends_with(".tscn"):
			node = _add_node(script_node, at_position)
		else:
			node = _add_node(file_node, at_position)
		node.init({"path" : file_path})
		if true:
		# 縦にずらす
			var y = node.size.y * zoom
			at_position += Vector2(0, y)
			at_position += Vector2(0, (int(at_position.y / zoom) % snapping_distance) * zoom)
		else:
			# 横にずらすようにする
			at_position += Vector2(node.size.x * zoom, 0)

		node.show()
		set_dirty()

func _on_delete_nodes_request(_nodes):
	var deleted_node_ids:= {}
	for child in get_children():
		if child is GraphNode:
			if child.selected and child.visible:
				delete_node(child)
				child.selected = false
				if "id" in child and child.id != 0:
					deleted_node_ids[child.id] = child.id

#	コネクトされたアイテムを消すとコネクトも消すようにする
	for child in get_children():
		if child is GraphNode:
			if child.graph_node_type == "LineHandle":
				if deleted_node_ids.has(child.from_node_id)\
				or deleted_node_ids.has(child.to_node_id):
					delete_node(child)
	set_dirty()

func _on_copy_nodes_request():
	var selected_nodes = _get_selected_graphnode()
	var datas = []

#	最も左上のノードの位置を基準にする
	var top_left = Vector2(9223372036854775800,9223372036854775800)
	for node in selected_nodes:
		var data = node.get_data()
		if top_left.x > data.position_offset_x:
			top_left.x = data.position_offset_x
		if top_left.y > data.position_offset_y:
			top_left.y = data.position_offset_y
		datas.append(data)

	for data in datas:
		data.position_offset_x = data.position_offset_x - top_left.x
		data.position_offset_y = data.position_offset_y - top_left.y
	DisplayServer.clipboard_set(JSON.stringify(datas))

func _on_paste_nodes_request():
	var clip_str = DisplayServer.clipboard_get()
	var json = JSON.new()
	var error = json.parse(clip_str)
	var datas := []
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			datas = data_received
		else:
			print("Unexpected data")
			return
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", clip_str, " at line ", json.get_error_line())
		return

#	ズームをいい感じにして位置を指定
	var mouse_pos = ((get_local_mouse_position()) + scroll_offset) / zoom
	mouse_pos = snap(mouse_pos / zoom) * zoom
	var filtered_datas := []
	for data in datas:
		data.position_offset_x = data.position_offset_x + mouse_pos.x
		data.position_offset_y = data.position_offset_y + mouse_pos.y
		if "node" in data and data.node == "LineHandle":
			pass
		else:
			filtered_datas.append(data)
	var added_nodes = _add_nodes(filtered_datas)

#	選択中のものは非選択にする
	for selected_node in _get_selected_graphnode():
		selected_node.selected = false

	for node in added_nodes:
#		IDを再取得
		node.id = node.get_instance_id()
		if node.selectable:
			node.selected = true

func _on_node_selected(node):
	if node is GraphNode and node.get_data().id:
		if !_selected_nodes.has(node.get_data().id):
			_selected_nodes.append(node.get_data().id)

func _on_node_deselected(node):
	if _selected_nodes.has(node.get_data().id):
		_selected_nodes.erase(node.get_data().id)

### OSエクスプローラーからのドラッグドロップでOSノードを作成する。　おくらいり
# https://twitter.com/Faultun/status/1588516067579940864?s=20&t=GraPUx9afeW6Qxb1iGL69Q
#func _on_files_dropped_editor_window(files: PackedStringArray):
#	if !get_parent().get_parent().visible: return true ## メインスクリーンが非表示の場合は処理しない！
#	if !self.visible: return true ## 非表示の場合は処理しない！
#	print(files)
#	print(self.name)
#	var file_dock:FileSystemDock = editor_interface.get_file_system_dock()
#	print(file_dock.name)
#	file_dock.print_tree_pretty()
#
#	for filepath in files:
##	OSディレクトリ
#		if DirAccess.dir_exists_absolute(filepath):
#			print("ディレクトリ")
##	OSファイル
#		elif FileAccess.file_exists(filepath):
#			print("ファイル")
#		else:
#			print(filepath)
#	accept_event()

func _on_file_removed(file_path):
	for child in get_children():
		if child is GraphNode and child.get("path") and child.path == file_path:
			_on_node_deselected(child)
			if child.graph_node_type == "LineHandle":
				child.remove()
			child.queue_free()
			set_dirty()


func _on_file_moved(old_file_path, new_file_path):
	for child in get_children():
		if child is GraphNode and child.get("path") and child.path == old_file_path:
			child.path = new_file_path
			child.init(new_file_path)
			set_dirty()


#func _notify_group_move():
#	#notify all groups of node moving
#	for group in get_children():
#		if group is GraphNode and group.graph_node_type == "Group":
#			for selected_node in get_children():
#				if selected_node is GraphNode and selected_node.selected:
#					group.on_file_node_moved(selected_node)

func _do_move(node, offset):
	node.position_offset = offset
#	_notify_group_move()


func _on_begin_node_move():
	for child in get_children():
		if child is GraphNode and child.selected:
			child.drag_start = child.position_offset


func _on_end_node_move():
	set_dirty()
	for child in get_children():
		if child is GraphNode and child.selected:
			_do_move(child, child.position_offset)

func _process(delta):
	if _is_right_dragging:
		_right_click_line.add_point(get_local_mouse_position())

func _gui_input(event):
	if !visible : return

	#	右クリックの軌跡
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_is_right_dragging = true
		_right_click_line_anim.play("blink")
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		penetrate_nodes()

	# 右クリックメニュー
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#create group node
			if add_group:
				add_group = false
				mouse_default_cursor_shape = Control.CURSOR_ARROW
				_add_common_node(group_node, get_local_mouse_position(), "Group")
			#create comment node
			elif add_text_document:
				add_text_document = false
				mouse_default_cursor_shape = Control.CURSOR_ARROW
				var node = _add_common_node(comment_node, get_local_mouse_position(), "TextDocument")
				var header_font_size = editor_interface.get_editor_theme().get_font_size("font_size","HeaderLarge")
				var label_font_size = editor_interface.get_editor_theme().get_font_size("font_size","Label")
				node.change_text_font(header_font_size,label_font_size)
			elif add_label:
				add_label = false
				mouse_default_cursor_shape = Control.CURSOR_ARROW
				var node = _add_common_node(comment_node, get_local_mouse_position(), "Label")
				var header_font_size = editor_interface.get_editor_theme().get_font_size("font_size","HeaderLarge") + 2
				var label_font_size = editor_interface.get_editor_theme().get_font_size("font_size","Label")
				node.change_text_font(header_font_size,label_font_size)
		# コンテキストメニューを表示する
		if event.button_index == MOUSE_BUTTON_RIGHT\
		and !event.pressed:
			context_menu.popup()
			var pa = get_parent()
			if pa is Window: #PopupGraphならWindowのぶんずらす
				context_menu.position = DisplayServer.mouse_get_position() + pa.position
			else:
				context_menu.position = DisplayServer.mouse_get_position()
			_is_right_dragging = false
			_right_click_line.clear_points()


#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func reset(json_data:Dictionary):
	clear()
	_data_init_completed = false
	if "default_text_color_theme" in json_data:
		default_text_color_theme = json_data.default_text_color_theme
	if "default_line_color_theme" in json_data:
		default_line_color_theme = json_data.default_line_color_theme
	if "data" in json_data:
		_add_nodes(json_data.data)
	if "snap_distance" in json_data:
		snapping_distance = json_data.snap_distance
	if "use_snap" in json_data:
		snapping_enabled = json_data.use_snap
	if "minimap_enabled" in json_data:
		minimap_enabled = json_data.minimap_enabled
	if "zoom" in json_data:
		zoom = json_data.zoom
	if "scroll_offset_x" in json_data:
		scroll_offset.x = json_data.scroll_offset_x


#	canvas_menu
	if "bg_color" in json_data:
		var color = Color.from_string(json_data.bg_color,Color.from_string("26292d",Color.BLACK))
		_canvas_menu.bg_color_picker_button.color = color
		_on_color_changed_bg_color_picker_button(color)
	else:
		var color = Color.from_string("26292d",Color.BLACK)
		_canvas_menu.bg_color_picker_button.color = color
		_on_color_changed_bg_color_picker_button(color)
	if "grid_color" in json_data:
		var color = Color.from_string(json_data.grid_color,Color.WHITE)
		_canvas_menu.grid_color_picker_button.color = color
		_on_color_changed_grid_color_picker_button(color)
	else:
		var color = Color(1,1,1,0.2)
		_canvas_menu.grid_color_picker_button.color = color
		_on_color_changed_grid_color_picker_button(color)
	if "sound_volume" in json_data:
		_canvas_menu.sound_h_slider.value = json_data.sound_volume
		_on_changed_volume(json_data.sound_volume)
	else:
		_canvas_menu.sound_h_slider.value = 0.3
		_on_changed_volume(0.3)

	await get_tree().create_timer(0.1).timeout # call_deferredより後にdirty有効化したい
	_data_init_completed = true
	is_first = true
	await get_tree().create_timer(1).timeout
	is_first = false
	dirty = false

func save():
	#delete hidden nodes (deleted)
	var datas := []
	for node in get_children():
		if node is GraphNode:
			if node.visible:
				datas.append(node.get_data())
			else:
				node.queue_free()
	var canvas_menu_data:Dictionary = _canvas_menu.get_data()
	var graph_edit_data:Dictionary = {
		"data" = datas,
		"snap_distance" = snapping_distance,
		"use_snap" = snapping_enabled,
		"minimap_enabled" = minimap_enabled,
		"zoom" = zoom,
		"scroll_offset_x" = scroll_offset.x,
		"scroll_offset_y" = scroll_offset.y,
		"default_text_color_theme" = default_text_color_theme,
		"default_line_color_theme" = default_line_color_theme,
	}
	graph_edit_data.merge(canvas_menu_data)

	var json_str = JSON.stringify(graph_edit_data)
	var file = FileAccess.open(save_json_file_path,FileAccess.WRITE)
	file.store_string(json_str)

	dirty = false

func snap(pos:Vector2):
	if snapping_enabled:
		pos = pos / snapping_distance
		pos = pos.floor() * snapping_distance
	return pos

func clear():
	for node in get_children():
		if node is GraphNode:
			node.queue_free()
	dirty = false

func delete_node(node):
	_on_node_deselected(node)
	node.queue_free()
	if node.graph_node_type == "LineHandle":
		node.remove()
	set_dirty()

func get_icon(icon_name:String) -> Texture:
	var theme_:Theme = editor_interface.get_editor_theme()
	if !theme_.has_icon(icon_name,"EditorIcons"): return theme_.get_icon("Object","EditorIcons")
	return theme_.get_icon(icon_name,"EditorIcons")

func get_color_rect_image(color:Color = Color.WHITE):
	var theme_:Theme = editor_interface.get_editor_theme()
	var tex:Texture2D = theme_.get_icon("Object","EditorIcons")
	var image:Image = tex.get_image()
	image.fill(color)
	return ImageTexture.create_from_image(image)

func make_edit(node:GraphNode) -> void:
	var text_node = _add_node(comment_node, node.position_offset * zoom)
	var data:Dictionary = node.get_data()
	data.node = "TextDocument"
	data.is_md = false
	if FileAccess.file_exists(data.path):
		var file := FileAccess.open(data.path,FileAccess.READ)
		data.header_text = data.path.get_file()
		data.text_edit_text = file.get_as_text()
	else:
		data.text_edit_text = "path " + data.path + "is not read."
	text_node.init(data)
	text_node.position_offset = Vector2(text_node.position_offset.x + text_node.size.x, text_node.position_offset.y)

func link_jump(graph_path:String, target_id:int):
	if save_json_file_path == graph_path:
		# 同GraphEdit内ジャンプ
		for node in get_children():
			if "id" in node and node.id == target_id:
				var current_zoom = zoom
				zoom = 1
				scroll_offset = node.position_offset - (size / 3)
				Vector2(snapping_distance * 4,snapping_distance * 4)
				zoom = current_zoom
	else:
		save()
		if _main.select_by_json_path(graph_path):
			link_jump.bind(graph_path, target_id).call_deferred()
	pass

func set_dirty():
	if _data_init_completed and !is_first:
		dirty = true

func get_node_from_id(id):
	if !id:return null
	for node in get_children():
		if node is GraphNode and node.get_data().id == id:
			return node
	return null

func penetrate_nodes():
	_is_right_dragging = false
	_right_click_line_anim.play("RESET")
	var through_nodes = []
	var through_points = []
	for graphnode in get_children():
		if graphnode is GraphNode\
		and graphnode.visible\
		and (
			graphnode.get_data().node != "LineHandle"
		):
#				選択中GraphNodeのポリゴンを取得
			var poly_lt = graphnode.position
			var poly_rt = Vector2(poly_lt.x + graphnode.get_rect().size.x, poly_lt.y)
			var poly_rb = Vector2(poly_lt.x + graphnode.get_rect().size.x, poly_lt.y + graphnode.get_rect().size.y)
			var poly_lb = Vector2(poly_lt.x, poly_lt.y + graphnode.get_rect().size.y)
			var poly:PackedVector2Array = PackedVector2Array([poly_lt,poly_rt,poly_rb,poly_lb])
			var intersect_points = Geometry2D.intersect_polyline_with_polygon(_right_click_line.points,poly)
			if 0 < intersect_points.size():
				through_nodes.append(graphnode)
				through_points.append(intersect_points[0][0])

	# 2つ以上通過していたら最初の２GraphNodeをつなげる 近い方から遠い方につなぐ
	if 2 <= through_nodes.size():

		# グループアイテムの場合は内部にないかチェックする
		if through_nodes[0].graph_node_type == "Group":
			if through_nodes[0].is_node_child(through_nodes[1]):
#				内部にあったらコネクタをつながない
				_right_click_line.clear_points()
				return
		if through_nodes[1].graph_node_type == "Group":
			if through_nodes[1].is_node_child(through_nodes[0]):
#				内部にあったらコネクタをつながない
				_right_click_line.clear_points()
				return

		var is_LtoR = Geometry2D.get_closest_point_to_segment(_right_click_line.points[0],through_points[0],through_points[1]) == through_points[0]
		var from_node
		var to_node
		if is_LtoR:
			from_node = through_nodes[0]
			to_node = through_nodes[1]
		else:
			from_node = through_nodes[1]
			to_node = through_nodes[0]
		var node = line_handle_node.instantiate()
		self.add_child(node)
		node.init({
			"from_node_id": from_node.get_data().id,
			"to_node_id": to_node.get_data().id,
			"is_main_handle": true
			})
		## 2点の真ん中に置く、ちょっとずらす
		var pos_1 = from_node.position_offset + from_node.size / 2
		var pos_2 = to_node.position_offset + to_node.size / 2
		node.position_offset = snap(((pos_1 + pos_2) / 2) + Vector2(snapping_distance, snapping_distance * 2))
		set_dirty()
	_right_click_line.clear_points()
	pass

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
func _add_nodes(datas:Array) -> Array:
	var added_nodes = []
	for data in datas:
		var node:GraphNode
		if data.node == "File":
			node = _add_node(file_node, Vector2.ZERO)
		elif data.node == "TextDocument" or data.node == "Label":
			node = _add_node(comment_node, Vector2.ZERO)
			var header_font_size = editor_interface.get_editor_theme().get_font_size("font_size","HeaderLarge")
			var label_font_size = editor_interface.get_editor_theme().get_font_size("font_size","Label")
			node.change_text_font(header_font_size,label_font_size)
		elif data.node == "Group":
			node = _add_node(group_node, Vector2.ZERO)
		elif data.node == "Link":
			node = _add_node(link_node, Vector2.ZERO)
		else:
			continue
		node.init(data)
		added_nodes.append(node)

#	LineHandleは最後に追加する(他のGraphNodeIDからGraphNodeを取得するので)
	for data in datas:
		if data.node == "LineHandle" and (!data.has("is_main_handle") or data.is_main_handle):
			var node:GraphNode = _add_node(line_handle_node, Vector2.ZERO)
			var header_font_size = editor_interface.get_editor_theme().get_font_size("font_size","HeaderLarge")
			var label_font_size = editor_interface.get_editor_theme().get_font_size("font_size","Label")
			node.change_text_font(header_font_size,label_font_size)
			node.init(data)
#			node.position_offset_changed.emit()
			added_nodes.append(node)
#	サブハンドル
	for data in datas:
		if data.node == "LineHandle" and data.has("is_main_handle") and !data.is_main_handle:
			var node:GraphNode = _add_node(line_handle_node, Vector2.ZERO)
			var header_font_size = editor_interface.get_editor_theme().get_font_size("font_size","HeaderLarge")
			var label_font_size = editor_interface.get_editor_theme().get_font_size("font_size","Label")
			node.change_text_font(header_font_size,label_font_size)
			node.init(data)
#			node.position_offset_changed.emit()
			added_nodes.append(node)

#	LineHandle以外は移動終了イベントを発火させて前面に移動させる
	for node in get_children():
		if node is GraphNode and (node.graph_node_type == "File"\
		or node.graph_node_type == "TextDocument" or node.graph_node_type == "Label"\
		or node.graph_node_type == "Group" or node.graph_node_type == "Link"):
			node.move_to_front()
	_selected_nodes = []
	return added_nodes

func _add_node(scn_node, pos) -> GraphNode:
	var node:GraphNode = scn_node.instantiate()
	var offset = scroll_offset + pos
	offset = offset / zoom # ズームの分位置を変える
	node.position_offset = snap(offset)
	add_child(node)
#	if node is group_node_script:
#		move_child(node, 0)
	set_dirty()
	return node

func _add_common_node(node_type, pos, node_name) -> Node:
	var node = _add_node(node_type, pos)
	if node_name == "TextDocument":
		node.init({"is_md":false})
	else:
		node.init({"node": node_name})
	accept_event()
	node.end_node_move.connect(_on_end_node_move)
	node.show()
	return node

func _get_selected_graphnode() -> Array[GraphNode]:
	var selected_nodes:Array[GraphNode] = []
	for node in get_children():
		if node is GraphNode and node.selected and node.graph_node_type:
			selected_nodes.append(node)
	return selected_nodes

func _get_selected_graphnode_ids() -> Array:
	var selected_nodes:Array[int] = []
	for node in get_children():
		if node is GraphNode and node.selected and node.graph_node_type:
			selected_nodes.append(node.get_data().id)
	return selected_nodes

func _on_pressed_save_button():
	save()

func _on_pressed_group_button():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_group = true

func _on_pressed_text_document_button():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_text_document = true

func _on_pressed_label_document_button():
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_label = true

func _on_color_changed_bg_color_picker_button(color:Color):
	var bg_style_box := StyleBoxFlat.new()
	bg_style_box.bg_color = color
	add_theme_stylebox_override("bg",bg_style_box)

func _on_color_changed_grid_color_picker_button(color:Color):
	add_theme_color_override("grid_major", color)
	add_theme_color_override("grid_minor", Color(color.r, color.g, color.b, color.a * 0.1))

func _on_changed_bg_image(texture:Texture2D):
	var bg_style_box := StyleBoxTexture.new()
	bg_style_box.texture = texture
	bg_style_box.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
	bg_style_box.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE_FIT
	add_theme_stylebox_override("bg",bg_style_box)

func _on_pressed_lock_button():
	var selected_nodes:Array[GraphNode] = _get_selected_graphnode()
	for node in selected_nodes:
		node.lock()

func _on_pressed_unlock_button():
	var selected_nodes:Array[GraphNode] = _get_selected_graphnode()
	for node in selected_nodes:
		node.unlock()

func _on_pressed_connect_button():
	# ２GraphNodeをつなげる

	var real_selected_nodes:Array = _get_selected_graphnode_ids()
	for selected_node in _selected_nodes:
		if !real_selected_nodes.has(selected_node):
			_selected_nodes.erase(selected_node)
	if _selected_nodes.size() != 2:
		printerr(_S.tr("connect_size_err"))
		return

	var from_node = get_node_from_id(_selected_nodes[0])
	var to_node = get_node_from_id(_selected_nodes[1])

	var node = line_handle_node.instantiate()
	self.add_child(node)
	node.init({
		"is_main_handle": true,
		"from_node_id": from_node.get_data().id,
		"to_node_id": to_node.get_data().id,
		})
	## 2点の真ん中に置く
	var pos_1 = from_node.position_offset + from_node.size / 2
	var pos_2 = to_node.position_offset + to_node.size / 2
	node.position_offset = snap((pos_1 + pos_2) / 2)
	set_dirty()
	_selected_nodes = []
	pass

## 整列
func _on_aligned(dir:String):
	var selected_nodes:Array[GraphNode] = _get_selected_graphnode()
	if selected_nodes.is_empty(): return
	match dir: # Tenkey
		"4":
			var left_offset = 9223372036854775800
			for node in selected_nodes:
				if node.position_offset.x < left_offset:
					left_offset = node.position_offset.x
			for node in selected_nodes:
				node.drag_start = node.position_offset
				node.position_offset.x = left_offset
		"6":
			var right_offset = -9223372036854775800
			for node in selected_nodes:
				if node.position_offset.x + node.size.x > right_offset:
					right_offset = node.position_offset.x + node.size.x
			for node in selected_nodes:
				node.drag_start = node.position_offset
				node.position_offset.x = right_offset - node.size.x
			pass
		"8":
			var top_offset = 9223372036854775800
			for node in selected_nodes:
				if node.position_offset.y < top_offset:
					top_offset = node.position_offset.y
			for node in selected_nodes:
				node.drag_start = node.position_offset
				node.position_offset.y = top_offset
		"2":
			var bottom_offset = -9223372036854775800
			for node in selected_nodes:
				if node.position_offset.y + node.size.y > bottom_offset:
					bottom_offset = node.position_offset.y + node.size.y
			for node in selected_nodes:
				node.drag_start = node.position_offset
				node.position_offset.y = bottom_offset - node.size.y

	for child in get_children():
		if child is GraphNode and child.selected:
			_do_move(child, child.position_offset)


## 一定間隔にそろえる　横
func _on_distribute_h_aligned():
	var selected_nodes:Array[GraphNode] = _get_selected_graphnode()
	var left_offset = 9223372036854775800
	var right_offset = -9223372036854775800
	for node in selected_nodes:
		if node.position_offset.x < left_offset:
			left_offset = node.position_offset.x
		if node.position_offset.x > right_offset:
			right_offset = node.position_offset.x

#	左端と右端から個数でわって1個の距離を算出する
	var distance_sum = right_offset - left_offset
	var distance = distance_sum / (selected_nodes.size() - 1)

#	左から順にソートする
	selected_nodes.sort_custom(func(node_a,node_b): return node_a.position_offset.x < node_b.position_offset.x)

	var position_x = left_offset
	var index:int = 0
	for node in selected_nodes:
		if index != selected_nodes.size() - 1:
			node.drag_start = node.position_offset
			node.position_offset.x = left_offset + (index * distance)
		index += 1
	for child in get_children():
		if child is GraphNode and child.selected:
			_do_move(child, child.position_offset)

## 一定間隔にそろえる　縦
func _on_distribute_v_aligned():
	var selected_nodes:Array[GraphNode] = _get_selected_graphnode()
	var top_offset = 9223372036854775800
	var bottom_offset = -9223372036854775800
	for node in selected_nodes:
		if node.position_offset.y < top_offset:
			top_offset = node.position_offset.y
		if node.position_offset.y > bottom_offset:
			bottom_offset = node.position_offset.y

#	左端と右端から個数でわって1個の距離を算出する
	var distance_sum = bottom_offset - top_offset
	var distance = distance_sum / (selected_nodes.size() - 1)

#	上から順にソートする
	selected_nodes.sort_custom(func(node_a,node_b): return node_a.position_offset.y < node_b.position_offset.y)

	var position_y = top_offset
	var index:int = 0
	for node in selected_nodes:
		if index != selected_nodes.size() - 1:
			node.drag_start = node.position_offset
			node.position_offset.y = top_offset + (index * distance)
		index += 1
	for child in get_children():
		if child is GraphNode and child.selected:
			_do_move(child, child.position_offset)

## 音量調節
func _on_changed_volume(volume:float):
	var audio_stream_player:AudioStreamPlayer = _main.audio_stream_player
	_main.audio_stream_player.volume_db = sqrt(volume) * 80 - 80

func _on_pressed_sound_play_button():
	_main.audio_stream_player.play()

func _on_pressed_sound_stop_button():
	_main.audio_stream_player.stop()

func _on_toggled_sound_loop_button(button_press:bool):
	var audio_stream_player:AudioStreamPlayer = _main.audio_stream_player
	if button_press and audio_stream_player.finished.is_connected(self._on_pressed_sound_stop_button):
		audio_stream_player.finished.disconnect(self._on_pressed_sound_stop_button)
		if "loop" in audio_stream_player.stream:
			audio_stream_player.stream.loop = true
	else:
		audio_stream_player.finished.connect(self._on_pressed_sound_stop_button)
		if "loop" in audio_stream_player.stream:
			audio_stream_player.stream.loop = false

#func _on_pressed_comment_button():
#	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
#	add_text_document_large = true


