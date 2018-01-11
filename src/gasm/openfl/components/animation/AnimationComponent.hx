package gasm.openfl.components.animation;

import mapsheet.Animation;
import gasm.core.utils.texture.ParseResult;
import gasm.core.utils.texture.TextureData;
import gasm.core.utils.texture.TexturePackerImport;
import haxe.Json;
import mapsheet.data.Behavior;
import mapsheet.Mapsheet;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.utils.Assets;

class AnimationComponent extends OFLSpriteComponent {

    var _spritePath:String;
    var _dataPath:String;
    var _behaviors:Array<Behavior>;
    var _animation:Animation;
    var _smoothing:Bool;

    public function new(spritePath:String, dataPath:String, ?behaviors:Array<Behavior>, smoothing:Bool = true) {
        super(new Sprite());
        _spritePath = spritePath;
        _dataPath = dataPath;
        _behaviors = behaviors;
        _smoothing = smoothing;
    }

    override public function init() {
        var textureData:TextureData = Json.parse(Assets.getText('sheets/$suit.json'));
        var textureSheet:BitmapData = Assets.getBitmapData('sheets/$suit.png');
        var tiledata:ParseResult = TexturePackerImport.parse(textureData);
        var mapsheet = new Mapsheet(textureSheet);
        if(_behaviors == null) {
            _behaviors = [];
        }
        var index = 0;
        for(frame in tiledata.frames) {
            mapsheet.addFrame(frame.x, frame.y, frame.width, frame.height, frame.offsetX, frame.offsetY);
            if(_behaviors == null) {
                _behaviors.push(new Behavior('behavior$index', [index], false, 0));
            }
            index++;
        }

        for(behavior in _behaviors) {
            mapsheet.addBehavior(behavior);
        }
        _animation = new Animation(mapsheet, _smoothing);
    }

    override public function update(dt:Float) {
        _animation.update(dt);
    }

    public function playAnimation(behavior:String, restart:Bool = true) {
        _animation.showBehavior(behavior, restart);
    }
}
