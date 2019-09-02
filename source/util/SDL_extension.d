module util.SDL_extension;

import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

import util.point;
import util.color;

void SDL_RenderThickLine(SDL_Renderer* render, int x1, int y1, int x2, int y2, int width)
{
	import std.math : sin, cos, atan2, round;
	float angle = atan2(cast(real) y2 - y1, cast(real) x2 - x1);

	for (int i; i < width; i++)
	{
		int shiftX = cast(int) round(sin(angle) * (i - width * 0.5));
		int shiftY = cast(int) round(-cos(angle) * (i - width * 0.5));
		render.SDL_RenderDrawLine(x1 + shiftX, y1 + shiftY, x2 + shiftX, y2 + shiftY);
	}
}

void SDL_RenderThickLine(SDL_Renderer* render, Point p1, Point p2, int width)
{
	SDL_RenderThickLine(render, p1.x, p1.y, p2.x, p2.y, width);
}

void SDL_SetRenderColor(SDL_Renderer* render, RGBA color)
{
	render.SDL_SetRenderDrawColor(color.r, color.g, color.b, color.a);
}

void SDL_SetRenderColor(SDL_Renderer* render, RGB color)
{
	render.SDL_SetRenderDrawColor(color.r, color.g, color.b, SDL_ALPHA_OPAQUE);
}