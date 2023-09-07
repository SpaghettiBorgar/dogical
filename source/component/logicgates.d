module component.logicgates;

import component.component;
import color;
import geometry;

class NotGate : Component
{
	this(Point pos)
	{
		super("Not", Color(120, 120, 60), pos);
		addInputs(null);
		addOutputs(true);
	}
}

class AndGate : Component
{

	this(Point pos)
	{
		super("And", Color(120, 80, 80), pos);
		addInputs(null, null);
		addOutputs(false, false);
	}
}

class OrGate : Component
{

	this(Point pos)
	{
		super("Or", Color(80, 60, 120), pos);
		addInputs(null, null, null, null);
		addOutputs(false);
	}
}
