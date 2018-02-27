package gasm.openfl.systems;
import openfl.Lib;
import gasm.core.math.geom.Point;
import openfl.events.Event;
import gasm.core.components.SpriteModelComponent;
import gasm.core.Entity;
import gasm.core.ISystem;
import openfl.display.DisplayObjectContainer;
import gasm.core.Component;
import gasm.core.enums.ComponentType;
import gasm.core.System;
import gasm.core.enums.SystemType;
import gasm.openfl.components.OFLSpriteComponent;
import gasm.openfl.components.OFLTextComponent;

/**
 * ...
 * @author Leo Bergman
 */
class OFLRenderingSystem extends System implements ISystem {
    public var root(default, null):DisplayObjectContainer;
    private var _stageSize:Point;

    public function new(root:DisplayObjectContainer) {
        super();
        this.root = root;
        _stageSize = {x:Lib.current.stage.stageWidth, y:Lib.current.stage.stageHeight};
        root.stage.addEventListener(Event.RESIZE, function(event:Event) {
            _stageSize.x = Lib.current.stage.stageWidth;
            _stageSize.y = Lib.current.stage.stageHeight;
        });
        type = SystemType.RENDERING;
        componentFlags.set(ComponentType.Graphics);
        componentFlags.set(ComponentType.Text);
    }

    public function update(comp:Component, delta:Float) {

        if (!comp.inited) {
            var model:SpriteModelComponent = comp.owner.get(SpriteModelComponent);
            if (comp.owner.parent != null) {
                var parent:OFLSpriteComponent = comp.owner.parent.get(OFLSpriteComponent);
                switch(comp.componentType) {
                    case Graphics:
                        var child = cast(comp, OFLSpriteComponent).sprite;
                        if (parent != null && parent != comp) {
                            parent.sprite.addChild(child);
                        } else {
                            root.addChild(child);
                        }
                        model.origWidth = child.width;
                        model.origHeight = child.height;
                    case Text:
                        var child = cast(comp, OFLTextComponent).textField;
                        if (parent != null && parent != comp) {
                            parent.sprite.addChild(child);
                        } else {
                            root.addChild(child);
                        }
                        model.origWidth = child.width;
                        model.origHeight = child.height;
                    default:
                }
            } else if(Std.is(comp, OFLSpriteComponent)){
                var spc:OFLSpriteComponent = cast comp;
                spc.root = true;
                model.origWidth = spc.sprite.width;
                model.origHeight = spc.sprite.height;
            }
            comp.init();
            comp.inited = true;
        }
        comp.update(delta);
    }
}