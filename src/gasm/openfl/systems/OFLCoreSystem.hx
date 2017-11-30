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
/**
 * ...
 * @author Leo Bergman
 */
class OFLCoreSystem extends System implements ISystem {

    public var root(default, null):DisplayObjectContainer;

    public function new(root:DisplayObjectContainer) {
        super();
        this.root = root;
        type = SystemType.CORE;
        componentFlags.set(GraphicsModel);
    }

    public function update(comp:Component, delta:Float) {
        if (!comp.inited) {
            comp.init();
            comp.inited = true;
        }
        comp.update(delta);
        if (Std.is(comp, SpriteModelComponent)) {
            var model:SpriteModelComponent = cast comp;
            model.stageMouseX = root.stage.mouseX;
            model.stageMouseY = root.stage.mouseY;
            var spriteComponent = model.owner.get(OFLSpriteComponent);
            if (spriteComponent != null) {
                var sp = spriteComponent.sprite;
                model.mouseX = sp.mouseX;
                model.mouseY = sp.mouseY;
            }
        }
    }
}