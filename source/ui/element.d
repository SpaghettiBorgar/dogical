module ui.element;

import geometry;
import render;
import settings;
import std.math.traits;
import std.algorithm.comparison : min, max, clamp;

struct Anchor
{
	float xAlign; // -1 to 1, relative position to parent
	float yAlign;

	real calcX(real sizeP)
	{
		return (xAlign + 1) / 2 * sizeP;
	}

	real calcY(real sizeP)
	{
		return (yAlign + 1) / 2 * sizeP;
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
immutable Anchor ANCHOR_NAN = Anchor(real.nan, real.nan);

public abstract class Element
{
	immutable string _name = "Element";

	Element parent;
	Anchor _positionAnchor;
	Anchor _attachmentAnchor;

	protected real _width; // // NaN indicates dynamic sizing, real value means fixed size
	protected real _height;
	protected real _x; // NaN indicates dynamic position by position anchor, real value means fixed relative position
	protected real _y;

	this(Anchor pos = ANCHOR_CENTER, Anchor attach = ANCHOR_CENTER)
	{
		this._positionAnchor = Anchor(real.nan, real.nan);
		this._attachmentAnchor = Anchor(-1, -1);
	}

	this(Point pos, Anchor attach = ANCHOR_CENTER)
	{
		this(ANCHOR_NAN, attach);
		this.pos = pos;
	}

	@property real width()
	{
		return _width;
	}

	@property void width(real w)
	{
		_width = w;
	}

	@property real height()
	{
		return _height;
	}

	@property void height(real h)
	{
		_height = h;
	}

	@property real x()
	{
		return _x;
	}

	@property void x(real x)
	{
		_x = x;
		_positionAnchor.xAlign = real.nan;
	}

	@property real realX()
	{
		return parent.virtX
			+ (isNaN(this._positionAnchor.xAlign)
					? _x
					: _positionAnchor.calcX(parent.width))
			- _attachmentAnchor.calcX(this.width);
	}

	@property real virtX()
	{
		return realX;
	}

	@property real y()
	{
		return _y;
	}

	@property void y(real y)
	{
		_y = y;
		_positionAnchor.yAlign = real.nan;
	}

	@property real realY()
	{
		return parent.virtY
			+ (isNaN(this._positionAnchor.yAlign)
					? _y
					: _positionAnchor.calcY(parent.height))
			- _attachmentAnchor.calcY(this.height);
	}

	@property real virtY()
	{
		return realY;
	}

	@property Point realPos()
	{
		return Point(realX, realY);
	}

	@property Point virtPos()
	{
		return Point(virtX, virtY);
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

	@property Rect boundingRect()
	{
		return Rect(realPos, width, height);
	}

	@property void boundingRect(Rect r)
	{
		this.pos = r.pos;
		this.size = r.size;
	}

	@property Anchor relPos()
	{
		return this._positionAnchor;
	}

	@property void relPos(Anchor a)
	{
		this._positionAnchor = a;
		if (!isNaN(a.xAlign))
			_x = real.nan;
		if (!isNaN(a.yAlign))
			_y = real.nan;
	}

	@property Anchor attachment()
	{
		return this._attachmentAnchor;
	}

	@property void attachment(Anchor a)
	{
		this._attachmentAnchor = a;
	}

	abstract protected void _draw(Renderer);

	void draw(Renderer r)
	{
		_draw(r);
		if (settings.debugMode)
			drawDebug(r);
	}

	void drawDebug(Renderer r)
	{
		import color;

		import std.format;

		r.rect(boundingRect, WHITE, false);
		if (width > 80)
		{
			r.text(format!"%s"(this.toString), realPos + Point(size.x, 0) / 2,
				FONT_DEBUG, WHITE, TextAlignment.TOPCENTER);
			r.text(format!"%.0f %.0f"(realX, realY), realPos,
				FONT_DEBUG, WHITE, TextAlignment.TOPLEFT);
			r.text(format!"%.0fx%.0f"(width, height), realPos + size,
				FONT_DEBUG, WHITE, TextAlignment.BOTTOMRIGHT);
		}
		r.pixel(realPos, COLOR_RED);
		r.pixel(realPos + Point(attachment.calcX(width), attachment.calcY(height)), COLOR_GREEN);
	}

	override string toString() const
	{
		import std.string;

		string className = typeid(this).name;
		className = className[className.lastIndexOf(".") + 1 .. $];
		return className;
	}
}
