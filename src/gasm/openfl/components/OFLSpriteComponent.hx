package gasm.openfl.components;
import gasm.core.Component;
import gasm.core.components.SpriteModelComponent;
import gasm.core.enums.ComponentType;
import gasm.core.enums.InteractionType;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Leo Bergman
 */
class OFLSpriteComponent extends Component {
    public var sprite(default, default):DisplayObjectContainer;
    var _base:Bool;
    var _model:SpriteModelComponent;

    public function new(sprite:DisplayObject, mouseEnabled:Bool = false, base:Bool = true) {
        if (!Std.is(sprite, DisplayObjectContainer)) {
            this.sprite = new Sprite();
            this.sprite.addChild(sprite);
        } else {
            this.sprite = cast(sprite, DisplayObjectContainer);
        }
        this.sprite.mouseEnabled = mouseEnabled;
        componentType = ComponentType.Graphics;
        _base = base;
    }

    override public function init() {
        _model = owner.get(SpriteModelComponent);
        if (sprite.width > 0) {
            _model.width = sprite.width;
            _model.height = sprite.height;
        }
        var mask:DisplayObject = _model.mask;
        if (mask != null) {
            sprite.addChild(mask);
            sprite.mask = mask;
        }
        sprite.addEventListener(MouseEvent.CLICK, onClick);
        sprite.addEventListener(MouseEvent.MOUSE_OVER, onOver);
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    override public function update(dt:Float) {
        sprite.x = _model.x + _model.offsetX;
        sprite.y = _model.y + _model.offsetY;
        sprite.visible = _model.visible;
        if (_base) {
            if (sprite.width > 0) {
                _model.width = sprite.width;
                _model.height = sprite.height;
            }
        } else {
            sprite.width = _model.width;
            sprite.height = _model.height;
        }
    }

    override public function dispose() {
        sprite.mouseEnabled = false;
        sprite.removeChildren(0, sprite.numChildren);
        sprite.removeEventListener(MouseEvent.CLICK, onClick);
        sprite.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
        sprite.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    function onClick(event:MouseEvent) {
        _model.triggerEvent(InteractionType.PRESS, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onOver(event:MouseEvent) {
        _model.triggerEvent(InteractionType.OVER, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onMove(event:MouseEvent) {
        _model.triggerEvent(InteractionType.MOVE, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }
}