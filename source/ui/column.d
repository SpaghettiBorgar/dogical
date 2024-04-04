module ui.column;

import ui;
import render;

class Column : Container
{
	immutable string _name = "Column";

	this(Element[] elements...)
	{
		super(elements);
	}

	override void _draw(Renderer r)
	{
		real availHeight = this.height;

		foreach (e; elements)
		{
			availHeight -= e.height;
		}
		real gap = availHeight / elements.length;

		real y_acc = gap / 2;
		foreach (e; elements)
		{
			e.relPos = Anchor(0, -1);
			e._attachmentAnchor = Anchor(0, -1);
			e.y = y_acc;
			e.draw(r);
			y_acc += e.height + gap;
		}
	}
}
