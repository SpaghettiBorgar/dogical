module ui.label;

import ui.element;
import render;
import render.font;
import color;
import geometry;
import std.math.traits;

public class Label : Element
{
	string text;
	Color color;
	Font font;

	this(string text, Color color = WHITE, Font font = Font(Fonts.ROBOTO, 16))
	{
		this.text = text;
		this.color = color;
		this.font = font;
	}

	override @property real width()
	{
		return isNaN(_width) ? Renderer.textSize(text, font).x : _width;
	}

	override @property real height()
	{
		return isNaN(_height) ? Renderer.textSize(text, font).y : _height;
	}

	override void draw(Renderer r)
	{
		r.text(text, Point(x, y), font, color, TextAlignment.TOPLEFT);
	}
}
