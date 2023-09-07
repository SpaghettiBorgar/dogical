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
	Color bgcolor;
	Color bordercolor;
	Label label;

	this(Color bgcolor, string label, Color bordercolor, Size sWidth, Size sHeight, Anchor anchor = ANCHOR_CENTER)
	{
		super(sWidth, sHeight, anchor);
		this.bgcolor = bgcolor;
		this.bordercolor = bordercolor;
		this.label = new Label(label);
		this.label.parent = this;
		this.label.anchor = Anchor(0, 0.5);
	}

	this(Color bgcolor, string label, Size sWidth = Size.init, Size sHeight = Size.init, Anchor anchor = ANCHOR_CENTER)
	{
		this(bgcolor, label, bgcolor, sWidth, sHeight, anchor);
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

	override void draw(Renderer r)
	{
		import std.stdio;

		writefln!"%f %f %f %f"(x, y, width, height);
		r.rect(Rect(this.x, this.y, this.width, this.height), bgcolor, true);
		r.rect(Rect(this.x, this.y, this.width, this.height), bordercolor, false);
		label.draw(r);
	}

}
