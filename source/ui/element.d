module ui.element;

import geometry;
import render;
import std.math.traits;
import std.algorithm.comparison : min, max, clamp;

struct Anchor
{

	float xAlign; // -1 to 1, relative position to parent
	float yAlign;

	private real _clamp(real val, real lower, real upper)
	{
		return clamp(val, min(lower, upper), max(lower, upper));
	}

	real calcXcenter(real sizeE, real sizeP)
	{
		return _clamp((xAlign + 1) / 2 * sizeP, sizeE / 2, sizeP - sizeE / 2);
	}

	real calcYcenter(real sizeE, real sizeP)
	{
		return _clamp((yAlign + 1) / 2 * sizeP, sizeE / 2, sizeP - sizeE / 2);
	}

	real calcX(real sizeE, real sizeP)
	{
		return calcXcenter(sizeE, sizeP) - sizeE / 2;
	}

	real calcY(real sizeE, real sizeP)
	{
		return calcYcenter(sizeE, sizeP) - sizeE / 2;
	}
}

struct Size
{
	real minSize;
	real maxSize;
	real factor = 1;

	this(real factor)
	{
		this.factor = factor;
	}

	this(real factor, real minSize, real maxSize)
	{
		this(factor);
		this.minSize = minSize;
		this.maxSize = maxSize;
	}

	this(real factor, real fixedSize)
	{
		this(factor, fixedSize, fixedSize);
	}

}

immutable Anchor ANCHOR_CENTER = Anchor(0, 0);

public abstract class Element
{
	immutable string _name = "Element";

	Element parent;
	Anchor _anchor;

	Size sWidth, sHeight;

	protected real _width; // NaN indicates dynamic sizing, real value means fixed size
	protected real _height;
	protected real _x; // NaN indicates dynamic position by anchor, real value means fixed relative position
	protected real _y;

	this(Size sWidth = Size.init, Size sHeight = Size.init, Anchor anchor = ANCHOR_CENTER)
	{
		this.sWidth = sWidth;
		this.sHeight = sHeight;
		this.anchor = anchor;
	}

	@property real width()
	{
		// return isNaN(_width) ? 200 : _width;
		return _width;
	}

	@property void width(real w)
	{
		_width = w;
	}

	@property real height()
	{
		// return isNaN(_height) ? 200 : _height;
		return _height;
	}

	@property void height(real h)
	{
		_height = h;
	}

	@property real x()
	{
		return isNaN(anchor.xAlign) ? _x : parent.x + anchor.calcX(this.width, parent.width);
	}

	@property void x(real x)
	{
		_x = x;
		_anchor.xAlign = real.nan;
	}

	@property real y()
	{
		return isNaN(anchor.yAlign) ? _y : parent.y + anchor.calcY(this.height, parent.height);
	}

	@property void y(real y)
	{
		_y = y;
		_anchor.yAlign = real.nan;
	}

	@property Point pos()
	{
		return Point(x, y);
	}

	@property void pos(Point p)
	{
		x = p.x;
		y = p.y;
	}

	@property Point size()
	{
		return Point(width, height);
	}

	@property void size(Point p)
	{
		width = p.x;
		height = p.y;
	}

	@property Anchor anchor()
	{
		return this._anchor;
	}

	@property void anchor(Anchor a)
	{
		this._anchor = a;
		if (!isNaN(a.xAlign))
			_x = real.nan;
		if (!isNaN(a.yAlign))
			_y = real.nan;
	}

	void draw(Renderer);

	void drawDebug(Renderer r)
	{
		import color;

		import std.format;

		draw(r);
		r.rect(Rect(x, y, width, height), WHITE, false);
		if (width > 80)
		{
			r.text(format!"%s"(this.toString), pos + Point(size.x, 0) / 2,
				FONT_DEBUG, WHITE, TextAlignment.TOPCENTER);
			r.text(format!"(%.1f %.1f)"(x, y), pos,
				FONT_DEBUG, WHITE, TextAlignment.TOPLEFT);
			r.text(format!"[%.1fx%.1f]"(width, height), pos + size,
				FONT_DEBUG, WHITE, TextAlignment.BOTTOMRIGHT);
		}
	}

	override string toString()
	{
		import std.string;

		string className = typeid(this).name;
		className = className[className.lastIndexOf(".") + 1 .. $];
		return className;
	}
}
