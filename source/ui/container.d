module ui.container;

import ui.element;
import std.math.traits : isNaN;
import color;
import render;
import geometry;

class Container : Element
{
	immutable string _name = "Container";

	Element[] elements;
	Color bgcolor;

	bool clipOverflow = true;
	Point offset = Point(0, 0);
	real zoom = 0;
	real scale = 1;

	this(Element[] elements...)
	{
		this.add(elements);
		offset = Point(0, 0);
	}

	void add(Element[] el...)
	{
		foreach (e; el)
		{
			this.elements ~= e;
			e.parent = this;
		}
	}

	// override @property real virtX()
	// {
	// 	return realX - offset.x;
	// }

	// override @property real virtY()
	// {
	// 	return realY - offset.y;
	// }

	override void _draw(Renderer r)
	{
		r.rect(boundingRect, bgcolor, true);
		if (clipOverflow)
			r.pushClip(boundingRect);

		r.pushTransform(offset, scale);

		foreach (e; elements)
			e.draw(r);

		r.popTransform();

		if (clipOverflow)
			r.popClip();
	}
}
