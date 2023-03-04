# godot-idea-board

Design all Godot editor items. Godot4 addon.

[日本語READMEはこちら japanese readme is here](https://github.com/folt-a/godot-idea-board#%E6%97%A5%E6%9C%AC%E8%AA%9E)

There is no need to go back and forth between the design document tool and the Godot editor.

You can create related design for program files within the Godot editor (you can move the canvas and jump!). You can also create Game character correlations document.

You can arrange and manage items such as (scenes, resources, files, directories) in your Godot4 project as you wish.

![image](https://user-images.githubusercontent.com/32963227/200152885-cd65ccfa-8bd3-44d0-94d7-bf41459ef674.png)

---

## Install

download this repostitory.

Copy this addons/godot-idea-board directory to your godot project's addons directory.

**Reload Project.**

![image](https://user-images.githubusercontent.com/32963227/222911944-7b31ce7d-4d67-4284-b4ef-ca3e73ca0e28.png)

"Board" at Topbar

---

## Feature

* [x] Add item by drag-drop from Godot's file system.
* [x] Add Groups, Labels, Text Documents, and Item Connections items with buttons in the header menu.
* [x] Create links to jump to items in the canvas.
* [x] Arrange

### Add item by drag-drop from Godot's file system. Basic use this addon!

Drag items from Godot's file system and add them to the canvas.

Click on the icon of the added item to open its file in the Godot editor.

For scenes, it will be the main scene editor for 2D and 3D, and for script files, it will be the script editor.

### Add Groups, Labels, Text Documents, and Item Connections items with buttons in the header menu.

Items can be well managed adding items from the header menu.

### Create links to jump to items in the canvas

With "link" items that can be copied from right-clicking on a item, you can manage them without getting lost in a large canvas.

### Arrange

Arrange Items. Create Your super Design Document!

---

### Sidebar

![image](https://user-images.githubusercontent.com/32963227/200159612-b24a321b-470f-4173-a171-1b275530efc4.png)

#### Floating window button

![image](https://user-images.githubusercontent.com/32963227/200159963-af58071b-c3b1-4225-b873-4064581f152a.png)

**under development. you can use... **

Displays the current canvas as a floating window.

The right-click menu is in the wrong position or there is a window "always top" error. ......

#### H-split, left canvas selected button, right canvas selected button

![image](https://user-images.githubusercontent.com/32963227/200159975-4d253cf3-c36a-4258-bbdb-b5928597bcea.png)

The canvas can be divided into left and right to display different layouts file.

Select the target to change the layout by clicking the Specify Left Canvas or Specify Right Canvas button.

#### Reload button

![image](https://user-images.githubusercontent.com/32963227/200159984-a7997c84-d3e4-4c8f-9379-afc953626635.png)

Reload. Update the list of layout files.

#### Add button

![image](https://user-images.githubusercontent.com/32963227/200159991-f0873628-c844-4d29-ab1c-6e0d86521f02.png)

Add a new layout file.

Enter a new layout file name in the pop-up dialog and press OK.

#### Duplicate button

![image](https://user-images.githubusercontent.com/32963227/200159997-dcd64d60-9bd2-405f-be72-c730f1d198d0.png)

Add a new layout file by copying the currently selected layout file.

Enter a new layout file name in the pop-up dialog and press OK.

#### Change Filename button

![image](https://user-images.githubusercontent.com/32963227/200160002-ef00d650-1873-446c-bac9-5f760038abf1.png)

Rename the currently selected layout file.

Enter a new layout file name in the pop-up dialog and press OK.

#### Remove button

![image](https://user-images.githubusercontent.com/32963227/200160011-90acdda0-90cc-485e-a415-4425c008cd0e.png)

Deletes the currently selected layout file.

A confirmation pop-up dialog will appear.


#### layout file ItemList

![image](https://user-images.githubusercontent.com/32963227/200160016-d19c79eb-aef0-4e39-8d09-de06f050a95e.png)

A list of layout files is displayed.

Click to open that layout in a canvas.

If any of the currently selected canvases have not been saved, a pop-up dialog will ask "Not saved, is that ok?" The pop-up dialog will ask you if you want to save the layout.

#### Change Layout Dir button and lineedit

![image](https://user-images.githubusercontent.com/32963227/200160027-5227e7f9-6ee3-4701-ab4b-b84b56054ed1.png)

Change the directory where layout files used by this addon are saved and loaded.

Layout files data in json.

---

### Canvas

![image](https://user-images.githubusercontent.com/32963227/200162783-b2de776e-833c-4ddc-8bed-5c58dd23ca51.png)

#### Copy　（Ctrl+C）

It can also be found in the right-click menu.

Copies the currently selected items.

#### Paste　（Ctrl+V）

It can also be found in the right-click menu.

Pastes the selected items to the mouse cursor position.

#### Delete　（Delete）

It can also be found in the right-click menu.

#### Save　（Ctrl+S）

Overwrites all canvas states to the layout file.

---

### Common Item feature

![image](https://user-images.githubusercontent.com/32963227/200162810-02a51ed7-b897-419a-ac31-e0fc5308702a.png)

#### Lock

Right-click context menu "Lock"

Locks the target item. The item will no longer be selectable.

While locked, the 🔒 button will appear and pressing the 🔒 button will unlock it.

You can also lock/unlock the selected items by right-clicking on them.

Related: You can lock all the selected items together in the header menu.

Related: Groups can be used to lock and un-lock a range of items together.

#### Copy Link

Right-click context menu "Copy Link"

Copy the link information of the target item to the clipboard.

Paste on the canvas to create a "link" item.  
(Ctrl+V or from the right-click menu)

![image](https://user-images.githubusercontent.com/32963227/200162857-319d2634-a93a-4094-81c1-6db29d00de91.png)

Clicking on the "→ icon of the target item" of a "link" item, you will jump to the location of that target item on the canvas.

#### Copy Path

Only items created from files have a right-click context menu "Copy Path".

Clicking on it will copy the URL of the item's path starting with `res://` to the clipboard.

#### Only Copy

Right-click context menu "Only Copy"

Only the target item will be copied.

Only the right-clicked item will be copied, even if other items are currently selected.

**If you want to copy multiple items, right-click on the canvas with multiple items selected, and then copy. Or press Ctrl+C**.

Pasting on the canvas will create the copied items.  
(Ctrl+V or from the right-click menu command)

#### Delete

Right-click context menu "Delete"

Deletes only the target item.

Even if there are other selected items, only the item you right-clicked will be deleted.

**If you want to delete multiple items, right-click on an empty canvas with multiple items selected, and then Delete. Or press Del key**.

---

### Header menu Items

![image](https://user-images.githubusercontent.com/32963227/200162879-63610001-a10b-405b-ba4e-8ecb474e8180.png)

If your window is small, the header menu may not be displayed all the way to the right edge. I'll fix it soon, sorry!

![image](https://user-images.githubusercontent.com/32963227/200162885-1bf7aa20-67c0-482e-bc99-b4c1e2952de8.png)

Clicking the button on the header menu and clicking on the canvas creates the item at the click point.

#### Group（Alt+G）

![image](https://user-images.githubusercontent.com/32963227/200162890-24e7e6e1-521b-4446-ae27-122b9c22685e.png)

![image](https://user-images.githubusercontent.com/32963227/200162897-da087196-0b6a-4afd-ac50-22fab4c67cdb.png)

Press the "Group" button to create a "Group" item at the point where the mouse clicks on the canvas.

Press the "cursor icon" button to select all items in the group range.

Press the right-click context menu "Edit" or double-click on the group header to  
Edit the name of the group.

Pressing the right-click context menu "Group Lock" will lock all items within the group range.

Right-click context menu "Group Unlock" to unlock all items within the group's range.

#### Label (Alt+R)

![image](https://user-images.githubusercontent.com/32963227/200162907-cc52f3d0-2600-4027-b4db-a0af12695231.png)

![image](https://user-images.githubusercontent.com/32963227/200162969-29b1bcb1-08fc-4ddc-bddb-40cbc5e02ef3.png)

Press the "Label" button to create a "Label" item at the point where the mouse clicks on the canvas.

A "Label" is an item intended to be used like a one-line label.

Press the right-click context menu "Edit Title" or double-click on the group header.  
You can edit the name of the label by pressing the right-click context menu "Edit Title" or double-clicking on the group header. The label will not be smaller than the length of the label name width. (= all characters are always displayed)

You can change the size of the label by grabbing the bottom right handle of the label.  

**If you change the size.y, the font size will also increase according to the vertical length. **

Right-click context menu Press "Task" and a checkbox will appear on the left.

Check ON/OFF is included in the saved contents. It is just a check box, but you can use it like a task TODO list!

Right click context menu Press "Bg~" to change the color to that color theme.

If you change the color, the next time you add a label, it will be that color from the beginning.

#### TxtDoc (Text Document) (Alt+T)

![image](https://user-images.githubusercontent.com/32963227/200163130-e7604899-7665-4dfc-8873-c979274b3ad1.png)

![image](https://user-images.githubusercontent.com/32963227/200163120-81f84812-1afe-4735-8118-f1ce9272f35d.png)

Press the "TxtDoc" button to create a "TxtDoc" item at the point of mouse click on the canvas.

The "TxtDoc" item is intended for document production where multiple lines of text are to be entered.

Markdowns style text can be entered.

Press the "Markdown and Edit Switch Icon" button in the upper left corner to switch modes between markdown view and text editing.

Right-click context menu Press "Edit Title" or double-click on the group header to

You can edit the name of the text title. The width of this item will not be smaller than the length of the width of the title name. (= all characters are always displayed)

Grab the bottom right handle to change the size.  

Right-click context menu Press "Make it a task" and a check box will appear on the left.

Check ON/OFF is included in the saved contents. It is just a check box.

Right-click context menu Press "Background~" to change the color to that color.

After changing the color, the next time you add text, it will be the same color as the first time you add text.

(Not implemented: I want to add a function to save the file as a file) TODO

Related: "Create text from this file" for text files

#### Connect button（Alt+C）

![image](https://user-images.githubusercontent.com/32963227/200163153-00879523-9a7e-4fbf-89b7-a022e698d931.png)

![image](https://user-images.githubusercontent.com/32963227/200163229-2b8334c2-21ff-4ff7-9a54-755636708061.png)

![image](https://user-images.githubusercontent.com/32963227/222912294-0419dd5b-d04e-4d4a-a32a-6162b4658b81.png)


Two items can be connected to each other to create a connect item.

This can be used to connect program files and design them as a class diagram, or to create a character correlation chart or story flow document.

When two items are selected, press Alt+C or the "Connect" button to create a connect item between them.

If the number of items selected is not 2, nothing will happen; only 2 items should be selected.

You can connect all items except the "connect" item.

Double-click on a "connect" item to edit the text displayed (**only one line**). (**only one line**) All characters are always displayed.

Right-click context menu "Color~" to change the color to that color.

Once you change the color, the next time you add a "Connect" item, it will be the same color from the beginning.

### other Header menu button

![image](https://user-images.githubusercontent.com/32963227/200163241-5504506a-9656-48a5-8c5d-be46991c0745.png)

![image](https://user-images.githubusercontent.com/32963227/200163246-db56136f-d95e-45c3-8fa3-69e7cf5275d1.png)

#### Godot's built-in GraphEdit's button.

You can zoom, snap distance and minimap on/off.

Snap distance is also referenced in this add-on, but I'm using 24 and haven't checked with other snap granularities in particular.

(Thanks to GraphEdit, this add-on is based on GraphEdit, and is marked as ⚠ in Godotbeta4, but please do not make destructive changes: ......)

#### Save button（Alt＋S）

Save layout file.

The difference with Ctrl+S is that even if there are multiple canvases, this one will save only this canvas.

#### Lock button (Alt+L)

![image](https://user-images.githubusercontent.com/32963227/200163251-98a53350-8f28-4375-b6a2-2fbde784b05b.png)

Locks all selected items.

Since you cannot select locked items, there is no "Unlock all together" command!

If you want to unlock all the locked items, please use the command since there is "Group Lock/Unlock" in the group.

#### Background color button

![image](https://user-images.githubusercontent.com/32963227/200163259-7035c1ff-256f-4792-9a35-063a0dd082fe.png)

change background color.

#### Grid color button

![image](https://user-images.githubusercontent.com/32963227/200160130-59e1f79a-2269-4282-b302-c00094250520.png)

change grid color.

andchange sub grid color.

#### Sound settings buttons

![image](https://user-images.githubusercontent.com/32963227/200163270-e27d5e1a-0696-441f-bd85-f1c8d9817a6e.png)

You can set the music playing.

No pause! Will add if requested.

#### Arrange buttons

![image](https://user-images.githubusercontent.com/32963227/200160141-52f38196-1f0f-4faa-b8ee-6296c72d3b63.png)

Aligns the currently selected items.

However, "connect" items are ignored.

There are two buttons, one for aligning up, bottom, left, right, and one for aligning at regular intervals.

---

## Items

* [x] Scene (.tscn)
* [x] Image (.png... resource loaded as Texture2D)
* [x] Sound
* [x] Other resource(.tres)
* [x] Text file
* [x] Directory
* [ ] Dialogic2.0 Timeline (Under Development)
* [ ] Dialogic2.0 Character (Under Development)

### Scene (.tscn)

![image](https://user-images.githubusercontent.com/32963227/200163302-ba3601e1-b574-4b82-808b-79459d44c134.png)

Click the icon in the upper left corner of the first line to open that scene.

Whether the scene is 2D or 3D is determined by the Node type of the scene.

Right-click on the context menu "Show Play Scene Button" and the Show Scene Play Button will appear on the left.

Pressing the Play Scene button will play the scene in the Godot editor. This is useful!

### Resource(.tres)

Click to open the inspector.

### Image

![image](https://user-images.githubusercontent.com/32963227/200160176-394f4c5c-e451-467a-8dbe-92b7f9ba3463.png)

Click to open the inspector.

(I'd like a command to open the location of that file on the file system...) TODO

### Sound

![image](https://user-images.githubusercontent.com/32963227/200158761-b9184a8d-86e5-4997-92bf-b40deab43c84.png)

with play button. header settings.

Click to open the inspector.

(I'd like a command to open the location of that file on the file system...) TODO

### Text Document

![image](https://user-images.githubusercontent.com/32963227/200163317-57d00484-3ab3-4b33-b5f3-9643a9d81ebc.png)

Right-click context menu "Make TxtDoc" to create a "TxtDoc" item from this text file.

![image](https://user-images.githubusercontent.com/32963227/200163330-9f69a311-54a7-483b-9dd2-6cd8fd1ca757.png)

The "TxtDoc" item you have now created will have an additional button to open the location of that file and a button to save it.

### Directory

![image](https://user-images.githubusercontent.com/32963227/200160191-b593addd-881c-4650-bc2e-c802593ae44c.png)

Click to open the location of that directory in Godot's file system.

(I'd like the ability to add files in this directory as items.) TODO

---

This add-on is based on and inspired the Godot3 add-on [Project-Map](https://github.com/Yogoda/Project-Map).

the Markdown parse script is [DocsMarkdownParser.gd](https://github.com/coppolaemilio/dialogic/blob/dialogic-1/addons/dialogic/Documentation/Nodes/DocsMarkdownParser.gd) from [Dialogic](https://github.com/coppolaemilio/dialogic).

Thank you!

---

## Future Plans

* [ ] (Not implemented: I want to add a function to save the file as a file) TODO
* [ ] (I'd like a command to open the location of that file on the file system...) TODO
* [ ] (I'd like the ability to add files in this directory as items.) TODO


---

## 日本語
 
もう設計書ツールとGodotエディタとの間で往復をする必要はありません。
 
Godotエディタ内でプログラムファイルの関連設計図を作成したり（すぐジャンプできる！）、キャラクター相関図を作ることもできます。

Godot4 プロジェクト内の（シーン、リソース、ファイル、ディレクトリ）といったアイテムを好きなように配置して管理することができます。

![image](https://user-images.githubusercontent.com/32963227/200152885-cd65ccfa-8bd3-44d0-94d7-bf41459ef674.png)

---

## インストール

このリポジトリをダウンロードするかクローンします。

このアドオンのディレクトリから、addons/godot-idea-boardをGodotのプロジェクト直下のaddonsディレクトリに入れます。

**※プロジェクトをリロードして、Godotエディタを再起動します。**

![image](https://user-images.githubusercontent.com/32963227/200170578-2419e79f-31a3-4e2e-98bd-9a71591e08cc.png)

「Design」 が上部バーにでてます。

---

## 日本語設定

Markdownテキストは、RichTextLabelになっているのでひらがななどが欠けます。

![image](https://user-images.githubusercontent.com/32963227/200868518-59731061-7890-4d93-b8e8-110cc90919a3.png)

`res://addons/godot-idea-board/main_theme.tres` にて、default_fontを設定するとこのアドオンはすべてこのフォントになります。

このテーマファイルにて対象のコントロールだけフォント変更する手もあります。

または、エディタ設定にて、日本語フォントに変更してください。エディタ全部変わりますが……

---

## メインの機能

* [x] Godotファイルシステムからのドラッグドロップによる各アイテム追加
* [x] グループ・ラベル・テキスト・接続のアイテム追加（ヘッダーメニュー）
* [x] キャンバス内のアイテムへジャンプできるリンク作成
* [x] 整列

### Godotファイルシステムからのドラッグドロップによるアイテム追加　基本！

Godotのファイルシステムのところからアイテムをドラッグしてキャンバスに追加します。

追加したアイテムのアイコンをクリックするとGodotエディタでそのファイルが開きます。

シーンなら2D・3Dに対応したメイン画面、スクリプトファイルならスクリプト画面になる、などです。

### グループ・ラベル・テキスト・接続のアイテム追加（ヘッダーメニュー）

ヘッダーメニューから管理系のアイテムを追加してアイテムをうまくまとめることができます。

### キャンバス内のアイテムへジャンプできるリンク作成

各アイテム上で右クリックからコピーできる「リンク」アイテムを使えば、広いキャンバスで迷うことなく管理することができます。

### 整列

きれいにアイテムを並び替えて「ぼくのかんがえたさいきょうのせっけいしょ」を作ろう！几帳面！

---

### サイドバー

![image](https://user-images.githubusercontent.com/32963227/200159612-b24a321b-470f-4173-a171-1b275530efc4.png)

#### ウィンドウボタン

![image](https://user-images.githubusercontent.com/32963227/200159963-af58071b-c3b1-4225-b873-4064581f152a.png)

**開発中のため不安定**

現在のキャンバスを別ウィンドウとして表示します。

右クリックメニューの位置がおかしかったりウィンドウのalways top のエラーが出たりします……

#### Hスプリット、左キャンバス指定、右キャンバス指定

![image](https://user-images.githubusercontent.com/32963227/200159975-4d253cf3-c36a-4258-bbdb-b5928597bcea.png)

キャンバスを左右に分けて別のレイアウトを表示できます。

左キャンバス指定、右キャンバス指定ボタンでレイアウトを変更する対象を選択します。

#### リロードボタン

![image](https://user-images.githubusercontent.com/32963227/200159984-a7997c84-d3e4-4c8f-9379-afc953626635.png)

レイアウトファイル一覧を更新します。

#### 追加ボタン

![image](https://user-images.githubusercontent.com/32963227/200159991-f0873628-c844-4d29-ab1c-6e0d86521f02.png)

新しくレイアウトファイルを追加します。

ポップアップダイアログで新しいレイアウトファイル名を入力してOKをおします。

#### 複製ボタン

![image](https://user-images.githubusercontent.com/32963227/200159997-dcd64d60-9bd2-405f-be72-c730f1d198d0.png)

現在選択中のレイアウトファイルをコピーして新しくレイアウトファイルを追加します。

ポップアップダイアログで新しいレイアウトファイル名を入力してOKをおします。

#### 名前変更ボタン

![image](https://user-images.githubusercontent.com/32963227/200160002-ef00d650-1873-446c-bac9-5f760038abf1.png)

現在選択中のレイアウトファイルの名前を変更します。

ポップアップダイアログで新しいレイアウトファイル名を入力してOKをおします。

#### 削除ボタン

![image](https://user-images.githubusercontent.com/32963227/200160011-90acdda0-90cc-485e-a415-4425c008cd0e.png)

現在選択中のレイアウトファイルを削除します。

確認ポップアップダイアログがでます。


#### レイアウトアイテムリスト

![image](https://user-images.githubusercontent.com/32963227/200160016-d19c79eb-aef0-4e39-8d09-de06f050a95e.png)

レイアウトファイルの一覧が表示されています。

クリックするとキャンバスでそのレイアウトを開きます。

現在選択中のキャンバスで保存されていないものがあればポップアップダイアログで「保存されないけどいいですか？」の確認されます。

#### レイアウトディレクトリ変更

![image](https://user-images.githubusercontent.com/32963227/200160027-5227e7f9-6ee3-4701-ab4b-b84b56054ed1.png)

このアドオンで使用するレイアウトファイルを保存、読み込みをするディレクトリを変更します。

レイアウトファイルはjsonでデータを保持しています。

---

### キャンバス

![image](https://user-images.githubusercontent.com/32963227/200160041-66bca82f-a34c-4eaa-914b-08a5ddd28f88.png)

#### コピー　（Ctrl+C）

右クリックメニューにもあります。

選択中のアイテムをコピーします。

#### ペースト　（Ctrl+V）

右クリックメニューにもあります。

選択中のアイテムをマウスカーソルの位置へ貼り付けます。

#### 削除　（Delete）

右クリックメニューにもあります。

#### 保存　（Ctrl+S）
すべてのキャンバスの状態をレイアウトファイルに上書き保存します。

---

### アイテム共通

![image](https://user-images.githubusercontent.com/32963227/200157255-e1e2a77a-c45b-4a47-a13c-8523bd43bb1e.png)

#### ロック

右クリックコンテキストメニュー「ロック」

対象のアイテムをロックします。選択できなくなります。

ロック中は🔒ボタンが表示され、🔒ボタンを押すとロック解除されます。

右クリックからロック/ロック解除できます。

関連：ヘッダーメニューで選択中まとめてロックできます。

関連：グループでまとめて範囲ロック、範囲ロック解除があります

#### リンクコピー

右クリックコンテキストメニュー「リンクコピー」

対象のアイテムのリンク情報をクリップボードにコピーします。

キャンバス上でペーストすると「リンク」アイテムが作成されます。  
（Ctrl+V　または　右クリックメニューから）

![image](https://user-images.githubusercontent.com/32963227/200157447-cd40dd69-1159-4dd7-89a0-f061b19d7122.png)

「リンク」アイテムの「→対象アイテムのアイコン」をクリックすると、キャンバス上でその対象のアイテムの位置に飛びます。

#### パスのコピー

ファイルから作ったアイテムにのみ右クリックコンテキストメニュー「パスのコピー」があります。

クリックすると `res://`から始まるそのアイテムのパスのURLをクリップボードにコピーします。

#### これだけコピー

右クリックコンテキストメニュー「これだけコピー」

対象のアイテムのみをコピーします。

他に選択中のアイテムがあっても、右クリックしたアイテムのみコピーされます。

**複数コピーしたい場合は、複数選択した状態でなにもないキャンバス上で右クリック→コピーをしてください。またはCtrl+C**

キャンバス上でペーストするとコピーしたアイテムが作成されます。  
（Ctrl+V　または　右クリックメニューから）

json形式でコピーするのでこのアドオン以外では使えなさそうです。

#### 削除

右クリックコンテキストメニュー「削除」

対象のアイテムのみを削除します。

他に選択中のアイテムがあっても、右クリックしたアイテムのみ削除されます。

**複数コピーしたい場合は、複数選択した状態で、なにもないキャンバス上で右クリック→削除をしてください。またはDeleteキー**

---


### 管理系のアイテム　ヘッダーメニュー

![image](https://user-images.githubusercontent.com/32963227/200157941-bc760c01-8ade-46a1-af34-9323fb94cb99.png)

ウィンドウが小さいと、ヘッダーメニューの右はしっこまで表示されないことがあります。そのうち直します、ごめんなさい！

「集中モード」で広するなどでなんとか……

![image](https://user-images.githubusercontent.com/32963227/200158048-a7615fd9-da12-4d45-a7d7-0f956d229fd9.png)

ヘッダーメニューのボタンを押して、キャンバスをクリックするとクリック地点に管理系のアイテムが作成されます。

#### グループ（Alt+G）

![image](https://user-images.githubusercontent.com/32963227/200160083-0c4b4503-2d19-4436-91bc-220de360b66d.png)

![image](https://user-images.githubusercontent.com/32963227/200156375-831ccb9e-5ed4-4367-acde-f8f997d97eff.png)

「グループ」ボタンを押し、キャンバス上でマウスクリックしたところに「グループ」アイテムを作成します。

カーソルのアイコンボタンを押すと、グループ範囲内のすべてのアイテムを選択します。

右クリックコンテキストメニュー　「編集」を押す、またはグループヘッダーをダブルクリックすると、  
グループの名前を編集することができます。

右クリックコンテキストメニュー　「グループ範囲ロック」を押すと、グループの範囲内のアイテムをすべてロックします。

右クリックコンテキストメニュー　「グループ範囲ロック解除」を押すと、グループの範囲内のアイテムをすべてロック解除します。

#### ラベル (Alt+R)

![image](https://user-images.githubusercontent.com/32963227/200160092-a28069e6-6e0e-4d1f-8795-3d5071b111f1.png)

![image](https://user-images.githubusercontent.com/32963227/200156653-7d2ae945-9897-490b-af04-d05623c10a5a.png)

「ラベル」ボタンを押し、キャンバス上でマウスクリックしたところに「ラベル」アイテムを作成します。

「ラベル」は１行のふせんのように使う目的のアイテムです。

右クリックコンテキストメニュー　「タイトル編集」を押す、またはグループヘッダーをダブルクリックすると、  
ラベルの名前を編集することができます。ラベルの名前の幅の長さよりラベルは小さくなりません。（＝常に全文字表示される）

ラベルの右下のハンドルをつかむと、ラベルのサイズを変更することができます。  

**縦のサイズを変更すると、フォントサイズも縦の長さに応じて大きくなります。**

右クリックコンテキストメニュー　「タスクにする」を押すと、チェックボックスが左に表示されます。

チェックのON/OFFは保存内容に含まれます。ただのチェックボックスですが、タスクTODOリストのように使うことができます。

右クリックコンテキストメニュー　「背景～」を押すと、色がその色に変わります。

色変更をすると、次からラベルを追加するときは最初からその色になります。

#### テキスト (Alt+T)

![image](https://user-images.githubusercontent.com/32963227/200160106-03116d9f-a6f6-48da-8009-43eb03e50051.png)

![image](https://user-images.githubusercontent.com/32963227/200159512-63069850-e0cc-4629-9e06-17f1f2ba30d6.png)

「テキスト」ボタンを押し、キャンバス上でマウスクリックしたところに「テキスト」アイテムを作成します。

「テキスト」は複数行のテキストを入力するドキュメント制作を目的としたアイテムです。

マークダウンを入力することができます。

![image](https://user-images.githubusercontent.com/32963227/200159125-558830d4-e8bc-4390-902b-18e59cbbf15a.png)

左上の「マークダウン↔編集切り替えアイコン」ボタンを押すと、マークダウン表示とテキスト編集でモードが切り替わります。

右クリックコンテキストメニュー　「タイトル編集」を押す、またはグループヘッダーをダブルクリックすると、  
テキストのタイトルの名前を編集することができます。タイトルの名前の幅の長さよりこのアイテムの幅は小さくなりません。（＝常に全文字表示される）

右下のハンドルをつかむと、サイズを変更することができます。  

右クリックコンテキストメニュー　「タスクにする」を押すと、チェックボックスが左に表示されます。

チェックのON/OFFは保存内容に含まれます。ただのチェックボックスです。

右クリックコンテキストメニュー　「背景～」を押すと、色がその色に変わります。

色変更をすると、次からテキストを追加するときは最初からその色になります。

（未実装：ファイルにして保存する機能を追加したい）TODO

関連：テキストファイルの「このファイルからテキストをつくる」

#### 接続（Alt+C）

![image](https://user-images.githubusercontent.com/32963227/200160113-49b3e265-8d2f-4a90-82b2-f7690b889b6d.png)

![image](https://user-images.githubusercontent.com/32963227/200157010-9ce3c4ee-c88c-4051-8b7c-5de163e53444.png)

![image](https://user-images.githubusercontent.com/32963227/222912294-0419dd5b-d04e-4d4a-a32a-6162b4658b81.png)

2つのアイテム同士をつないでコネクトアイテムを作ることができます。

プログラムファイルをつないでクラス図のようにして設計したり、キャラクター相関図やストーリーフローのドキュメントを作ったりするのに使えます。

2つのアイテムを選択した状態でAlt＋Cまたは「接続」ボタンを押すとコネクトアイテムが間にできます。

アイテムを選択している数が2以外の場合はなにもおこりません。2つのみ選択してください。

「コネクト」アイテム以外のすべてのアイテムをつなぐことができます。

「コネクト」アイテムをダブルクリックすると、表示文字を編集することができます。（**1行のみ**）常に全文字表示されます。

右クリックコンテキストメニュー　「色～」を押すと、色がその色に変わります。

色変更をすると、次から「コネクト」アイテムを追加するときは最初からその色になります。

### その他のヘッダーメニュー

![image](https://user-images.githubusercontent.com/32963227/200158084-224fd330-70c4-447c-95e1-0f851df11733.png)

![image](https://user-images.githubusercontent.com/32963227/200158089-ed5f71aa-a49c-4382-bd2a-5b392838216c.png)

#### Godotの組み込みGraphEditにもとからついているやつ

ズームやスナップ粒度やミニマップON/OFFができます。

スナップ粒度はこのアドオンでも値を参照していますが、私は24で使っていて特にほかのスナップ粒度で確認していません。

（このアドオンはベースがGraphEditなのでGraphEditに感謝です。Godotbeta4で⚠マークついていますがなにとぞ破壊的変更はひかえめにおねがいします……）

#### 保存（Alt＋S）

保存します。

Ctrl+Sとの違いは複数キャンバスがあってもこちらはこのキャンバスのみを保存します。

#### ロック (Alt+L)

![image](https://user-images.githubusercontent.com/32963227/200160119-d78556e8-f9dd-4eaa-81b7-6fab925f2981.png)

選択中のものをまとめてロックします。

ロック状態のものは選択できないので、「まとめてロック解除」はありません！

グループで「グループ範囲をまとめてロック/ロック解除」があるためまとめてロック解除がしたいときはこちらを使ってください。

#### 背景色

![image](https://user-images.githubusercontent.com/32963227/200160123-ae08b905-f04b-4d1b-bd11-6829aa58364e.png)

キャンバスの背景色を変更します。

#### グリッドの色

![image](https://user-images.githubusercontent.com/32963227/200160130-59e1f79a-2269-4282-b302-c00094250520.png)

メイングリッドの色を変更します。

サブグリッドの色はメイングリッドの色にaを0.1乗算したものが設定されます。

#### 音量・音楽再生・音楽停止・ループ

![image](https://user-images.githubusercontent.com/32963227/200160141-52f38196-1f0f-4faa-b8ee-6296c72d3b63.png)

![image](https://user-images.githubusercontent.com/32963227/200160136-20379cd8-b76b-42da-a162-c9d42b7e6a47.png)

再生中の音楽の設定ができます。

一時停止はありません！要望があれば追加します。

#### 整列ボタンたち

選択中のアイテムを整列します。

ただし、「コネクタ」アイテムは無視されます。

上下左右にそろえるボタンと一定間隔でそろえるボタンがあります。

---

## 各アイテムについて

* [x] シーン (.tscn)
* [x] 画像 (.pngなど、Texture2Dとして読み込んだリソース)
* [x] 音楽
* [x] リソース(.tres)
* [x] テキストファイル
* [x] ディレクトリ
* [ ] Dialogic2.0 タイムライン 未実装
* [ ] Dialogic2.0 キャラクター 未実装

### シーン (.tscn)

![image](https://user-images.githubusercontent.com/32963227/200158590-e9a2a0da-ac9c-4cb0-9c3d-4827271382d5.png)

1行目の左上のアイコンをクリックするとそのシーンが開きます。

2Dか3DかはそのシーンのNode種類で判断されます。

右クリックコンテキストメニュー　「シーン再生ボタンを表示」を押すと、シーン再生ボタンを表示が左に表示されます。

シーン再生ボタンを押すと、Godotエディタでそのシーンをゲーム再生します。これは便利

### リソース(.tres)

クリックするとインスペクタが開きます。

### 画像リソース

![image](https://user-images.githubusercontent.com/32963227/200160176-394f4c5c-e451-467a-8dbe-92b7f9ba3463.png)

画像リソースはその画像を表示します。

アイコンをクリックするとインスペクタでそのファイルを開きます。

（ファイルシステム上でそのファイルの場所を開くコマンドが欲しいな・・・）TODO

### 音楽リソース

![image](https://user-images.githubusercontent.com/32963227/200158761-b9184a8d-86e5-4997-92bf-b40deab43c84.png)

音楽リソースは再生ボタンがついています。

アイコンをクリックするとインスペクタでそのファイルを開きます。

（ファイルシステム上でそのファイルの場所を開くコマンドが欲しいな・・・）TODO

再生ボタンを押すとその音楽が再生されます。ヘッダーで調整できます。

### テキストファイル

![image](https://user-images.githubusercontent.com/32963227/200158817-53b5d827-6e30-49bc-bd00-e6718431c870.png)

右クリックコンテキストメニュー　「このファイルからテキストをつくる」を押すと、このテキストファイルから「テキスト」アイテムを作成します。

![image](https://user-images.githubusercontent.com/32963227/200158856-d466177c-72ee-45d9-b40b-e0814c000ce3.png)

これで作成した「テキスト」アイテムには、そのファイルの場所を開くボタンと、保存するボタンが追加されます。

### ディレクトリ

![image](https://user-images.githubusercontent.com/32963227/200160191-b593addd-881c-4650-bc2e-c802593ae44c.png)

クリックするとGodotのファイルシステムでそのディレクトリの位置を開きます。

（このディレクトリ内のファイルをアイテムとして追加する機能がほしいなあ）TODO

---

このアドオンはGodot3のアドオン [Project-Map](https://github.com/Yogoda/Project-Map) をベースにして作成しています。

また、Markdownパースのスクリプトは[Dialogic](https://github.com/coppolaemilio/dialogic)の[DocsMarkdownParser.gd](https://github.com/coppolaemilio/dialogic/blob/dialogic-1/addons/dialogic/Documentation/Nodes/DocsMarkdownParser.gd)を使用しています。

ありがとうございます！

---
