#Include Once "ConMan.bi"
#Include Once "win/winsock.bi"
#Include Once "GameContext.bi"
#Include Once "table.bi"


Constructor ConMan()
	If WSAStartup(MAKEWORD(2,2), @(this.wdat)) <> 0 Then
		/' Handle error '/
		gcErrMsg("WSAstartup failure")
	EndIf
	
	this.sSock = -1
End Constructor


Destructor ConMan()
	this.closeSelf()
	
	WSACleanup()
End Destructor


Sub ConMan.startConnection(ip As String, port As String)
	Dim As HostEnt Ptr URLHost
	Dim As SockAddr_In URLSocket
	Dim As Long con
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	/' Open the socket '/
	this.sSock = OpenSocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
	
	If this.iSock = INVALID_SOCKET Then
		gcErrMsg("Invalid Socket bug!")
		Exit Sub
	EndIf
	
	/' Get host name '/
	gcLogMsg("Attempting host lookup...")
	URLHost = GetHostByName(ip)
	If URLHost = 0 Then
		gcErrMsg("Failed host lookup")
		Exit Sub
	Else
		gcLogMsg("Host found, attempting connection...")
	EndIf
	
	/' Set up URL socket '/
	URLSocket.Sin_Family = AF_Inet
	URLSocket.Sin_Port = htons(ValInt(port))
	URLSocket.Sin_Addr.S_addr = *(*(URLHost->H_Addr_List))
	
	/' Connect to URL '/
	Dim As Integer URLSockLen = Len(URLSocket)
	con = Connect(sSock, @URLSocket, URLSockLen)
	If con = -1 Then
		gcErrMsg("Could not connect!")
		pGC->conState = ConnectionStates.failedToConnect
		
	Else
		gcLogMsg("Connection value: " + Str(con))
		
		/' Change login button to log-out button '/
		pGC->guic.serverScrn.pbConnect->text = "Disconnect"
	EndIf
	
	Dim As Long wsae = WSAGetLastError
	If wsae <> 0 Then
		gcErrMsg("WSAerror = " + Str(wsae-WSABASEERR))
	EndIf
	
	
	gcLogMsg("Socket value: " + Str(*CPtr(Integer Ptr, @(this.sSock))))
End Sub


Sub ConMan.gcErrMsg(msg As String)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, this.aGC)
	
	pGC->errMsg(msg)
End Sub


Sub ConMan.gcLogMsg(msg As String)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, this.aGC)
	
	pGC->logMsg(msg)
End Sub


Sub ConMan.listenToServer()
	If this.sSock <> -1 Then
		Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
		Dim As fd_set readSet
		
		/' Initialize fd set '/
		FD_ZERO(@readSet)
		FD_SET_(this.sSock, @readSet)
		
		/' Dont wait '/
		Dim As timeVal tv
		tv.tv_sec = 0
		tv.tv_usec = 0
		
		selectSocket(this.sSock+1, @readSet, 0, 0, @tv)
		
		If fd_isSet(this.sSock, @readSet) Then
			Dim As ZString Ptr pBuf = Callocate(250)
			
			Dim As Integer datLen = recv(this.sSock, pBuf, 249, 0)
			pBuf[249] = 0
			
			If datLen = 0 Then 
				this.gcLogMsg("Socket closed!")
				this.closeSelf()
				pGC->conState = ConnectionStates.notConnected
				
			ElseIf datLen = -1 Then
				this.gcErrMsg("Socket read error!")
				this.closeSelf()
				pGC->conState = ConnectionStates.connectionLost
				
			Else
				
				/' DEBUG '/
				For i As Integer = 0 To 249
					If pBuf[i] = 9 Then pBuf[i] = 124
					If pBuf[i] = 10 Then pBuf[i] = 58
					If pBuf[i] = 13 Then pBuf[i] = 59
				Next
				
				this.gcLogMsg("#Server#: " + *pbuf)
				
			EndIf
			
			DeAllocate(pBuf)
		EndIf
	EndIf
End Sub


Sub ConMan.closeSelf()
	If this.sSock <> -1 Then
		closeSocket(this.sSock)
	EndIf
	
	this.sSock = -1
End Sub
