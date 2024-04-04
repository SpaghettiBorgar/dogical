module geometry;

// import derelict.sdl2.sdl;

import bindbc.sdl;

import std.conv : to;
import std.math : floor, round, ceil;
import std.math.traits;
import std.algorithm.comparison;

struct Point
{
	real x;

	real y;

	bool within(Rect r)
	{
		return x >= r.x && x <= r.x + r.w && y >= r.y && y <= r.y + r.h;
	}

	auto opBinary(string op)(const Point rhs) const
	{
		mixin(q{return Point(x} ~ op ~ q{rhs.x, y} ~ op ~ q{rhs.y);});
	}

	auto opBinary(string op)(const real rhs) const
	{
		mixin(q{return Point(x} ~ op ~ q{rhs, y} ~ op ~ q{rhs);});
	}

	void opOpAssign(string op, T)(T rhs)
	{
		mixin(q{this = this} ~ op ~ q{rhs;});
	}

	string toString() const
	{
		return this.x.to!string ~ "," ~ this.y.to!string;
	}

	bool isDefined()
	{
		return !(isNaN(x) || isNaN(y));
	}
}

struct Line
{
	Point p1;
	Point p2;
}

struct Rect
{
	real x;
	real y;
	real w;
	real h;
	Point middle()
	{
		return Point(x + w / 2, y + h / 2);
	}

	this(real x, real y, real w, real h)
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	this(Point pos, real w, real h)
	{
		this.x = pos.x;
		this.y = pos.y;
		this.w = w;
		this.h = h;
	}

	this(Point pos, Point size)
	{
		this.x = pos.x;
		this.y = pos.y;
		this.w = size.x;
		this.h = size.y;
	}

	this(T)(T sdlrect)
	{
		x = sdlrect.x;
		y = sdlrect.y;
		w = sdlrect.w;
		h = sdlrect.h;
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
		return Point(w, h);
	}

	@property void size(Point s)
	{
		w = s.x;
		h = s.y;
	}

	bool contains(Point p)
	{
		return p.x >= x && p.x <= x + w && p.y >= y && p.y <= y + h;
	}

	bool isDefined() const
	{
		return !(isNaN(x) || isNaN(y) || isNaN(w) || isNaN(h));
	}

	bool intersects(Rect r)
	{
		// dfmt off
		return r.isDefined && this.isDefined &&
			 ! (this.x > r.x + r.w
			|| r.x > this.x + this.w
			|| this.y > r.y + r.h
			|| r.y > this.y + this.h);
		// dfmt on
	}

	Rect intersection(Rect r)
	{
		if (!this.intersects(r))
			return Rect(real.nan, real.nan, real.nan, real.nan);

		Rect ret;
		ret.x = max(this.x, r.x);
		ret.y = max(this.y, r.y);
		ret.w = min(this.x + this.w, r.x + r.w) - ret.x;
		ret.h = min(this.y + this.h, r.y + r.h) - ret.y;
		return ret;
	}

	SDL_FRect opCast(T : SDL_FRect)() const
	{
		return SDL_FRect(x, y, w, h);
	}

	SDL_Rect opCast(T : SDL_Rect)() const
	{
		return !isDefined() ? SDL_Rect(0, 0, 1, 1) : SDL_Rect(cast(int) round(x), cast(int) round(y),
			cast(int) round(w), cast(int) round(h));
	}

}
