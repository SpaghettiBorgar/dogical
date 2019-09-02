module util.math;

int round(real x)
{
	import std.math : round;
	return cast(int) round(x);
}

int ceil(real x)
{
	import std.math : ceil;
	return cast(int) ceil(x);
}

int floor(real x)
{
	import std.math : floor;
	return cast(int) floor(x);
}