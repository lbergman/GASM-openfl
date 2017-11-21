package gasm.openfl.components;
import gasm.core.enums.InteractionType;
import gasm.core.events.InteractionEvent;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import gasm.core.components.SpriteModelComponent;
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
	var _base:Bool;

	public function new(sprite:DisplayObject, ?mouseEnabled:Bool = false, base:Bool = true) {
		if(!Std.is(sprite, DisplayObjectContainer)) {
			this.sprite = new Sprite();
			this.sprite.addChild(sprite);
		} else {
			this.sprite = cast(sprite, DisplayObjectContainer);
		}
		this.sprite.mouseEnabled = mouseEnabled;
		componentType = ComponentType.Graphics;
		_base = base;
	}
	override public function setup() {
		var model = owner.get(SpriteModelComponent);
		if (sprite.width > 0) {
			model.width = sprite.width;
			model.height = sprite.height;
		}
	}

	override public function init() {
		var model = owner.get(SpriteModelComponent);
		var mask:DisplayObject = model.mask;
		if(mask != null) {
			sprite.addChild(mask);
			sprite.mask = mask;
		}
		sprite.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
			model.triggerEvent(InteractionType.PRESS, { x:sprite.mouseX, y:sprite.mouseY }, owner);
		});
		sprite.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
			model.triggerEvent(InteractionType.OVER, { x:sprite.mouseX, y:sprite.mouseY }, owner);

		});
		sprite.addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) {
			model.triggerEvent(InteractionType.MOVE, { x:sprite.mouseX, y:sprite.mouseY }, owner);
		});
	}

	override public function update(dt:Float) {
		var model = owner.get(SpriteModelComponent);
		sprite.x = model.x + model.offsetX;
		sprite.y = model.y + model.offsetY;
		if (_base) {
			if (sprite.width > 0) {
				model.width = sprite.width;
				model.height = sprite.height;
			}
		} else {
			sprite.width = model.width;
			sprite.height = model.height;
		}
	}
}