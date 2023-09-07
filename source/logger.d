module logger;

import std.logger;

class DebugLogger : Logger
{
	this()
	{
		super(LogLevel.trace);
	}

	override void writeLogMsg(ref LogEntry payload)
	{

	}
}

// DebugLogger logger = new DebugLogger();
