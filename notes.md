# Schmedit App

## Schema

* Every object has a uuid that includes its type

* PinType
  * part: PartType
  * function
  * number
  * flavor: {Simple,Inverted}
  * direction: {In,Out,InOut}

* PartSection
  * pins[]: PinType
  * symbol: PartSymbol

* PartSymbol
  * svg: text -- Part's geometry with pinType property for pins

* PartType
  * name
  * description
  * sections[]: PartSection
  
* Part
  * type:PartType
  * ref
  * location: Point
  * pins[]: Pin

* Pin
  * type: PinType
  * part: Part
  * location: Point

* Signal
  * wires[]: Wire

* Wire
  * from: Pin
  * to: Pin
  * signal: Signal

* Page
  * pdfPage
  * title
  * pageCode
  * revision
  * parts[]: Part
  * wires[]: Wire
  * noteBlocks[]: text

* Schematic
  * title
  * moduleName
  * revision
  * pages[]: Page

## Interactions

### Needed Operations

* Insert new item
  * Double click in background presents list of insertables
* Select item(s)
  * Shift or control modifier to select or deselect multiple items
* Selectable
  * Part
  * Part pin
  * Wire
  * Wire bend point (simply a kind of part?)
  * Title block
	* Item within title block
	  * Page number allows
		* Moving from page to page
		* Inserting pages
		* Deleting current page
  * Note block
* With selected
  * Delete - delete key and menu item
  * Copy - cmd/control-C
  * Modify
	* Move - drag part
	* Resize - drag size handle
	* Rotate - drag rotation handle
	* Change part section
	* Change part type
	* Change part refdes
* Paste previously copied
* Hover
  * Display can be transient or pinned and repositioned and closed
  * Displays info
	* Over part pin
	* Over part section
	* Over wire
	  * Shows signal name, all connected pins
	* Over title block
	  * Page number
	* Over note block
	* Over wire bend
* Key and/or menu item to close all pinned hover blocks
