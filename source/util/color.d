module util.color;

struct RGB
{
	ubyte r;
	ubyte g;
	ubyte b;
}

struct RGBA
{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a;
}

immutable RGB COLOR_TRUE = RGB(20, 220, 20);
immutable RGB COLOR_FALSE = RGB(220, 20, 20);
immutable RGB COLOR_WIRE_TRUE = COLOR_TRUE;
immutable RGB COLOR_WIRE_FALSE = COLOR_FALSE;
immutable RGB COLOR_BACKGROUND = RGB(20, 20, 20);
immutable RGBA COLOR_BARSELECT = RGBA(40, 180, 40, 80);

immutable RGB COLOR_WHITE = RGB(255, 255, 255);
immutable RGB COLOR_BLACK = RGB(0, 0, 0);
