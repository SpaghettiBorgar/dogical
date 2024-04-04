module ui.dot;

import ui.element;
import render;
import color;
import geometry;

class Dot : Element
{
	immutable string _name = "Element";

	Color color;

	this()
	{
		super();
		this._width = 0;
		this._height = 0;
		this.color = Color(200, 200, 200, 255);
	}

	override void _draw(Renderer r)
	{
		r.rect(Rect(realX - 2, realY - 2, 4, 4), this.color, true);
	}
}
