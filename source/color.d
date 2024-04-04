module color;

struct Color
{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a = 0xFF;

	SDL_Color opCast(SDL_Color)() const
	{
		return SDL_Color(r, g, b, a);
	}

	Color withAlpha(ubyte alpha) const
	{
		return Color(r, g, b, alpha);
	}

	Color opBinary(string op)(Color rhs)
	{
		// dfmt off
		mixin(q{
			return Color(
				cast(ubyte) (r} ~ op ~ q{rhs.r),
				cast(ubyte) (g} ~ op ~ q{rhs.g),
				cast(ubyte) (b} ~ op ~ q{rhs.b),
			a);
		});
		// dfmt on
	}

	Color invert()
	{
		return Color(255, 255, 255, 255) - this;
	}
}

immutable Color WHITE = Color(255, 255, 255, 255);
immutable Color BLACK = Color(0, 0, 0, 255);
immutable Color TRANSPARENT = Color(0, 0, 0, 0);

immutable Color COLOR_RED = Color(255, 0, 0, 255);
immutable Color COLOR_YELLOW = Color(255, 255, 0, 255);
immutable Color COLOR_GREEN = Color(0, 255, 0, 255);
immutable Color COLOR_CYAN = Color(0, 255, 255, 255);
immutable Color COLOR_BLUE = Color(0, 0, 255, 255);
immutable Color COLOR_MAGENTA = Color(255, 0, 255, 255);
