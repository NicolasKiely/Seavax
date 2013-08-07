/'----------------------------------------------------------------------------
 ' Manages centralized game data
 ---------------------------------------------------------------------------'/

#Include Once "GameContext.bi"
#Include Once "ChatList.bi"


Constructor GameContext()
	this.logMsg("Starting up Game...")

	this.usingSmallChat = -1
	this.tabState = TabStates.serverState
	this.pActive = 0
	this.guic.textPos = 0
	this.exitGame = 0
	this.conState = ConnectionStates.notConnected
	this.cm.aGC = @this
End Constructor


Destructor GameContext()
End Destructor


Sub GameContext.updateMouse()
	/' Get mouse data '/
	GetMouse(this.mc.x, this.mc.y, , this.mc.clicky)
	
	/' Check buttons against mouse '/
	this.updateMouseFromButtonList(@this.buttons)
	
	Select Case As Const this.tabState
		Case TabStates.serverState:
			this.updateMouseFromButtonList(@this.guic.serverScrn.buttons)
	End Select
	
	
End Sub


Sub GameContext.updateMouseFromButtonList(pBtnList As ButtonList Ptr)
	Dim As ButtonNode Ptr pNode = pBtnList->pButton
	
	While pNode <> 0
		/' Skip disabled buttons '/
		If pNode->isEnabled = 0 Then
			pNode = pNode->pNext
			Continue While
		EndIf
		
		pNode->isActive = 0
		If this.mc.x >= pNode->x And this.mc.x <= pNode->x+pNode->wdth Then
			If this.mc.y >= pNode->y And this.mc.y <= pNode->y+pNode->hght Then
				/' Set button as active '/
				pNode->isActive = -1
				
				If this.mc.clicky = 1 Then
					/' Mouse button held '/
					this.mc.isHeld = -1
					
				Else
					/' Mouse button not held '/
					If this.mc.isHeld <> 0 Then
						/' Mouse button has been let go, call click method of button '/
						pNode->callOnClick(@this)
					EndIf
					
					this.mc.isHeld = 0
				EndIf
			EndIf
		EndIf
		
		pNode = pNode->pNext
	Wend
End Sub


Sub GameContext.updateKeyBoard()
	Dim As String char = InKey
	
	If Asc(char) = 13 Then
		/' Enter key '/
		If this.pActive <> 0 Then this.pActive->callOnEnter(@This)
	
	ElseIf Asc(char) = 9 Then
		/' Tab key '/
		This.setActiveBtn(this.guic.chatChk.pChatBtn)
		this.guic.expandChat = Not(this.guic.expandChat)
		
	ElseIf Asc(char) = 27 Then
		/' Escape key'/
		If this.pActive = 0 Then
			/' Nothing in focus, so escape entire game '/
			this.exitGame = -1
			
		Else
			/' Escape current focus '/
			this.setActiveBtn(0)
			this.guic.expandChat = 0
		End If
		
	Else
		/' Send key press to listners '/
		If this.pActive <> 0 Then this.pActive->callOnKeyPress(@This, char)
	End If
End Sub


Sub GameContext.runChatCommand(cmd As String)
	/' TODO: finish '/
End Sub


Sub GameContext.setActiveBtn(pBtn As ButtonNode Ptr)
	this.pActive = pBtn
	
	If pBtn <> 0 Then
		this.guic.textPos = Len(pBtn->text)
	Else
		This.guic.textPos = 0
	EndIf
End Sub


Sub GameContext.setState(newState As Integer)
	/' Clean up old state '/
	If this.tabState = TabStates.serverState Then
		this.guic.serverScrn.hide()
	EndIf
	
	/' Awaken new state '/
	If newState = TabStates.serverState Then
		this.guic.serverScrn.awaken()
	EndIf
	
	this.tabState = newState
End Sub


Sub GameContext.addMsg(author As String, msg As String)
	this.chat.addMsg(author, msg)
End Sub


Sub GameContext.logMsg(msg As String)
	this.chat.addMsg(CLIENT_AUTHOR, msg)
End Sub


Sub GameContext.errMsg(msg As String)
	this.chat.addMsg("#cERROR#", msg)
End Sub


Sub GameContext.sendRaw(msg As String)
	If this.cm.sSock = -1 Then Exit Sub
	
	Dim As ZString Ptr pBuf = StrPtr(msg)
	
	Dim As Integer bSent = send(this.cm.sSock, pBuf, Len(msg), 0)
	
	If bSent = -1 Then
		this.errMsg("SendRaw String failed!")
	ElseIf bSent <> Len(msg) Then
		this.errMsg("Didn't send entire message!")
	EndIf
End Sub


Sub GameContext.attemptLogin()
	Dim As String userName = this.guic.serverScrn.pbUserName->text
	Dim As String password = this.guic.serverScrn.pbPassword->text
	
	If userName <> "" And password <> "" Then
		/' Attempt to log in '/
		this.sendRaw("gui|/acc/log/login -account '"+userName+"' -password '"+password+"';")
	EndIf
End Sub
