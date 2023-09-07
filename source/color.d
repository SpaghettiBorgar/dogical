module color;

struct Color
{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a;

	// this(ubyte r, ubyte g, ubyte b, ubyte a)
	// {
	// 	this.r = r;
	// 	this.g = g;
	// 	this.b = b;
	// 	this.a = a;
	// }

	// this(ubyte r, ubyte g, ubyte b)
	// {
	// 	this(r, g, b, 255);
	// }

	SDL_Color opCast(SDL_Color)() const
	{
		return SDL_Color(r, g, b, a);
	}

	Color withAlpha(ubyte alpha)
	{
		return Color(r, g, b, alpha);
	}

	Color opBinary(string op)(Color rhs)
	{
		mixin(q{return Color(cast(ubyte) (r} ~ op ~ q{rhs.r), cast(ubyte) (g} ~ op ~ q{rhs.g), cast(ubyte) (b} ~ op ~ q{rhs.b), a);});
	}

	Color invert()
	{
		return Color(255, 255, 255, 255) - this;
	}
}

immutable Color WHITE = Color(255, 255, 255, 255);
immutable Color BLACK = Color(0, 0, 0, 255);
immutable Color TRANSPARENT = Color(0, 0, 0, 0);
