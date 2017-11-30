package gasm.openfl.systems;
import gasm.core.components.SpriteModelComponent;
import gasm.core.ISystem;
import openfl.display.DisplayObject;
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

    public function new(root:DisplayObjectContainer) {
        super();
        this.root = root;
        type = SystemType.RENDERING;
        componentFlags.set(ComponentType.Graphics);
        componentFlags.set(ComponentType.Text);
    }

    public function update(comp:Component, delta:Float) {
        if (!comp.inited) {
            if (comp.owner.parent != null) {
                switch(comp.componentType) {
                    case Graphics:
                        var parent = comp.owner.parent.get(OFLSpriteComponent);
                        if (parent != null && parent != comp) {
                            parent.sprite.addChild(cast(comp, OFLSpriteComponent).sprite);
                        }
                        else {
                            root.addChild(cast(comp, OFLSpriteComponent).sprite);
                        }
                    case Text:
                        var parent = comp.owner.parent.get(OFLSpriteComponent);
                        if (parent != null && parent != comp) {
                            parent.sprite.addChild(cast(comp, OFLTextComponent).textField);
                        }
                        else {
                            root.addChild(cast(comp, OFLTextComponent).textField);
                        }
                    default:
                }
            }
            comp.init();
            comp.inited = true;
        }
        comp.update(delta);
    }
}