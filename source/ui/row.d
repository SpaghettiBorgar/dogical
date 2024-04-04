module ui.row;

import ui;

class Row : Container
{
	/*
	void update()
	{
		import std.algorithm;
		import std.math;
		import std.array;

		real factorSum = 0;
		real remainingWidth = width;
		real totalHeadroom = 0;
		real maxwidth = 0;
		foreach (e; elements)
		{
			factorSum += isNaN(e.sWidth.factor) ? 0 : e.sWidth.factor;
			remainingWidth -= e.sWidth.minSize;
			totalHeadroom += e.sWidth.maxSize - e.sWidth.minSize;
			maxwidth += e.sWidth.maxSize;
		}
		remainingWidth = min(remainingWidth, maxwidth);
		real accX = 0;
		foreach (e; elements)
		{
			real fraction = e.sWidth.factor / factorSum;
			e.width = clamp(e.sWidth.minSize + remainingWidth * fraction,
				e.sWidth.minSize, e.sWidth.maxSize);
			e.x = accX;
			accX += e.width;
		}
		foreach (i; 0 .. 20)
		{

			remainingWidth = width - accX;
			accX = 0;
			foreach (e; elements)
			{
				real fraction = e.sWidth.factor / factorSum;
				e.width = clamp(e.width + remainingWidth * fraction,
					e.sWidth.minSize, e.sWidth.maxSize);
				e.x = accX;
				accX += e.width;
			}
		}
	}
	*/
}
