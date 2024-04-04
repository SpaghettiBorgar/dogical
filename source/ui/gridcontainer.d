module ui.gridcontainer;

import ui.element;
import ui.container;
import std.algorithm.iteration : fold;
import render;
import std.math.traits;

public class GridContainer : Container
{
	uint rows;
	uint columns;

	this(uint rows, uint columns, Element[] elements...)
	{
		this.rows = rows;
		this.columns = columns;
		this.elements = elements;
		spaceElements();
	}

	override void add(Element[] el...)
	{
		this.elements ~= el;
		foreach (e; el)
		{
			e.parent = this;
		}
		spaceElements();
	}

	override @property real height()
	{
		if (!isNaN(_height))
			return _height;
		real ret;
		foreach (e; elements)
			ret += e.height;
		return ret;
	}

	override @property real width()
	{
		if (!isNaN(_width))
			return _width;
		real ret;
		foreach (e; elements)
			ret += e.width;
		return ret;
	}

	override @property void width(real w)
	{
		super.width(w);
	}

	override @property void height(real h)
	{
		super.height(h);
	}

	private void spaceElements()
	{
		import std.math.rounding : floor;

		foreach (i, e; elements)
		{
			e.relPos = Anchor(
				((2 * (i % rows) + 1) / rows) - 1, (
					(2 * floor(cast(real) i / columns) + 1) / columns) - 1
			);
			// e.x = real.nan;
			// e.y = real.nan;
			e.width = this.width / columns;
			e.height = this.height / rows;
		}
	}
}
