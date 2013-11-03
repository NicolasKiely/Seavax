/'----------------------------------------------------------------------------
 ' Manages connection to the server
 ---------------------------------------------------------------------------'/

#Include Once "win/winsock.bi"

#Include Once "table.bi"

Type ConMan
	/' Windows network thingy '/
	Dim As WSAData wdat
	
	/' Parent game context '/
	aGC As Any Ptr
	
	/' Socket for server '/
	Union
		Dim As SOCKET sSock
		Dim As UInteger iSock
	End Union
	
	/' Buffers for parsing table '/
	Dim As Table Ptr pWorking
	Dim As Table Ptr pRes
	Dim As ZString Ptr zMark
	Dim As Integer tableState
	
	/' Attempt connection '/
	Declare Sub startConnection(ip As String, port As String)
	
	/' GameContext logging '/
	Declare Sub gcErrMsg(msg As String)
	Declare Sub gcLogMsg(msg As String)
	Declare Sub gcLogTab(pTable As Table Ptr)
	
	/' Listen to connection '/
	Declare Sub listenToServer()
	
	/' Close socket '/
	Declare Sub closeSelf()
	
	Declare Constructor()
	Declare Destructor()
End Type
