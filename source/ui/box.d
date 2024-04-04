module ui.box;

import ui.element;
import ui.label;
import color;
import render;
import geometry;
import std.algorithm.comparison : max;
import std.math.traits;

class Box : Element
{
	immutable string _name = "Box";

	Color bgcolor;
	Color bordercolor;
	Label label;

	this(Anchor pos = ANCHOR_CENTER, Color bgcolor, string label, real width = real.nan, real height = real.nan,
		Anchor attach = ANCHOR_CENTER, Color bordercolor = TRANSPARENT)
	{
		super(pos, attach);
		this.bgcolor = bgcolor;
		this.label = new Label(label);
		this.label.parent = this;
		this.label.relPos = Anchor(0, 0.5);
		real defaultSize = max(this.label.width, this.label.height, 100);
		this.width = isNaN(width) ? defaultSize : width;
		this.height = isNaN(height) ? defaultSize : height;
	}

	this(Point pos, Color bgcolor, string label, real width = real.nan, real height = real.nan,
		Anchor attach = ANCHOR_CENTER, Color bordercolor = TRANSPARENT)
	{
		this(ANCHOR_NAN, bgcolor, label, width, height, attach, bordercolor);
		this.pos = pos;
	}

	override @property real width()
	{
		// return isNaN(_width) ? max(label.width, label.height) : _width;
		return _width;
	}

	override @property void width(real w)
	{
		_width = w;
		// label.width = w;
	}

	override @property real height()
	{
		return isNaN(_height) ? max(label.width, label.height) : _height;
	}

	override @property void height(real h)
	{
		_height = h;
		// label.height = h;
	}

	override void _draw(Renderer r)
	{
		import std.stdio;

		// writefln!"%f %f %f %f"(realX, realY, width, height);
		r.rect(Rect(realX, realY, this.width, this.height), bgcolor, true);
		r.rect(Rect(realX, realY, this.width, this.height), bordercolor, false);
		label.draw(r);
	}

}
