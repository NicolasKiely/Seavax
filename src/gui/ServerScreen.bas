#Include Once "ServerScreen.bi"
#Include Once "Button.bi"
#Include Once "../contexts/GameContext.bi"


Constructor ServerScreen()
End Constructor


Destructor ServerScreen()
End Destructor


Sub ServerScreen.setUpChunk(aGC As Any Ptr, pChunk As WindowChunk Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	pMain = pChunk
	
	/' User name label and button '/
	ptUserName = newLabelButton("User Name:")
	ptUserName->x = pMain->wdth*0.02
	ptUserName->y = pMain->yOffset + pMain->hght*0.03
	this.buttons.addButton(ptUserName)
	
	'pbUserName = New ButtonNode()
	pbUserName = newTextButton(20)
	pbUserName->x = pMain->wdth*0.18
	pbUserName->y = pMain->yOffset + pMain->hght*0.03
	pbUserName->pOnEnter = @onEnterUserName()
	this.buttons.addButton(pbUserName)
	
	/' Password label and button '/
	ptPassword = newLabelButton("Password:")
	ptPassword->x = pMain->wdth * 0.50
	ptPassWord->y = pMain->yOffset + pMain->hght*0.03
	this.buttons.addButton(ptPassword)
	
	pbPassword = newTextButton(20)
	pbPassword->x = pMain->wdth*0.66
	pbPassword->y = pMain->yOffset + pMain->hght*0.03
	pbPassword->pOnEnter = @onEnterPassword()
	this.buttons.addButton(pbPassword)
	
	/' Server IP label and button '/
	ptServIP = newLabelButton("Server IP:")
	ptServIP->x = pMain->wdth * 0.02
	ptServIP->y = pMain->yOffset + pMain->hght*0.10
	this.buttons.addButton(ptServIP)
	
	pbServIP = newTextButton(20)
	pbServIP->x = pMain->wdth * 0.18
	pbServIP->y = pMain->yOffset + pMain->hght*0.10
	pbServIP->text = "127.0.0.1"
	pbServIP->pOnEnter = @onEnterServerIP()
	this.buttons.addButton(pbServIP)
	
	/' Server port label and button '/
	ptPort = newLabelButton("Port #:")
	ptPort->x = pMain->wdth * 0.50
	ptPort->y = pMain->yOffSet + pMain->hght*0.10
	this.buttons.addButton(ptPort)
	
	pbPort = newTextButton(20)
	pbPort->x = pMain->wdth * 0.66
	pbPort->y = pMain->yOffset + pMain->hght*0.10
	pbPort->text = "6282"
	pbPort->pOnEnter = @onClickConnect()
	this.buttons.addButton(pbPort)
	
	/' Connection buttons '/
	pbConnect = newGenericButton("Connect")
	pbConnect->x = pMain->wdth * 0.02
	pbConnect->y = pMain->yOffset + pMain->hght*0.17
	pbConnect->wdth = pMain->wdth * 0.40
	pbConnect->hght = 20
	pbConnect->pOnClick = @onClickConnect()
	this.buttons.addButton(pbConnect)
	
	/' Connection state button '/
	pbConState = New ButtonNode()
	pbConState->x = pMain->wdth * 0.50
	pbConState->y = pMain->yOffset + pMain->hght*0.17
	pbConState->wdth = pMain->wdth * 0.40
	pbConState->hght = 20
	pbConState->text = "No Connection"
	pbConState->pOnDraw = @drawConnectionState()
	pbConState->pOnClick = @onClickConnectionState()
	this.buttons.addButton(pbConState)
	
	/' Lobby chatroom button '/
	pbLobby = NewMultiButton((pMain->wdth/8) - 9, (pMain->hght/10)-20)
	pbLobby->x = pMain->wdth * 0.02
	pbLobby->y = pMain->yOffset + pMain->hght*0.25
	pbLobby->pOnDraw = @drawLobbyChat()
	this.buttons.addButton(pbLobby)
	
	
End Sub


Sub onEnterUserName(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pGC->setActiveBtn(pGC->guic.serverScrn.pbPassWord)
End Sub


Sub onEnterPassword(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pGC->setActiveBtn(pGC->guic.serverScrn.pbServIP)
End Sub


Sub onEnterServerIP(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pGC->setActiveBtn(pGC->guic.serverScrn.pbPort)
End Sub


Sub onClickConnect(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	Dim As String servIP = pGC->guic.serverScrn.pbServIP->text
	Dim As String port = pGC->guic.serverScrn.pbPort->text
	
	/' Attempt connection '/
	If pBtn->text = "Connect" Then
		pGC->conState = ConnectionStates.connecting
		pGC->cm.startConnection(servIP, port)
		
	ElseIf pBtn->text = "Disconnect" Then
		pGC->cm.closeSelf()
		pBtn->text = "Connect"
		pGC->conState = ConnectionStates.notConnected
	EndIf
	
	
	pGC->attemptLogin()
End Sub


Sub ServerScreen.hide()
	this.pbUserName->isEnabled = 0
	this.ptUserName->isEnabled = 0
	this.pbPassword->isEnabled = 0
	this.ptPassword->isEnabled = 0
	this.pbServIP->isEnabled = 0
	this.ptServIP->isEnabled = 0
	this.pbPort->isEnabled = 0
	this.ptPort->isEnabled = 0
	this.pbConnect->isEnabled = 0
	this.pbConState->isEnabled = 0
	this.pbLobby->isEnabled = 0
End Sub


Sub ServerScreen.awaken()
	this.pbUserName->isEnabled = -1
	this.ptUserName->isEnabled = -1
	this.pbPassword->isEnabled = -1
	this.ptPassword->isEnabled = -1
	this.pbServIP->isEnabled = -1
	this.ptServIP->isEnabled = -1
	this.pbPort->isEnabled = -1
	this.ptPort->isEnabled = -1
	this.pbConnect->isEnabled = -1
	this.pbConState->isEnabled = -1
	this.pbLobby->isEnabled = -1
End Sub


Sub drawConnectionState(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	Select Case As Const pGC->conState
		Case ConnectionStates.notConnected
				Color RGB( 25,  20,  75)
				pBtn->text = "No Connection"
				
		Case ConnectionStates.connecting
				Color RGB(  0, 100,   0)
				pBtn->text = ""
				
		Case ConnectionStates.connected
				Color RGB(  0,  30, 100)
				pBtn->text = "Connected"
				
		Case ConnectionStates.failedToConnect
				Color RGB( 50,   0,  50)
				pBtn->text = "Failed to Connect"
				
		Case ConnectionStates.connectionLost
				Color RGB( 65,   0,  35)
				pBtn->text = "Connection Lost"
				
		Case ConnectionStates.kicked
				Color RGB( 80,  10,  20)
				pBtn->text = "Kicked"
				
		Case ConnectionStates.banned
				Color RGB(100,   10,  0)
				pBtn->text = "Banned"
	End Select
	
	
	If pBtn->text <> "" Then
		/' Just render as normal button '/
		
		Line (pBtn->x, pBtn->y) - (pBtn->x+pBtn->wdth, pBtn->y+pBtn->hght),, BF
		Dim As Integer tx
		Dim As Integer ty
		
		ty = pBtn->y + (pBtn->hght Shr 1)-4
		tx = pBtn->x + (pBtn->wdth Shr 1)-(4*Len(pBtn->text))
		
		Color RGB(240, 240, 190)
		Draw String (tx, ty), pBtn->text
	
	Else
		/' Render connecting bar'/
		pBtn->text = "Log on"
		
		Dim As Double t = Timer / 2
		Dim As Double s
		t = t - Int(t)
		s = 1 - t
		
		For x As Integer = pBtn->x To pBtn->x + pBtn->wdth
			For y As Integer = pBtn->y To pBtn->y + pBtn->hght
				Dim a As Single = (x - pBtn->x)/(pBtn->wdth)
				Dim b As Single = (y - pBtn->y)/(pBtn->hght)
				Dim p As Single = Abs(t-a)
				Dim q As Single = (p+0.5)-Int(p+0.5)
				
				Dim c As Single = p*b + q*(1-b)
				c = Abs(c - 0.5)*2
				c = Sqr(c*2*Abs(t-0.5))
				
				Color RGB(80*c+20, 20, 80*(1-c)+20)
				PSet (x, y)
				If (c > 0.7) Then
					Color RGB(35*c, 5, 35*(1-c))
					If y = pBtn->y Then
						PSet(x, y-1)
					ElseIf y = pBtn->y+pBtn->hght Then
						PSet(x, y+1)
					EndIf
					If x = pBtn->x Then
						PSet(x-1, y)
					ElseIf x = pBtn->x+pBtn->wdth Then
						PSet(x+1, y)
					EndIf
				EndIf
				If (c > 0.85) Then
					Color RGB(15*c, 4, 15*(1-c))
					If y = pBtn->y Then
						PSet(x, y-2)
					ElseIf y = pBtn->y+pBtn->hght Then
						PSet(x, y+2)
					EndIf
					If x = pBtn->x Then
						PSet(x-2, y)
					ElseIf x = pBtn->x+pBtn->wdth Then
						PSet(x+2, y)
					EndIf
				EndIf
			Next y
		Next x
		
		Dim As Integer tx
		Dim As Integer ty
		
		ty = pBtn->y + (pBtn->hght Shr 1)-4
		tx = pBtn->x + (pBtn->wdth Shr 1)-(4*Len(pBtn->text))
		
		Color RGB(240, 240, 190)
		Draw String (tx, ty), pBtn->Text
	EndIf
End Sub


Sub drawLobbyChat(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	Dim As Integer bx1 = pBtn->x+8
	Dim As Integer by1 = pBtn->y+8
	Dim As Integer bx2 = pBtn->x + pBtn->wdth - 8
	Dim As Integer by2 = pBtn->y + pBtn->hght - 8
	
	/' Render border '/
	Color pBtn->inaColor
	Line (pBtn->x, pBtn->y) - (pBtn->x + pBtn->wdth, by1-1),,BF  ' Top
	Line (bx2+1, by1) - (pBtn->x + pBtn->wdth, pBtn->y + pBtn->hght),,BF ' Right
	Line (pBtn->x, by1) - (bx1-1, pBtn->y + pBtn->hght),,BF ' Left
	Line (bx1, by2+1) - (bx2, pBtn->y + pBtn->hght),,BF ' Bottom
	
	/' Render background '/
	Color pBtn->actColor
	Line (bx1, by1) - (bx2, by2),,BF
End Sub


Sub onClickConnectionState(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim As GameContext Ptr pGC = CPtr(GameContext Ptr, aGC)
	
	pGC->attemptLogin()
End Sub
