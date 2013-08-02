/'----------------------------------------------------------------------------
 ' GUI buttons
 ---------------------------------------------------------------------------'/

/' Node in a linked list of buttons '/
Type ButtonNode
	/' Coordinates of top left '/
	Dim As Integer x
	Dim As Integer y
	
	/' Dimension of the button '/
	Dim As Integer wdth
	Dim As Integer hght
	
	/' Active color '/
	Dim As UInteger actColor
	
	/' Text associated with button '/
	Dim As String text
	
	/' Inactive color '/
	Dim As UInteger inaColor
	
	/' Whether or not button is rendered and checking for clicks '/
	Dim As UInteger isEnabled
	
	/' Whether or not button is under mouse '/
	Dim As UInteger isActive
	
	/' Callback functions, passes game context and button node '/
	Dim pOnClick As Sub(aGC As Any Ptr, pBtn As ButtonNode ptr)
	Dim pOnDraw As Sub(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	Dim pOnKeyPress As Sub(aGC As Any Ptr, pBtn As ButtonNode Ptr, char As String)
	Dim pOnEnter As Sub(aGC As Any Ptr, pBtn As ButtonNode Ptr)
	
	
	/' Wrapper for callback functions, handles null pointer cases '/
	/' Mouse click '/
	Declare Sub callOnClick(aGC As Any Ptr)
	/' Called every frame to render button to screen '/
	Declare Sub callOnDraw(aGC As Any Ptr)
	/' For text fields. Called when active and key is pressed '/
	Declare Sub callOnKeyPress(aGC As Any Ptr, char As String)
	/' Called when hot key pressed or enter button hit when active'/
	Declare Sub callOnEnter(aGC As Any Ptr)
	
	
	/' Next node '/
	Dim As ButtonNode Ptr pNext
	
	Declare Constructor()
	Declare Destructor()
End Type


/' List of buttons '/
Type ButtonList
	Dim As ButtonNode Ptr pButton
	
	/' Adds a button to the beginning of the list '/
	Declare Sub addButton(pNewButton As ButtonNode Ptr)
	
	/' Renders background of active buttons in list '/
	Declare Sub renderButtons(aGC As Any Ptr)
	
	Declare Constructor()
	Declare Destructor()
End Type



/'----------------------------------------------------------------------------
 ' Generate default label button
 ---------------------------------------------------------------------------'/
Declare Function newLabelButton(btnText As String) As ButtonNode Ptr


/'----------------------------------------------------------------------------
 ' Generate default text field button
 ---------------------------------------------------------------------------'/
Declare Function newTextButton(colWdth As Integer) As ButtonNode Ptr


/'----------------------------------------------------------------------------
 ' Generates default button
 ---------------------------------------------------------------------------'/
Declare Function newGenericButton(btnText As String) As ButtonNode Ptr


/'----------------------------------------------------------------------------
 ' Default button renderer, just draws background
 ---------------------------------------------------------------------------'/
Declare Sub defaultDrawButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Renders a button with text on it
 ---------------------------------------------------------------------------'/
Declare Sub drawTextButton(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Renders a text field
 ---------------------------------------------------------------------------'/
Declare Sub drawTextField(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Handles text box getting activated
 ---------------------------------------------------------------------------'/
Declare Sub onClickTextBox(aGC As Any Ptr, pBtn As ButtonNode Ptr)


/'----------------------------------------------------------------------------
 ' Handles keyboard input for a text box
 ---------------------------------------------------------------------------'/
Declare Sub onTextBoxType(aGC As Any Ptr, pBtn As ButtonNode Ptr, char As String)


/'----------------------------------------------------------------------------
 ' Handles user exiting by button
 ---------------------------------------------------------------------------'/
Declare Sub onClickExit(aGC As Any Ptr, pBtn As ButtonNode Ptr)