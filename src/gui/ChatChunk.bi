/'----------------------------------------------------------------------------
 ' For management of chat screen chunk gui
 ---------------------------------------------------------------------------'/
 
#Include Once "WindowChunk.bi"
#Include Once "Button.bi"
 
Type ChatChunk
	/' Window chunks '/
	Dim As WindowChunk Ptr pSChat
	Dim As WindowChunk Ptr pBChat
	
	Dim As String lastChatEntered
	
	/' Buttons '/
	Dim As ButtonNode Ptr pChatBtn
	Dim As ButtonNode Ptr pEnterBtn
	Dim As ButtonNode Ptr pExpandBtn
	
	Declare Sub setUpChunk(aGC As Any Ptr, pSChunk As WindowChunk Ptr, _
									pBChunk As WindowChunk ptr)
End Type


/'----------------------------------------------------------------------------
 ' Renders expand button
 ---------------------------------------------------------------------------'/
Declare Sub drawExpandButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Handles expand button click
 ---------------------------------------------------------------------------'/
Declare Sub onClickExpandButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Renders enter button
 ---------------------------------------------------------------------------'/
Declare Sub drawEnterButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Handles user entering a command from chat
 ---------------------------------------------------------------------------'/
Declare Sub onEnterChat(aGC As Any Ptr, pBtn As ButtonNode Ptr)