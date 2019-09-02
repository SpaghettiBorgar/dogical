module util.rect;

import derelict.sdl2.sdl : SDL_Rect;
import util.point;

struct Rect
{
	Point origin;
	Point size;

	this(Point origin, Point size)
	{
		this.origin = origin;
		this.size = size;
	}
	
	this(int x, int y, int w, int h)
	{
		this.origin = Point(x, y);
		this.size = Point(w, h);
	}

	SDL_Rect* toSDL()
	{
		return new SDL_Rect(origin.x, origin.y, size.x, size.y);
	}
}