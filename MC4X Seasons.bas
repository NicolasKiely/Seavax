#Include Once "win/winsock.bi"

#Include Once "src/gui/WindowChunk.bi"
#Include Once "src/gui/ChatChunk.bi"
#Include Once "src/gui/ServerScreen.bi"
#Include Once "src/contexts/GameContext.bi"


/' Rendering:
 '  Render Menu Bar
 '  Render Context
 '  Render Chat bar
 '/
 
/' Chat Notes:
 '		@<target> <msg> sends to target
 '			@g							global
 '			@s							server bot
 '			@t-<team name>			specific team
 '			@							Local team
 '			@p-<player name>		specific player
 '		/								Server command
 '		None							Default (local chat?)
 '/

/' Immediate todo: parsing table packets with tables, server lobby '/

/' TODO: Menu organization
 '  [.] Server connection: Server login/server communication
 '    - [.] Button
 '		- [.] Lobby chat
 '		- [X] Connect to server
 '  [ ] Game map
 '		- [.] Button
 '		- [ ] Map grid
 '    - [ ] Find/join game 
 '  [ ] Chat History
 '		- [.] Button
 '		- [ ] Chat list
 '		- [ ] Sort options
 '		- [ ] Chat room
 '  [ ] Options
 '		- [.] Button
 '		- [ ] Exit
 '		- [ ] About
 '		- [ ] Help
 '  [ ] Team map
 '		- [.] Button
 '		- [ ] What organizations the player belongs to
 '		- [ ] What players are in the organizations
 '/
 
ScreenRes SCRN_WDTH, SCRN_HGHT, 32

/' Window Chunks '/
Dim As WindowChunk menu  = WindowChunk(SCRN_WDTH, MENU_CHUNK_HEIGHT , 0)
Dim As WindowChunk main  = WindowChunk(SCRN_WDTH, MAIN_CHUNK_HEIGHT , MENU_CHUNK_HEIGHT)
Dim As WindowChunk sChat = WindowChunk(SCRN_WDTH, SCHAT_CHUNK_HEIGHT, SCRN_HGHT - SCHAT_CHUNK_HEIGHT)
Dim As WindowChunk bChat = WindowChunk(SCRN_WDTH, BCHAT_CHUNK_HEIGHT, SCRN_HGHT - BCHAT_CHUNK_HEIGHT)
Dim As GameContext gc = GameContext()

/' Initialize GUI '/
initializeButtons(@gc, @menu, @main, @sChat, @bChat)
gc.guic.serverScrn.setUpChunk(@gc, @main)
gc.guic.chatChk.setUpChunk(@gc, @sChat, @bChat)

gc.setState(TabStates.serverState)

Dim As Table fooTable
fooTable.addToHeader("Head 1")
fooTable.addToHeader("Head 2")
fooTable.addToColumn("Col 1")
fooTable.addToColumn("Col 2")
fooTable.addRecord(loadRecordFromString(!"Fld 1\tFld 2"))
fooTable.addRecord(loadRecordFromString(!"Fld 3\tFld 4"))

gc.logMsg(fooTable.toString())

Do Until 0
	Sleep 10
	ScreenLock
	Cls
	
	/' Render to screen chunk buffers '/
	renderChunks(@menu, @main, @sChat, @bChat, @gc)
	
	/' Render chunks to screen '/
	menu.renderToScreen()
	main.renderToScreen()
	gc.guic.serverScrn.buttons.renderButtons(@gc)
	If gc.guic.expandChat = 0 Then
		sChat.renderToScreen()
	Else
		bChat.renderToScreen()
	End if
	
	/' Update input/output '/
	gc.updateMouse()
	gc.updateKeyBoard()
	gc.buttons.renderButtons(@gc)
	gc.cm.listenToServer()
	
	If gc.exitGame <> 0 Then Exit Do
	
	ScreenUnLock
Loop

ScreenUnLock

gc.cm.closeSelf()

End(1)