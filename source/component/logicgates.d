module component.logicgates;

import component.component;
import color;
import geometry;

class NotGate : Component
{
	this(Point pos)
	{
		super(pos, "Not", Color(120, 120, 60));
		addInputs(null);
		addOutputs(true);
	}
}

class AndGate : Component
{

	this(Point pos)
	{
		super(pos, "And", Color(120, 80, 80));
		addInputs(null, null);
		addOutputs(false, false);
	}
}

class OrGate : Component
{

	this(Point pos)
	{
		super(pos, "Or", Color(80, 60, 120));
		addInputs(null, null, null, null);
		addOutputs(false);
	}
}
