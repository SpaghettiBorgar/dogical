// import derelict.sdl2.sdl;
// import derelict.sdl2.ttf;

import bindbc.sdl;
import bindbc.sdl.ttf;
import etc.linux.memoryerror;
import std.stdio;
import std.string;
import std.datetime.stopwatch;
import std.algorithm : canFind;

import exception;
import render;
import settings;
import geometry;
import color;
import component;
import ui;
import std.conv : to;

Renderer r;
uint mousestate;
ubyte* keyboardstate;
Point mouse;
Point mouseclick;
Point view;

Point windowSize = Point(800, 600);
Component[] components;
Component[] selectedComponents;
Input selectedInput;
Output selectedOutput;

RootContainer rootContainer;
Container componentContainer;
bool uiDebug = true;
real fps = 0;

Point tmpOffset1 = Point(0, 0);
Point tmpOffset2 = Point(0, 0);

void main()
{
	// registerMemoryErrorHandler();
	// DerelictSDL2.load();
	// DerelictSDL2ttf.load();

	writeln(sdlSupport);
	writeln(__VENDOR__, __VERSION__);

	SDLSupport ret = loadSDL();
	if (ret != sdlSupport)
	{
		writeln("error loading library SDL");
	}

	if (loadSDLTTF() != sdlTTFSupport)
	{
		writeln("error loading library SDL TTF");
	}

	if (SDL_Init(SDL_INIT_VIDEO) < 0)
		throw new SDLException();

	if (TTF_Init() < 0)
		throw new SDLException();

	scope (exit)
	{
		SDL_Quit();
		TTF_Quit();
	}

	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");

	auto window = SDL_CreateWindow("Dogical", SDL_WINDOWPOS_UNDEFINED,
		SDL_WINDOWPOS_UNDEFINED, 800, 600, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
	if (!window)
		throw new SDLException();

	r = new Renderer(SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC));
	r.windowSize = &windowSize;

	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");

	components = [
		// new AndGate(Point(1, 1)), new NotGate(Point(-100, -100)),
		new OrGate(Point(200, 300))
	];
	componentContainer = new Container(cast(Element[]) components);
	rootContainer = new RootContainer(&windowSize.x, &windowSize.y, componentContainer);

	keyboardstate = SDL_GetKeyboardState(null);

	foreach (code; "abcçd") {
    	writeln(code);
    }

	bool quit = false;
	SDL_Event event;
	int frame;
	while (!quit)
	{
		while (SDL_PollEvent(&event))
		{
			switch (event.type)
			{
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
			case SDL_WINDOWEVENT:
				onWindowEvent(event.window);
				break;
			case SDL_QUIT:
				quit = true;
				break;
			default:
				break;
			}
		}

		// drawUITest2();
		// drawUITest();
		draw();
		frame++;
	}
}

void quit()
{
	auto ev = SDL_Event();
	ev.type = SDL_QUIT;
	SDL_PushEvent(&ev);
}

/// warning: memory leak
void drawUITest()
{
	void drawElement(Element e)
	{
		if (uiDebug)
			e.drawDebug(r);
		else
			e.draw(r);
	}

	static int frames = 0;
	static auto sw = StopWatch(AutoStart.no);
	if (!sw.running)
		sw.start();

	r.prepare(settings.COLOR_BACKGROUND);

	r.text("abcdefghijklmnopqrstuvwxyz\nABCDEFGHIJKLMNOPQRSTUVWXYZ", Point(400, 300),
		Font(Fonts.SEGOEUI, 20), Color(111, 235, 251, 100), TextAlignment.CENTERLEFT);

	RootContainer rc = new RootContainer(&windowSize.x, &windowSize.y);
	auto row = new Row();
	row.size = rc.size;
	row.height = 300;
	// auto b1 = new Box(Color(50, 40, 200), "some box", Size(1, 200, 600));
	// auto b2 = new Box(Color(200, 40, 50), "some larger box", Size(3, 200, 600));
	// auto b3 = new Box(Color(40, 200, 50), "box", Size(2, 100, 100));
	import std.algorithm;

	// [b1, b2, b3].each!(b => b.bordercolor = b.bgcolor.invert);
	// row.add(b1, b2, b3);
	rc.add(row);
	// row.update();
	drawElement(rc);

	r.text(fps.to!string, Point(windowSize.x, 0),
		Font(Fonts.CONSOLA, 20), Color(255, 255, 0), TextAlignment.TOPRIGHT);

	r.finalize();

	// [row, b1, b2, b3].each!destroy;

	frames++;
	if (sw.peek.total!"msecs" >= 1000)
	{
		fps = frames / (cast(real) sw.peek.total!"msecs" / 1000);
		writeln(fps, " fps");
		frames = 0;
		sw.reset();
	}
}

