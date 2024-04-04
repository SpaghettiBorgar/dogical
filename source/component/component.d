module component.component;

import color;
import geometry;
import ui;
import render;
import component.pin;
import std.algorithm.iteration : fold;
import std.algorithm.comparison : max;
import settings;
import std.math.traits;

abstract class Component : Box
{
	immutable string _name = "Component";

	bool selected;
	Input[] inputs;
	Output[] outputs;
	Column inputContainer;
	Column outputContainer;

	final void addOutputs(bool[] bools...)
	{
		foreach (b; bools)
		{
			outputs ~= new Output(b, this, cast(int) outputs.length);
			outputContainer.add(outputs[$ - 1]);
		}
	}

	final void addInputs(Output[] outputs...)
	{
		foreach (o; outputs)
		{
			inputs ~= new Input(o, this, inputs.length);
			inputContainer.add(inputs[$ - 1]);
		}
	}

	this(Point pos, string label, Color bgcolor = TRANSPARENT)
	{
		super(pos, bgcolor, label, 80, 80);
		this.pos = pos;
		inputContainer = new Column();
		inputContainer.parent = this;
		inputContainer.size = Point(8, height);
		inputContainer.relPos = Anchor(-1, 0);
		inputContainer.attachment = Anchor(0, 0);
		outputContainer = new Column();
		outputContainer.parent = this;
		outputContainer.size = Point(8, height);
		outputContainer.relPos = Anchor(1, 0);
		outputContainer.attachment = Anchor(0, 0);
	}

	// override real height() @property
	// {
	// return isNaN(this._height) ? max(inputContainer.height, outputContainer.height) : _height;
	// }

	override void _draw(Renderer r)
	{
		if (selected)
			bordercolor = COLOR_SELECTED;
		else
			bordercolor = bgcolor;
		super._draw(r);

		inputContainer.draw(r);
		outputContainer.draw(r);

		// 	auto inps = inputs.length;
		// 	auto outps = outputs.length;
		// 	auto maxh = max(inps, outps, 2);
		// 	auto minh = min(inps, outps, 2);
		// 	rect(project(Rect(c.pos, componentSize * 2, maxh * componentSize)), c.color, true);
		// 	if(selected)
		// 		rect(project(Rect(c.pos, componentSize * 2, maxh * componentSize)), COLOR_SELECTED, false);
		// 	foreach(i, inp; c.inputs)
		// 	{
		// 		rect(project(Rect(c.pos.x - 8, c.pos.y + (maxh - inps) * componentSize / 2 + i * componentSize + componentSize / 2 - 4, 8, 8)), inp ? COLOR_ACTIVE : COLOR_INACTIVE, true);
		// 	}
		// 	foreach(i, outp; c.outputs)
		// 	{
		// 		rect(project(Rect(c.pos.x + componentSize * 2, c.pos.y + (maxh - outps) * componentSize / 2 + i * componentSize + componentSize / 2 - 4, 8, 8)), outp ? COLOR_ACTIVE : COLOR_INACTIVE, true);
		// 	}
		// 	text(c.label, project(Point(c.pos.x + componentSize, c.pos.y + componentSize * maxh)), Font(Fonts.DEFAULT, clamp(cast(int) ceil(16 * scale), 8, 64)), COLOR_COMPONENTTEXT, TextAlignment.TOPCENTER);

	}
}
