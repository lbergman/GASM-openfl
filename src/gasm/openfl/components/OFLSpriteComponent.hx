package gasm.openfl.components;

import openfl.Lib;
import gasm.core.events.api.IEvent;
import gasm.core.enums.EventType;
import gasm.core.Component;
import gasm.core.components.SpriteModelComponent;
import gasm.core.enums.ComponentType;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.Event;

/**
 * ...
 * @author Leo Bergman
 */
class OFLSpriteComponent extends Component {
    public var sprite(default, default):DisplayObjectContainer;
    public var mouseEnabled(default, set):Bool;
    public var root(default, default):Bool;
    public var roundPixels(default, default):Bool;

    var _model:SpriteModelComponent;
    var _mouseDown = false;
    var _lastW:Float;
    var _lastH:Float;
    var _stageSize:{x:Float, y:Float};
    var _inited = false;

    public function new(sprite:DisplayObject, mouseEnabled:Bool = false, roundPixels:Bool = false) {
        if (!Std.is(sprite, DisplayObjectContainer)) {
            this.sprite = new Sprite();
            this.sprite.addChild(sprite);
        } else {
            this.sprite = cast(sprite, DisplayObjectContainer);
        }
        this.sprite.mouseEnabled = mouseEnabled;
        this.roundPixels = roundPixels;
        componentType = ComponentType.Graphics;
    }

    override public function setup() {
        sprite.name = owner.id;
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
        if (this.sprite.mouseEnabled) {
            addEventListeners();
        }
        _stageSize = {x:Lib.current.stage.stageWidth, y:Lib.current.stage.stageHeight};

        onResize();
    }

    override public function update(dt:Float) {
        sprite.x = _model.x + _model.offsetX;
        sprite.y = _model.y + _model.offsetY;

        _model.stageSize.x = Lib.current.stage.stageWidth;
        _model.stageSize.y = Lib.current.stage.stageHeight;

        if (sprite.width != _lastW) {
            _model.width = sprite.width;
        }
        if (sprite.height != _lastH) {
            _model.height = sprite.height;
        }
        if (_model.width != _lastW) {
            sprite.width = _model.width;
        }
        if (_model.height != _lastH) {
            sprite.height = _model.height;
        }
        if(_model.xScale != sprite.scaleX) {
            sprite.scaleX = _model.xScale;
        }
        if(_model.yScale != sprite.scaleY) {
            sprite.scaleY = _model.yScale;
        }

        if(roundPixels) {
            _model.x = Math.round(_model.x);
            _model.y = Math.round(_model.y);
            _model.width = Math.round(_model.width);
            _model.height = Math.round(_model.height);
            _model.stageSize.x = Math.round(_model.stageSize.x);
            _model.stageSize.y = Math.round(_model.stageSize.y);
        }

        if(_model.stageSize.x != _stageSize.x
        || _model.stageSize.y != _stageSize.y
        || _model.width != _lastW
        || _model.height != _lastH) {
            onResize();
        }

        _stageSize.x = _model.stageSize.x;
        _stageSize.y = _model.stageSize.y;
        _lastW = _model.width;
        _lastH = _model.height;
        sprite.visible = _model.visible;
    }

    override public function dispose() {
        if(sprite.parent != null) {
            sprite.parent.removeChild(sprite);
        }
        sprite.removeChildren(0, sprite.numChildren);
        removeEventListeners();
    }

    function onClick(event:MouseEvent) {
        _model.triggerEvent(EventType.PRESS, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onDown(event:MouseEvent) {
        _model.triggerEvent(EventType.DOWN, { x:sprite.mouseX, y:sprite.mouseY }, owner);
        startDrag();
    }

    function onUp(event:MouseEvent) {
        _model.triggerEvent(EventType.UP, { x:sprite.mouseX, y:sprite.mouseY }, owner);
        stopDrag();
    }

    function onStageUp(event:IEvent) {
        stopDrag();
    }

    function onOver(event:MouseEvent) {
        _model.triggerEvent(EventType.OVER, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onOut(event:MouseEvent) {
        _model.triggerEvent(EventType.OUT, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onMove(event:MouseEvent) {
        _model.triggerEvent(EventType.MOVE, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onDrag(event:IEvent) {
        _model.triggerEvent(EventType.DRAG, { x:sprite.mouseX, y:sprite.mouseY }, owner);
    }

    function onResize(?event:Event) {
        _model.triggerEvent(EventType.RESIZE, { x:_model.stageSize.x, y:_model.stageSize.y}, owner);
    }

    function stopDrag() {
        _model.removeHandler(EventType.MOVE, onDrag);
    }

    function startDrag() {
        _model.addHandler(EventType.MOVE, onDrag);
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
        rootSmc.addHandler(EventType.UP, onStageUp);
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
        rootSmc.removeHandler(EventType.UP, onStageUp);
        _model.removeHandler(EventType.MOVE, onDrag);
    }

    function set_mouseEnabled(val:Bool):Bool {
        sprite.mouseEnabled = val;
        if (val) {
            addEventListeners();
        } else {
            removeEventListeners();
        }
        return val;
    }
}