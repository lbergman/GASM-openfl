package gasm.openfl.systems;
import gasm.core.Component;
import gasm.core.enums.ComponentType;
import gasm.core.ISystem;
import gasm.core.System;
import gasm.core.enums.SystemType;
import gasm.core.utils.Bits;

/**
 * ...
 * @author Leo Bergman
 */
using gasm.core.utils.BitUtils;

class OFLSoundSystem extends System implements ISystem
{
	
	public function new() 
	{
		type = type.add(SystemType.SOUND);
		componentFlags = componentFlags.add(Sound);
	}
	
	public function update(comp:Component, delta:Float) 
	{
		if (!comp.inited)
		{
			comp.init();
			comp.inited = true;
		}
		comp.update(delta);
	}
	
}