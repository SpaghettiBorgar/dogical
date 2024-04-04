module ui.rootcontainer;

import ui;
import render;

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

	override @property real realX()
	{
		return 0;
	}

	override @property real realY()
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

	override void drawDebug(Renderer r)
	{
		import color;

		import std.format;

		if (width > 80)
		{
			// r.text(format!"(%.1f %.1f)"(x, y), pos,
			// 	FONT_DEBUG, WHITE, TextAlignment.TOPLEFT);
			r.text(format!"[%.1fx%.1f]"(width, height), realPos + size,
				FONT_DEBUG, WHITE, TextAlignment.BOTTOMRIGHT);
		}
		foreach (e; elements)
			e.drawDebug(r);

	}
}
