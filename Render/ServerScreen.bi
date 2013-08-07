/'----------------------------------------------------------------------------
 ' Manages Server screen gui elements
 ---------------------------------------------------------------------------'/

#Include Once "Button.bi"
#Include Once "WindowChunk.bi"
 

Type ServerScreen
	/' Buttons '/
	Dim As ButtonNode Ptr pbUserName
	Dim As ButtonNode Ptr ptUserName
	
	Dim As ButtonNode Ptr pbPassword
	Dim As ButtonNode Ptr ptPassword
	
	Dim As ButtonNode Ptr pbServIP
	Dim As ButtonNode Ptr ptServIP
	
	Dim As ButtonNode Ptr pbPort
	Dim As ButtonNode Ptr ptPort
	
	Dim As ButtonNode Ptr pbConnect
	Dim As ButtonNode Ptr pbConState
	
	Dim As ButtonNode Ptr pbLobby
	
	
	/' Main screen window chunk '/
	Dim As WindowChunk Ptr pMain
	
	/' Sets up buttons for main window chunk '/
	Declare Sub setUpChunk(aGC As Any Ptr, pChunk As WindowChunk Ptr)
	
	/' Remove elements from screen '/
	Declare Sub hide()
	
	/' Bring back elements to screen '/
	Declare Sub awaken()
	
	Declare Constructor()
	Declare Destructor()
End Type


/'----------------------------------------------------------------------------
 ' Auto-move from user name field to password field
 ---------------------------------------------------------------------------'/
Declare Sub onEnterUserName(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Auto-move from password field to Server address field
 ---------------------------------------------------------------------------'/
Declare Sub onEnterPassword(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Auto-move from server address field to server port field
 ---------------------------------------------------------------------------'/
Declare Sub onEnterServerIP(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Attempt to connect to server
 ---------------------------------------------------------------------------'/
Declare Sub onClickConnect(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Render the connection state indicator
 ---------------------------------------------------------------------------'/
Declare Sub drawConnectionState(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Render the connection state indicator
 ---------------------------------------------------------------------------'/
Declare Sub drawLobbyChat(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Attempts to login to an account
 ---------------------------------------------------------------------------'/
Declare Sub onClickConnectionState(aGC As Any Ptr, pBtn As ButtonNode Ptr)