void drawUITest2()
{

	static int frames = 0;
	static auto sw = StopWatch(AutoStart.no);
	if (!sw.running)
		sw.start();

	r.prepare(settings.COLOR_BACKGROUND);

	RootContainer rc = new RootContainer(&windowSize.x, &windowSize.y);
	rc.bgcolor = COLOR_BACKGROUND;
	auto g1 = new OrGate(Point(150, 200));
	auto c2 = new Container(g1);
	auto c1 = new Container(c2);
	c1.bgcolor = COLOR_YELLOW.withAlpha(100);
	c2.bgcolor = COLOR_CYAN.withAlpha(100);
	c1.pos = Point(200, 100);
	c1.size = Point(400, 400);
	c2.pos = Point(100, 100);
	c2.size = Point(300, 300);
	c1.offset = tmpOffset1;
	c2.offset = tmpOffset2;
	// b1.pos = Point(250, 350);
	// b1.size = Point(300, 200);
	import std.algorithm;

	// [b1].each!(b => b.bordercolor = b.bgcolor.invert);
	rc.add(c1);
	rc.draw(r);

	Rect r1 = Rect(100, 200, 150, 250);
	Rect r2 = Rect(50, 250, 120, 150);
	Rect r3 = r1.intersection(r2);

	r.rect(r1, COLOR_BLUE, true);
	r.rect(r2, COLOR_RED, true);
	r.rect(r3, COLOR_MAGENTA, true);

	r.text(fps.to!string, Point(windowSize.x, 0),
		Font(Fonts.CONSOLA, 20), Color(255, 255, 0), TextAlignment.TOPRIGHT);

	r.text(mouse.to!string, Point(0, 0),
		Font(Fonts.CONSOLA, 20), Color(200, 255, 255), TextAlignment.TOPLEFT);

	r.finalize();

	[rc, g1].each!destroy;

	frames++;
	if (sw.peek.total!"msecs" >= 1000)
	{
		fps = frames / (cast(real) sw.peek.total!"msecs" / 1000);
		writeln(fps, " fps");
		frames = 0;
		sw.reset();
	}
}

void draw()
{
	void drawElement(Element e)
	{
		if (uiDebug)
			e.drawDebug(r);
		else
			e.draw(r);
	}

	auto sw = StopWatch(AutoStart.yes);
	r.prepare(settings.COLOR_BACKGROUND);

	componentContainer.size = rootContainer.size;
	drawElement(rootContainer);

	foreach (ref c; components)
	{
		// r.component(&c, selectedComponents.canFind(&c));
		foreach (inp; c.inputs)
		{
			if (inp.source)
			{
				writeln(inp.source.comp.virtPos);
				// r.line(Line(r.project(r.inputRect(inp.comp, inp.index).middle),
				// r.project(r.outputRect(inp.source.comp, inp.source.index).middle)),
				// inp ? COLOR_ACTIVE : COLOR_INACTIVE);
			}
		}
	}

	r.finalize();
	sw.stop();
	// writeln(sw.peek.total!"usecs");
}

void onMouseDown(SDL_MouseButtonEvent event)
{
	// mousestate = SDL_GetMouseState(&mouse.x, &mouse.y);
	// if (event.button == SDL_BUTTON_LEFT)
	// {
	// 	mouseclick = mouse;
	// 	bool hit = false;
	// 	foreach (ref c; components)
	// 	{
	// 		if (mouse.within(r.project(r.componentRect(c))))
	// 		{
	// 			hit = true;
	// 			if (!(keyboardstate[SDL_SCANCODE_LSHIFT] | keyboardstate[SDL_SCANCODE_RSHIFT]))
	// 				selectedComponents = [];
	// 			if (!selectedComponents.canFind(c))
	// 				selectedComponents ~= c;
	// 		}
	// 		else
	// 		{
	// 			foreach (i; 0 .. c.inputs.length)
	// 			{
	// 				if (mouse.within(r.project(r.inputRect(c, i))))
	// 				{
	// 					selectedInput = c.inputs[i];
	// 					hit = true;
	// 					selectedComponents = [];
	// 				}
	// 			}
	// 			foreach (i; 0 .. c.outputs.length)
	// 			{
	// 				if (mouse.within(r.project(r.outputRect(c, i))))
	// 				{
	// 					selectedOutput = c.outputs[i];
	// 					hit = true;
	// 					selectedComponents = [];
	// 				}
	// 			}
	// 		}
	// 	}
	// 	if (!hit)
	// 		selectedComponents = [];
	// }
}

