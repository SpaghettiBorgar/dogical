module render.font;

// import derelict.sdl2.ttf;

import bindbc.sdl;
import bindbc.sdl.ttf;

import exception;

struct Font
{
	string name;
	int size;
	this(string name, int size)
	{
		this.name = name;
		this.size = size;
	}

	this(Fonts name, int size)
	{
		this.name = name;
		this.size = size;
	}
}

enum Fonts : string
{
	CONSOLA = "consola",
	ARIAL = "arial",
	ROBOTO = "roboto",
	SEGOEUI = "segoeui"
}

TTF_Font*[Font] fontCache;

static
{
	TTF_Font* getFont(string path, int size)
	{
		return getFont(Font(path, size));
	}
}

TTF_Font* getFont(Font font)
{
	import std.string : toStringz;

	if (!(font in fontCache))
		fontCache[font] = TTF_OpenFont(("res/fonts/" ~ font.name ~ ".ttf").toStringz, font.size);
	if (!fontCache[font])
		throw new SDLException;
	return fontCache[font];
}

immutable Font FONT_DEBUG = Font(Fonts.CONSOLA, 14);
