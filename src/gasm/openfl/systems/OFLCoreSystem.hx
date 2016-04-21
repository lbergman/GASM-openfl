package gasm.openfl.systems;
import gasm.core.Component;
import gasm.core.components.SpriteModelComponent;
import gasm.core.enums.SystemType;
import gasm.core.ISystem;
import gasm.core.System;
import gasm.openfl.components.OFLSpriteComponent;
import openfl.display.DisplayObjectContainer;

// Autoremoved by FD if organizing imports
import gasm.core.enums.ComponentType;
using gasm.core.utils.BitUtils;

/**
 * ...
 * @author Leo Bergman
 */
class OFLCoreSystem extends System implements ISystem
{
	
	public var root(default, null):DisplayObjectContainer;
	
	public function new(root:DisplayObjectContainer)
	{
		this.root = root;
		type = type.add(SystemType.CORE);
		componentFlags = componentFlags.add(GraphicsModel);
	}
	
	public function update(comp:Component, delta:Float) 
	{	
		if (!comp.inited)
		{		
			comp.init();
			comp.inited = true;
		}
		comp.update(delta);
		if (Std.is(comp, SpriteModelComponent))
		{
			var model:SpriteModelComponent = cast comp;
			model.stageMouseX = root.stage.mouseX;
			model.stageMouseY = root.stage.mouseY;
			var sp = model.owner.get(OFLSpriteComponent).sprite;
			model.mouseX = sp.mouseX;
			model.mouseY = sp.mouseY;
		}
	}
}