void onMouseUp(SDL_MouseButtonEvent event)
{
	// mousestate = SDL_GetMouseState(&mouse.x, &mouse.y);
	// if (event.button == SDL_BUTTON_LEFT)
	// {
	// 	foreach (ref c; components)
	// 	{
	// 		if (selectedOutput)
	// 		{
	// 			foreach (i; 0 .. c.inputs.length)
	// 			{
	// 				if (mouse.within(r.project(r.inputRect(c, i))))
	// 				{
	// 					selectedInput = c.inputs[i];
	// 					selectedComponents = [];
	// 					selectedInput.source = selectedOutput;
	// 					writeln(selectedInput);
	// 					writeln(selectedOutput);
	// 				}
	// 			}
	// 		}
	// 		else if (selectedInput)
	// 		{
	// 			foreach (i; 0 .. c.outputs.length)
	// 			{
	// 				if (mouse.within(r.project(r.outputRect(c, i))))
	// 				{
	// 					selectedOutput = c.outputs[i];
	// 					selectedComponents = [];
	// 					selectedInput.source = selectedOutput;
	// 				}
	// 			}
	// 		}
	// 	}
	// 	selectedInput = null;
	// 	selectedOutput = null;
	// }
}

void onMouseMotion(SDL_MouseMotionEvent event)
{
	mouse = Point(event.x, event.y);
	if (event.state & SDL_BUTTON_MMASK)
	{
		r.offset.x -= event.xrel;
		r.offset.y -= event.yrel;
	}
	else if (event.state & SDL_BUTTON_LMASK)
	{
		// tmpOffset1 -= Point(event.xrel, event.yrel);
		foreach (ref c; selectedComponents)
		{
			c.virtPos += Point(event.xrel / r.scale, event.yrel / r.scale);
		}
	}
	else if (event.state & SDL_BUTTON_RMASK)
	{
		// tmpOffset2 -= Point(event.xrel, event.yrel);
	}
}

void onMouseWheel(SDL_MouseWheelEvent event)
{
	import std.math : pow;

	Point oldPoint = r.unproject(mouse);
	r.zoom += event.y;
	r.scale = pow(1.1, r.zoom);
	Point newPoint = r.unproject(mouse);
	r.offset += (oldPoint - newPoint) * r.scale;
}

void onKeyDown(SDL_KeyboardEvent event)
{
	keyboardstate = SDL_GetKeyboardState(null);

	if (event.keysym.sym == SDLK_ESCAPE || event.keysym.sym == SDLK_q)
		quit();

	switch (event.keysym.sym)
	{
	case SDLK_ESCAPE, SDLK_q:
		quit();
		break;
	case SDLK_F3:
		debugMode = !debugMode;
		break;
	default:
	}
}

void onKeyUp(SDL_KeyboardEvent event)
{
	keyboardstate = SDL_GetKeyboardState(null);
}

void onWindowEvent(SDL_WindowEvent event)
{
	switch (event.event)
	{
	case SDL_WINDOWEVENT_SHOWN:
		break;
	case SDL_WINDOWEVENT_HIDDEN:
		break;
	case SDL_WINDOWEVENT_EXPOSED:
		break;
	case SDL_WINDOWEVENT_MOVED:
		break;
	case SDL_WINDOWEVENT_RESIZED:
	case SDL_WINDOWEVENT_SIZE_CHANGED:
		windowSize = Point(event.data1, event.data2);
		break;
	case SDL_WINDOWEVENT_MINIMIZED:
		break;
	case SDL_WINDOWEVENT_MAXIMIZED:
		break;
	case SDL_WINDOWEVENT_RESTORED:
		break;
	case SDL_WINDOWEVENT_ENTER:
		break;
	case SDL_WINDOWEVENT_LEAVE:
		break;
	case SDL_WINDOWEVENT_FOCUS_GAINED:
		break;
	case SDL_WINDOWEVENT_FOCUS_LOST:
		break;
	case SDL_WINDOWEVENT_CLOSE:
		break;
	case SDL_WINDOWEVENT_TAKE_FOCUS:
		break;
	case SDL_WINDOWEVENT_HIT_TEST:
		break;
	default:
		break;
	}
}
