package gasm.openfl.components;

import gasm.core.events.InteractionEvent;
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
    public var mouseEnabled(default, set):Bool;
    var _model:SpriteModelComponent;
    var _mouseDown = false;
    var _lastW:Float;
    var _lastH:Float;

    public function new(sprite:DisplayObject, mouseEnabled:Bool = false) {
        if (!Std.is(sprite, DisplayObjectContainer)) {
            this.sprite = new Sprite();
            this.sprite.addChild(sprite);
        } else {
            this.sprite = cast(sprite, DisplayObjectContainer);
        }
        this.sprite.mouseEnabled = mouseEnabled;
        componentType = ComponentType.Graphics;
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
        if(this.sprite.mouseEnabled) {
            addEventListeners();
        }
    }

    override public function update(dt:Float) {
        sprite.x = _model.x + _model.offsetX;
        sprite.y = _model.y + _model.offsetY;
        sprite.visible = _model.visible;
        if(sprite.width != _lastW) {
            _model.width = sprite.width;
        }
        if(sprite.height != _lastH) {
            _model.height = sprite.height;
        }
        if(_model.width != _lastW) {
            sprite.width = _model.width;
        }
        if(_model.height != _lastH) {
            sprite.height = _model.height;
        }
        _lastW = _model.width;
        _lastH = _model.height;
    }

    override public function dispose() {
        sprite.mouseEnabled = false;
        removeEventListeners();
       // sprite.stage.root.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
    }

    function onClick(event:MouseEvent) {
        _model.triggerEvent(InteractionType.PRESS, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onDown(event:MouseEvent) {
        _model.triggerEvent(InteractionType.DOWN, { x:sprite.mouseX, y:sprite.mouseY }, owner);
        startDrag();
    }

    function onUp(event:MouseEvent) {
        _model.triggerEvent(InteractionType.UP, { x:sprite.mouseX, y:sprite.mouseY }, owner);
        stopDrag();
    }

    function onStageUp(event:InteractionEvent) {
        trace("event.entity.id:" + event.entity.id);
        trace("owner.id:" + owner.id);
        stopDrag();
    }

    function onOver(event:MouseEvent) {
        _model.triggerEvent(InteractionType.OVER, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onOut(event:MouseEvent) {
        _model.triggerEvent(InteractionType.OUT, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onMove(event:MouseEvent) {
        _model.triggerEvent(InteractionType.MOVE, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onDrag(event:InteractionEvent) {
        _model.triggerEvent(InteractionType.DRAG, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function stopDrag() {
        _model.removeHandler(InteractionType.MOVE, onDrag);
    }

    function startDrag() {
        _model.addHandler(InteractionType.MOVE, onDrag);
    }

    function addEventListeners() {
        sprite.addEventListener(MouseEvent.CLICK, onClick);
        sprite.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        sprite.addEventListener(MouseEvent.MOUSE_UP, onUp);
        sprite.addEventListener(MouseEvent.RELEASE_OUTSIDE, onUp);
        sprite.addEventListener(MouseEvent.MOUSE_OVER, onOver);
        sprite.addEventListener(MouseEvent.MOUSE_OUT, onOut);
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        var rootSmc:SpriteModelComponent = owner.getFromRoot(SpriteModelComponent);
        rootSmc.addHandler(InteractionType.UP, onStageUp);
        //  sprite.stage.root.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
    }

    function removeEventListeners() {
        sprite.removeChildren(0, sprite.numChildren);
        sprite.removeEventListener(MouseEvent.CLICK, onClick);
        sprite.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
        sprite.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        sprite.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onUp);
        sprite.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
        sprite.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
        sprite.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        var rootSmc:SpriteModelComponent = owner.getFromRoot(SpriteModelComponent);
        rootSmc.removeHandler(InteractionType.UP, onStageUp);
        trace("rootSmc.owner.id:" + rootSmc.owner.id);
    }

    function set_mouseEnabled(val:Bool):Bool {
        sprite.mouseEnabled = val;
        if(val) {
            addEventListeners();
        } else {
            removeEventListeners();
        }
        return val;
    }
}