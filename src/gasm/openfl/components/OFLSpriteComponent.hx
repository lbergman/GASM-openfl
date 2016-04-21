package gasm.openfl.components;
import gasm.core.components.SpriteModelComponent;
import gasm.core.events.OverEvent;
import gasm.core.events.PressEvent;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import gasm.core.Component;
import gasm.core.enums.ComponentType;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Leo Bergman
 */
class OFLSpriteComponent extends Component
{
	public var sprite(default, default):DisplayObjectContainer;
	private var _base:Bool;
	
	public function new(sprite:Sprite, ?mouseEnabled:Bool = false, base:Bool = false) 
	{
		this.sprite = sprite;
		sprite.mouseEnabled = mouseEnabled;
		componentType = ComponentType.Graphics;
		_base = base;
	}
	
	override public function init()
	{
		var model = owner.get(SpriteModelComponent);
		if (sprite.width > 0)
		{
			model.width = sprite.width;			
			model.height = sprite.height;
		}
		sprite.addEventListener(MouseEvent.CLICK, function(e:MouseEvent)
		{
			if(model.pressHandler != null)
			{
				model.pressHandler(new PressEvent( { x:sprite.mouseX, y:sprite.mouseY }, owner));
			}
		});
		sprite.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent)
		{
			if(model.overHandler != null)
			{
				model.overHandler(new OverEvent( { x:sprite.mouseX, y:sprite.mouseY }, owner));
			}
		});
	}
	
	override public function update(dt:Float) 
	{
		var model = owner.get(SpriteModelComponent);
		sprite.x = model.x + model.offsetX;
		sprite.y = model.y + model.offsetY;
		if (_base)
		{
			if (sprite.width > 0)
			{
				model.width = sprite.width;
				model.height = sprite.height;				
			}
		}
		else
		{
			sprite.width = model.width;
			sprite.height = model.height;
		}
	}
}