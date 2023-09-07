module geometry;

// import derelict.sdl2.sdl;

import bindbc.sdl;

import std.conv : to;
import std.math : floor, round, ceil;
import std.math.traits;

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

	string toString()
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

	this(Point p, real w, real h)
	{
		this.x = p.x;
		this.y = p.y;
		this.w = w;
		this.h = h;
	}

	this(SDL_Rect sdlrect)
	{
		x = sdlrect.x;
		y = sdlrect.y;
		w = sdlrect.w;
		h = sdlrect.h;
	}

	bool contains(Point p)
	{
		return p.x >= x && p.x <= x + w && p.y >= y && p.y <= y + h;
	}

	bool isDefined()
	{
		return !(isNaN(x) || isNaN(y) || isNaN(w) || isNaN(h));
	}

	SDL_FRect opCast(SDL_FRect)() const
	{
		return SDL_FRect(x, y, w, h);
	}
	// SDL_Rect opCast(SDL_Rect)() const
	// {
	// 	return SDL_Rect(cast(int) round(x), cast(int) round(y), cast(int) round(w), cast(int) round(h));
	// }

}
