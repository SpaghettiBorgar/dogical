module render.render;

import std.typecons : tuple;
import std.math : round, floor, ceil;
import std.conv : to;
import std.algorithm.comparison : max, min, clamp;
import std.stdio;
import std.string;

// import derelict.sdl2.sdl;
// import derelict.sdl2.ttf;
//import derelict.sdl2.gfx;

import bindbc.sdl;
import bindbc.sdl.ttf;

import exception;
import settings;
import color;
import geometry;
import component.component;
import render.font;

enum TextAlignment
{
	TOPLEFT = tuple(-1, -1),
	TOPCENTER = tuple(0, -1),
	TOPRIGHT = tuple(1, -1),
	CENTERLEFT = tuple(-1, 0),
	CENTER = tuple(0, 0),
	CENTERRIGHT = tuple(1, 0),
	BOTTOMLEFT = tuple(-1, 1),
	BOTTOMCENTER = tuple(0, 1),
	BOTTOMRIGHT = tuple(1, 1)
}

class Renderer
{

	// TTF_Font* FONT;

	SDL_Renderer* sdlr;

	Point offset = Point(0, 0);
	real zoom = 0;
	real scale = 1;
	Point* windowSize;

	this(SDL_Renderer* sdlr)
	{
		// FONT = TTF_OpenFont("res/consola.ttf", 22);
		if (!sdlr)
			throw new SDLException();
		this.sdlr = sdlr;

	}

	void prepare(Color bg)
	{
		sdlr.SDL_SetRenderDrawColor(bg.r, bg.g, bg.b, bg.a);
		sdlr.SDL_RenderClear();
	}

	void finalize()
	{
		sdlr.SDL_RenderPresent();
	}

	Point project(Point p)
	{
		return p * scale - offset + *windowSize / 2;
	}

	Rect project(Rect r)
	{
		return Rect(project(Point(r.x, r.y)), r.w * scale, r.h * scale);
	}

	Line project(Line l)
	{
		return Line(project(l.p1), project(l.p2));
	}

	Point unproject(Point p)
	{
		return (p + offset - *windowSize / 2) / scale;
	}

	Rect unproject(Rect r)
	{
		return Rect(unproject(Point(r.x, r.y)), r.w / scale, r.h / scale);
	}

	Line unproject(Line l)
	{
		return Line(unproject(l.p1), unproject(l.p2));
	}

	void rect(Rect r, Color c, bool fill)
	{
		// writeln(r.x, " ", r.y, " ", r.w, " ", r.h, " ", c.r, " ", c.g, " ", c.b, " ", c.a);
		if (!r.isDefined)
			return;
		sdlr.SDL_SetRenderDrawColor(c.r, c.g, c.b, c.a);
		auto sr = cast(SDL_FRect) r;
		if (fill)
			sdlr.SDL_RenderFillRectF(&sr);
		else
			sdlr.SDL_RenderDrawRectF(&sr);
	}

	void rect(real x, real y, real w, real h, Color c, bool fill)
	{
		rect(Rect(x, y, w, h), c, true);
	}

	void line(Line line, Color c)
	{
		sdlr.SDL_SetRenderDrawColor(c.r, c.g, c.b, c.a);
		sdlr.SDL_RenderDrawLine(line.p1.x.to!int, line.p1.y.to!int, line.p2.x.to!int, line
				.p2.y.to!int);
	}

	Rect componentRect(Component c)
	{
		return Rect(c.pos.x, c.pos.y, componentSize * 2, max(c.inputs.length, c.outputs.length, 2) * componentSize);
	}

	Rect inputRect(Component c, ulong i)
	{
		return Rect(c.pos.x - 8, c.pos.y + (max(c.inputs.length, c.outputs.length, 2) - c
				.inputs.length) * componentSize / 2 + i * componentSize + componentSize / 2 - 4, 8, 8);
	}

	Rect outputRect(Component c, ulong i)
	{
		return Rect(c.pos.x + componentSize * 2, c.pos.y + (max(c.inputs.length, c.outputs.length, 2) - c
				.outputs.length) * componentSize / 2 + i * componentSize + componentSize / 2 - 4, 8, 8);
	}

	void component(Component c, bool selected = false)
	{
		auto inps = c.inputs.length;
		auto outps = c.outputs.length;
		auto maxh = max(inps, outps, 2);
		auto minh = min(inps, outps, 2);
		rect(project(Rect(c.pos, componentSize * 2, maxh * componentSize)), c.bgcolor, true);
		if (selected)
			rect(project(Rect(c.pos, componentSize * 2, maxh * componentSize)), COLOR_SELECTED, false);
		foreach (i, inp; c.inputs)
		{
			rect(project(Rect(c.pos.x - 8, c.pos.y + (
					maxh - inps) * componentSize / 2 + i * componentSize + componentSize / 2 - 4, 8, 8)), inp ? COLOR_ACTIVE : COLOR_INACTIVE, true);
		}
		foreach (i, outp; c.outputs)
		{
			rect(project(Rect(c.pos.x + componentSize * 2, c.pos.y + (
					maxh - outps) * componentSize / 2 + i * componentSize + componentSize / 2 - 4, 8, 8)), outp ? COLOR_ACTIVE : COLOR_INACTIVE, true);
		}
		//text(c.label, project(Point(c.pos.x + componentSize, c.pos.y + componentSize * maxh)), Font(Fonts.DEFAULT, clamp(cast(int) ceil(16 * scale), 8, 64)), COLOR_COMPONENTTEXT, TextAlignment.TOPCENTER);
		c.label.draw(this);
	}

	void text(string text, Point pos, Font font, Color c, TextAlignment alignment)
	{
		TTF_Font* ttf_font = getFont(font);
		TTF_SetFontHinting(ttf_font, TTF_HINTING_LIGHT);

		SDL_Surface* surface = TTF_RenderUTF8_Blended_Wrapped(ttf_font, text.toStringz, cast(
				SDL_Color) c, 0);
		if (surface is null)
			return;
		SDL_Texture* texture = sdlr.SDL_CreateTextureFromSurface(surface);
		scope (exit)
			texture.SDL_DestroyTexture();

		surface.SDL_FreeSurface();

		sdlr.SDL_RenderCopy(texture, null, new SDL_Rect(
				cast(int) round(pos.x - ((alignment[0] + 1) / 2.) * surface.w),
				cast(int) round(pos.y - ((alignment[1] + 1) / 2.) * surface.h),
				surface.w, surface.h));
	}

	static Point textSize(string text, Font font)
	{
		int w, h;
		TTF_Font* ttf_font = getFont(font);
		TTF_SizeUTF8(ttf_font, text.toStringz, &w, &h);

		return Point(w, h);
	}
}
