package gasm.openfl;

import gasm.core.components.AppModelComponent;
import gasm.core.IEngine;
import gasm.core.ISystem;
import gasm.openfl.components.OFLSpriteComponent;
import gasm.openfl.systems.OFLCoreSystem;
import openfl.display.Sprite;
import openfl.events.Event;
import gasm.core.Context;
import gasm.core.Engine;
import gasm.core.Entity;
import gasm.openfl.systems.OFLRenderingSystem;
import gasm.openfl.systems.OFLSoundSystem;

/**
 * ...
 * @author Leo Bergman
 */
class OFLContext extends Sprite implements Context {
    public var baseEntity(get, null):Entity;
    public var systems(default, null):Array<ISystem>;
    public var appModel(default, null):AppModelComponent;

    var _engine:IEngine;

    public function new(?core:ISystem, ?renderer:ISystem, ?sound:ISystem, ?engine:IEngine) {
        super();
        core = core != null ? core : new OFLCoreSystem(this);
        renderer = renderer != null ? renderer : new OFLRenderingSystem(this);
        sound = sound != null ? sound : new OFLSoundSystem();
        systems = [core, renderer, sound];

        _engine = engine != null ? engine : new Engine(systems);
        appModel = new AppModelComponent();
        if (stage == null) {
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        } else {
            init();
        }
    }

    function onEnterFrame(e:Event):Void {
        _engine.tick();
    }

    function onAddedToStage(e:Event) {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        init();
    }

    function onResize(?e:Event) {
        appModel.stageSize.x = stage.stageWidth;
        appModel.stageSize.y = stage.stageHeight;
        appModel.resizeSignal.emit({width:appModel.stageSize.x, height:appModel.stageSize.y});
    }

    function init() {
        var comp = new OFLSpriteComponent(this, true);
        baseEntity.add(comp);
        baseEntity.add(appModel);
        onResize();
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(Event.RESIZE, onResize);
    }

    public function get_baseEntity():Entity {
        return _engine.baseEntity;
    }

}