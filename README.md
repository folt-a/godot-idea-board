# godot-project-design-links

Design all Godot editor items. Godot4 addon.

[日本語READMEはこちら japanese readme is here](https://github.com/folt-a/godot-project-design-links#%E3%83%A1%E3%82%A4%E3%83%B3%E3%81%AE%E6%A9%9F%E8%83%BD)

There is no need to go back and forth between the design document tool and the Godot editor.

You can create related design for program files within the Godot editor (you can move the canvas and jump!). You can also create Game character correlations document.

You can arrange and manage items such as (scenes, resources, files, directories) in your Godot4 project as you wish.

![image](https://user-images.githubusercontent.com/32963227/200152885-cd65ccfa-8bd3-44d0-94d7-bf41459ef674.png)

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

![image](https://user-images.githubusercontent.com/32963227/200160041-66bca82f-a34c-4eaa-914b-08a5ddd28f88.png)

#### Copy　（Ctrl+C）

It can also be found in the right-click menu.

Copies the currently selected items.

#### Paste　（Ctrl+V）

It can also be found in the right-click menu.

Pastes the selected items to the mouse cursor position.

#### Delete　（Delete）

It can also be found in the right-click menu.

#### Undo / Redo　（Ctrl+Z / Shift+Ctrl+Z）

Saving the file will delete the history.

This is a simplified version, so do not be too overconfident.

#### Save　（Ctrl+S）

Overwrites all canvas states to the layout file.

History will be lost and undo/redo will not be possible.

---

### Common Item feature

![image](https://user-images.githubusercontent.com/32963227/200157255-e1e2a77a-c45b-4a47-a13c-8523bd43bb1e.png)

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

![image](https://user-images.githubusercontent.com/32963227/200157447-cd40dd69-1159-4dd7-89a0-f061b19d7122.png)

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

![image](https://user-images.githubusercontent.com/32963227/200157941-bc760c01-8ade-46a1-af34-9323fb94cb99.png)

If your window is small, the header menu may not be displayed all the way to the right edge. I'll fix it soon, sorry!

![image](https://user-images.githubusercontent.com/32963227/200158048-a7615fd9-da12-4d45-a7d7-0f956d229fd9.png)

Clicking the button on the header menu and clicking on the canvas creates the item at the click point.

#### Group（Alt+G）

![image](https://user-images.githubusercontent.com/32963227/200160083-0c4b4503-2d19-4436-91bc-220de360b66d.png)

![image](https://user-images.githubusercontent.com/32963227/200156375-831ccb9e-5ed4-4367-acde-f8f997d97eff.png)

Press the "Group" button to create a "Group" item at the point where the mouse clicks on the canvas.

Press the "cursor icon" button to select all items in the group range.

Press the right-click context menu "Edit" or double-click on the group header to  
Edit the name of the group.

Pressing the right-click context menu "Group Lock" will lock all items within the group range.

Right-click context menu "Group Unlock" to unlock all items within the group's range.

#### Label

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

#### テキスト

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

#### ロック

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

## 今後追加したいもの

* [ ] テキスト（未実装：ファイルにして保存する機能を追加したい）TODO
* [ ] リソース（ファイルシステム上でそのファイルの場所を開くコマンドが欲しいな・・・）TODO
* [ ] ディレクトリ（このディレクトリ内のファイルをアイテムとして追加する機能がほしいなあ）TODO


---

## 日本語
 
もう設計書ツールとGodotエディタとの間で往復をする必要はありません。
 
Godotエディタ内でプログラムファイルの関連設計図を作成したり（すぐジャンプできる！）、キャラクター相関図を作ることもできます。

Godot4 プロジェクト内の（シーン、リソース、ファイル、ディレクトリ）といったアイテムを好きなように配置して管理することができます。

![image](https://user-images.githubusercontent.com/32963227/200152885-cd65ccfa-8bd3-44d0-94d7-bf41459ef674.png)

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

#### 元に戻す、進む　（Ctrl+Z,Shift+Ctrl+Z）

アンドゥリドゥ機能です。

保存をすると履歴は削除されます。

簡易的なものなので、あまり過信しないでください。

#### 保存　（Ctrl+S）
すべてのキャンバスの状態をレイアウトファイルに上書き保存します。

履歴は消えるためアンドゥリドゥはできなくなります。

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

#### ラベル

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

#### テキスト

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

#### ロック

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

## 今後追加したいもの

* [ ] テキスト（未実装：ファイルにして保存する機能を追加したい）TODO
* [ ] リソース（ファイルシステム上でそのファイルの場所を開くコマンドが欲しいな・・・）TODO
* [ ] ディレクトリ（このディレクトリ内のファイルをアイテムとして追加する機能がほしいなあ）TODO
