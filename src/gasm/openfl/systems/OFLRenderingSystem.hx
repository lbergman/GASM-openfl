package gasm.openfl.systems;
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
        _stageSize = {x:0, y:0};
        root.stage.addEventListener(Event.RESIZE, function(event:Event) {
            _stageSize.x = root.stage.stageWidth;
            _stageSize.y = root.stage.stageHeight;
        });
        type = SystemType.RENDERING;
        componentFlags.set(ComponentType.Graphics);
        componentFlags.set(ComponentType.Text);
    }

    public function update(comp:Component, delta:Float) {
        if (!comp.inited) {
            if (comp.owner.parent != null) {
                var parent:OFLSpriteComponent = comp.owner.parent.get(OFLSpriteComponent);
                switch(comp.componentType) {
                    case Graphics:
                        if (parent != null && parent != comp) {
                            var child = cast(comp, OFLSpriteComponent).sprite;
                            parent.sprite.addChild(child);
                        }
                        else {
                            root.addChild(cast(comp, OFLSpriteComponent).sprite);
                        }
                    case Text:
                        if (parent != null && parent != comp) {
                            parent.sprite.addChild(cast(comp, OFLTextComponent).textField);
                        }
                        else {
                            root.addChild(cast(comp, OFLTextComponent).textField);
                        }
                    default:
                }
            } else if(Std.is(comp, OFLSpriteComponent)){
                var spc:OFLSpriteComponent = cast comp;
                spc.root = true;
            }
            comp.init();
            comp.inited = true;
        }
        comp.update(delta);
        if(Std.is(comp, OFLSpriteComponent)) {
            var smc:SpriteModelComponent = comp.owner.get(SpriteModelComponent);
            smc.stageSize = _stageSize;
        }
    }
}