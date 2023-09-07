module ui.container;

import ui.element;
import render;

class Container : Element
{
	immutable string _name = "Container";

	Element[] elements;

	this(Element[] elements...)
	{
		this.add(elements);
	}

	void add(Element[] el...)
	{
		foreach (e; el)
		{
			this.elements ~= e;
			e.parent = this;
		}
	}

	override void draw(Renderer r)
	{
		foreach (e; elements)
			e.draw(r);
	}

	override void drawDebug(Renderer r)
	{
		super.drawDebug(r);
		foreach (e; elements)
			e.drawDebug(r);
	}
}
