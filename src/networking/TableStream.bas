#Include Once "TableStream.bi"


Function streamTable(ppWork As Table Ptr Ptr, ppRes As Table Ptr Ptr, _
							zMark As ZString Ptr, pState As Integer Ptr) As ZString Ptr
	
	If ppWork = 0 Or ppRes = 0 Or zMark = 0 Then
		/' Check for null pointers '/
		Return zMark
	EndIf
	
	/' Check if theres work to do '/
	If zMark[0] = 0 Then Return zMark
	
	/' Step down working buffer '/
	Dim As Table Ptr pWork
	If *ppWork = 0 Then *ppWork = New Table()
	pWork = *ppWork
	
	
	/' Set up working variables '/
	If pWork->pHeader = 0 Then
		pWork->pHeader = New Fld()
		pWork->lHeader = pWork->pHeader
		pWork->headerNum = 1
	EndIf
	Dim As Fld Ptr pHeader = pWork->lHeader
	
	If pWork->pCol = 0 Then
		pWork->pCol = New Fld()
		pWork->lCol = pWork->pCol
		pWork->headerNum = 1
	EndIf
	Dim As Fld Ptr pCol = pWork->lCol
	
	If pWork->pRec = 0 Then
		pWork->pRec = New Record()
		pWork->lRec = pWork->pRec
		pWork->recNum = 1
	EndIf
	Dim As Record Ptr pRec = pWork->lRec
	
	/' Bump down a record if starting at the end of an existing one '/
	If *pState = TableStreamStates.RECORD_STATE And pRec->fldNum = pWork->colNum Then
		pRec->pNext = New Record()
		pRec = pRec->pNext
		pWork->lRec = pRec
		pWork->recNum += 1
	EndIf
	
	If pRec->pFld = 0 Then
		pRec->pFld = New Fld()
		pRec->lFld = pRec->pFld
		pRec->fldNum = 1
	EndIf
	Dim As Fld Ptr pFld = pRec->lFld
	
	
	/' Loop through characters '/
	Dim As ZString Ptr zNew = zMark
	While zNew[0] <> 0
		Select Case *pState
			Case TableStreamStates.HEADER_STATE:
				/' Working on header '/
				If zNew[0] = ASC_FIELD_DELIMITER Then
					/' Move to next field '/
					pHeader->pNext = New Fld()
					pHeader = pHeader->pNext
					pWork->lHeader = pHeader
					pWork->headerNum += 1
					
				ElseIf zNew[0] = ASC_TABLE_DELIMITER Then
					/' Move to next state '/
					*pState = TableStreamStates.COLUMN_STATE
					
				Else
					/' Add to current field '/
					pHeader->value += Left(*zNew,1)
				EndIf
				
			Case TableStreamStates.COLUMN_STATE:
				/' Working on columns '/
				If zNew[0] = ASC_FIELD_DELIMITER Then
					/' Move to next column '/
					pCol->pNext = New Fld()
					pCol = pCol->pNext
					pWork->lCol = pCol
					pWork->colNum += 1
					
				ElseIf zNew[0] = ASC_TABLE_DELIMITER Then
					/' Move to next state '/
					*pState = TableStreamStates.RECORD_STATE
					
				Else
					/' Add to current field '/
					pCol->value += Left(*zNew, 1)
				EndIf
				
			Case TableStreamStates.RECORD_STATE:
				/' Working on records '/
				If zNew[0] = ASC_FIELD_DELIMITER Then
					/' Move to next field '/
					If pRec->fldNum < pWork->colNum Then
						/' Add to current record '/
						pFld->pNext = New Fld()
						pFld = pFld->pNext
						pRec->lFld = pFld
						pRec->fldNum += 1
						
					Else
						/' Add to new record '/
						pRec->pNext = New Record()
						pRec = pRec->pNext
						pWork->lRec = pRec
						pWork->recNum += 1
						
						pRec->pFld = New Fld()
						pRec->lFld = pRec->pFld
						pRec->fldNum = 1
						pFld = pRec->pFld
					EndIf
					
				ElseIf zNew[0] = ASC_TABLE_DELIMITER Then
					/' Done reading table '/
					*pState = TableStreamStates.HEADER_STATE
					*ppRes = pWork
					*ppWork = New Table()
					
					Return zNew + 1
					
				Else
					/' Add to current field '/
					pFld->value += Left(*zNew, 1)
				EndIf
		End Select
		
		/' Go to next character '/
		zNew += 1
	Wend
	
	
	Return zNew
End Function
