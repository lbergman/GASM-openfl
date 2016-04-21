package gasm.openfl;
import gasm.core.components.SpriteModelComponent;
import gasm.core.ISystem;
import gasm.openfl.components.OFLSpriteComponent;
import gasm.openfl.systems.OFLCoreSystem;
import openfl.display.Sprite;
import openfl.events.Event;
import gasm.core.Context;
import gasm.core.Engine;
import gasm.core.Entity;
import gasm.core.enums.SystemType;
import gasm.core.System;
import gasm.openfl.systems.OFLRenderingSystem;
import gasm.openfl.systems.OFLSoundSystem;

/**
 * ...
 * @author Leo Bergman
 */
class OFLContext extends Sprite implements Context
{
	public var baseEntity(get, null):Entity;
	public var systems(default, null):Array<ISystem>;
	
	var _engine:Engine;
	
	public function new() 
	{
		super();
		
		var core = new OFLCoreSystem(this);
		var renderer = new OFLRenderingSystem(this);
		var sound = new OFLSoundSystem();
		systems = [core, renderer, sound];
		
		_engine = new Engine(systems);
		
		if (stage == null)
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		else
		{
			init();
		}
	}
	
	function onEnterFrame(e:Event):Void 
	{
		_engine.tick();
	}
	
	function onAddedToStage(e:Event) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		init();
	}
	
	function init() 
	{
		
		baseEntity.add(new OFLSpriteComponent(this, true, true));
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	public function get_baseEntity():Entity
	{
		return _engine.baseEntity;
	}
	
}