#Include Once "GUIContext.bi"
#Include Once "MouseContext.bi"
#Include Once "../ChatList.bi"
#Include Once "../gui/Button.bi"
#Include Once "../gui/ServerScreen.bi"
#Include Once "../networking/ConMan.bi"

#Define CLIENT_AUTHOR "#CLIENT#"


/'----------------------------------------------------------------------------
 ' Manages top-level game data
 ' Note: For simplicity's sake, all methods should pass the game context
 ' instance as an any pointer, then cast. To get around dependency issues
 ' and keep things consistent.
 ---------------------------------------------------------------------------'/
Type GameContext
	/' Connected to server? '/
	Dim As Integer conState
	
	/' Manages gui '/
	Dim As GUIContext guic
	
	/' Chat list manager '/
	Dim As ChatList chat
	
	/' Server Connection manager '/
	Dim As ConMan cm
	
	/' Mouse tracker '/
	Dim As MouseContext mc
	
	/' Pointer to active text field in focus '/
	Dim As ButtonNode Ptr pActive
	
	/' State of which tab being used '/
	Dim As Integer tabState
	
	/' Flag to determine if using small chat or big chat window '/
	Dim As Integer usingSmallChat
	
	/' List of buttons in the program '/
	Dim As ButtonList buttons
	
	/' Flag to exit game '/
	Dim As Integer exitGame
	
	Declare Constructor()
	Declare Destructor()
	
	/' Update mouse-related data '/
	Declare Sub updateMouse()
	
	/' Helper method for updateMouse() '/
	Declare Sub updateMouseFromButtonList(pBtnList As ButtonList Ptr)
	
	/' Interpret keyboard input '/
	Declare Sub updateKeyBoard()
	
	/' Runs a chat command '/
	Declare Sub runChatCommand(cmd As String)
	
	/' Sets the active button '/
	Declare Sub setActiveBtn(pBtn As ButtonNode Ptr)
	
	/' Menu state switch '/
	Declare Sub setState(newState As Integer)
	
	/' Chat Messaging '/
	Declare Sub addMsg(author As String, msg As String)
	
	/' Client message '/
	Declare Sub logMsg(msg As String)
	
	/' Client Error '/
	Declare Sub errMsg(msg As String)
	
	/' Sends raw string to server, if connected '/
	Declare Sub sendRaw(msg As String)
	
	/' Attempts to log in to an account '/
	Declare Sub attemptLogin()
End Type


Enum TabStates
	serverState = 0,
	gameState,
	chatState,
	teamState,
	optionsState
End Enum


Enum ConnectionStates
	notConnected = 0,
	connecting,
	connected,
	failedToConnect,
	connectionLost,
	kicked,
	banned
End Enum
