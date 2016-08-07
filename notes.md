# Schmedit App

## Schematic Data

* PinType
  * part: PartType
  * function
  * number
  * flavor: {Simple,Inverted}
  * direction: {In,Out,InOut}

* PartSection
  * pins[]: PinType

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
  * from:Pin
  * to:Pin
  * signal:Signal

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
