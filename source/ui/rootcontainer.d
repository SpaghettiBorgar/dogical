module ui.rootcontainer;

import ui;

class RootContainer : Container
{
	real* _widthp;
	real* _heightp;

	this(real* widthp, real* heightp, Element[] elements...)
	{
		_widthp = widthp;
		_heightp = heightp;
		super(elements);
	}

	override @property real x()
	{
		return 0;
	}

	override @property real y()
	{
		return 0;
	}

	override @property void x(real x)
	{
	}

	override @property void y(real y)
	{
	}

	override @property real width()
	{
		return *_widthp;
	}

	override @property real height()
	{
		return *_heightp;
	}

	override @property void width(real w)
	{
	}

	override @property void height(real h)
	{
	}

	override @property Anchor anchor()
	{
		return ANCHOR_CENTER;
	}

}
