import std.stdio;
import std.string;
import std.conv : to;
import derelict.sdl2.sdl;
import colorize;
import util;

/// Exception for SDL related issues
class SDLException : Exception
{
	/// Creates an exception from SDL_GetError()
	this(string file = __FILE__, size_t line = __LINE__) nothrow @nogc
	{
		super(cast(string) SDL_GetError().fromStringz, file, line);
	}
}

bool quit;
SDL_Window* window;
SDL_Renderer* renderer;
Point windowSize = Point(800, 600);
Point mouse;
Point view;
int zoom = 0;
float scale = 1;

void main()
{
	log("Initializing");
	DerelictSDL2.load();

	if (SDL_Init(SDL_INIT_EVERYTHING) < 0)
		throw new SDLException();

	window = SDL_CreateWindow("dogical", SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED, windowSize.x, windowSize.y, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
	if (!window)
		throw new SDLException();

	SDL_SetHint(SDL_HINT_RENDER_VSYNC, "1");
	renderer = SDL_CreateRenderer(window, -1, 0);
	if (!renderer)
		throw new SDLException();
	renderer.SDL_SetRenderDrawBlendMode(SDL_BLENDMODE_BLEND);

	SDL_GetMouseState(&mouse.x, &mouse.y);

	log("Entering program loop");
	while (!quit)
	{
		pollEvents();
		update();
		draw();
	}

	log("Quitting");
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);

	SDL_Quit();
}

Point toGrid(Point p)
{
	return (p + view - windowSize / 2) / scale;
}

Point toView(Point p)
{
	return p * scale - view + windowSize / 2;
}

SDL_Rect* toView(Rect r)
{
	return Rect(r.origin.toView, r.size * scale).toSDL;
}

SDL_Rect* toGrid(Rect r)
{
	return Rect(r.origin.toGrid, r.size / scale).toSDL;
}

enum LogLevel
{
	Default = fg.white,
	Warning = fg.yellow,
	Error = fg.red,
	Debug = fg.light_black
}

void log(string msg, LogLevel level = LogLevel.Default)
{
	writefln("%s", color(msg, level));
}

void pollEvents()
{
	SDL_Event event;
	while (SDL_PollEvent(&event))
	{
		switch (event.type)
		{
		case SDL_QUIT:
			quit = true;
			break;
		case SDL_MOUSEMOTION:
			onMouseMotion(event.motion);
			break;
		case SDL_MOUSEBUTTONDOWN:
			onMouseDown(event.button);
			break;
		case SDL_MOUSEBUTTONUP:
			onMouseUp(event.button);
			break;
		case SDL_MOUSEWHEEL:
			onMouseWheel(event.wheel);
			break;
		case SDL_KEYDOWN:
			onKeyDown(event.key);
			break;
		case SDL_KEYUP:
			onKeyUp(event.key);
			break;
		case SDL_DROPFILE:
			onFileDrop(event.drop);
			break;
		case SDL_WINDOWEVENT:
			onWindowEvent(event.window);
			break;
		default:
			log("Unhandled event of type " ~ format("0x%X", event.type), LogLevel.Warning);
		}
	}
}

void update()
{

}

void draw()
{
	renderer.SDL_SetRenderColor(COLOR_BLACK);
	renderer.SDL_RenderClear();

	renderer.SDL_SetRenderColor(COLOR_WHITE);
	renderer.SDL_RenderFillRect(Rect(-50, -50, 100, 100).toView);

	renderer.SDL_RenderPresent();
}

void onMouseMotion(SDL_MouseMotionEvent event)
{
	mouse = Point(event.x, event.y);
	if (event.state & SDL_BUTTON_MMASK)
	{
		view -= Point(event.xrel, event.yrel);
	}
}

void onMouseDown(SDL_MouseButtonEvent event)
{

}

void onMouseUp(SDL_MouseButtonEvent event)
{

}

void onMouseWheel(SDL_MouseWheelEvent event)
{
	import std.math : pow;
	Point oldPoint = mouse.toGrid;
	zoom += event.y;
	auto prevScale = scale;
	scale = pow(1.1, zoom);
	Point newPoint = mouse.toGrid;
	view += (oldPoint - newPoint) * scale;	//finally...
}

void onKeyDown(SDL_KeyboardEvent event)
{

}

void onKeyUp(SDL_KeyboardEvent event)
{

}

void onFileDrop(SDL_DropEvent event)
{

}

void onWindowEvent(SDL_WindowEvent event)
{

}