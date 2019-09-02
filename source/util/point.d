module util.point;

import std.conv : to;

import derelict.sdl2.sdl : SDL_Point;
import util.math;

struct Point
{
	int x;
	int y;
	Point opBinary(string op)(Point rhs)
	{
		mixin(q{return Point(x}~op~q{rhs.x, y}~op~q{rhs.y);});
	}
	Point opBinary(string op)(real rhs)
	{
		mixin(q{return Point(round(this.x}~op~q{rhs), round(this.y}~op~q{rhs));});
	}
	void opOpAssign(string op, T)(T rhs)
	{
		mixin(q{this = this}~op~q{rhs;});
	}
	string toString()
	{
		return this.x.to!string~","~this.y.to!string;   
	}
	SDL_Point* toSDL()
	{
		return new SDL_Point(x, y);
	}
}