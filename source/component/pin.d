module component.pin;

import ui.box;
import component;
import settings;
import color;

class Pin : Box
{
	this(Component comp, ulong index)
	{
		super(COLOR_INACTIVE, null);
		this.comp = comp;
		this.index = index;
	}

	Component comp;
	ulong index;
	override @property real width()
	{
		return 8;
	}

	override @property real height()
	{
		return 8;
	}
}

class Output : Pin
{
	this(bool state, Component comp, ulong index)
	{
		super(comp, index);
		this.state = state;
	}

	bool state;
	bool opCast(T : bool)()
	{
		return state;
	}
}

class Input : Pin
{
	this(Output source, Component comp, ulong index)
	{
		super(comp, index);
		this.source = source;
	}

	Output source;
	bool opCast(T : bool)()
	{
		return source != null && source.state;
	}
}
