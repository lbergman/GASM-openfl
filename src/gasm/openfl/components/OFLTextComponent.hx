package gasm.openfl.components;

import gasm.core.Component;
import gasm.core.components.TextModelComponent;
import gasm.core.data.TextConfig;
import gasm.core.enums.ComponentType;
import gasm.core.enums.EventType;
import gasm.openfl.text.ScalingTextField;
import openfl.events.Event;
import openfl.filters.GlowFilter;
import openfl.Lib;
import openfl.text.TextFormat;

/**
 * ...
 * @author Leo Bergman
 */
class OFLTextComponent extends Component {
    public var textField(default, null):ScalingTextField;
    var _format:Null<TextFormat>;
    var _text:String;
    var _selectable:Bool;
    var _config:TextConfig;
    var _model:TextModelComponent;
    var _lastW:Float;
    var _lastH:Float;
    var _stageSize:{x:Float, y:Float};

    public function new(config:TextConfig) {
        componentType = ComponentType.Text;
        textField = new ScalingTextField();
        if (config.backgroundColor != null) {
            textField.background = true;
            textField.backgroundColor = config.backgroundColor;
        }
        if(config.autoSize != null) {
            textField.autoSize = config.autoSize;
        }
        textField.width = config.width;
        textField.height = config.height;

        _format = new TextFormat(config.font, config.size, config.color);
        _format.align = config.align;
        _text = config.text != null ? config.text : '';
        config.scaleToFit = config.scaleToFit == null ? true : config.scaleToFit;
        _config = config;
        _selectable = config.selectable;
    }

    public function outline(color:UInt = 0x000000, alpha:Float = 1.0, blurX:Float = 4.0, blurY:Float = 4.0, strength:Float = 5.0, quality:Int = 1) {
        var glow = new GlowFilter(color, alpha, blurX, blurY, strength, quality);
        textField.filters.push(glow);
    }

    override public function init() {
        _model = owner.get(TextModelComponent);
        _model.font = _config.font;
        _model.size = _config.size;
        _model.color = _config.color;
        textField.selectable = _model.selectable = _selectable;
        textField.text = _model.text = _text;
        textField.defaultTextFormat = _format;
        if(_config.filters != null) {
            textField.filters = cast _config.filters;
        }
        if (textField.width > 0) {
            _model.width = textField.width;
            _model.height = textField.height;
        }
        _stageSize = {x:textField.parent.width, y:textField.parent.height};
        onResize();
        if(_config.scaleToFit){
            textField.scaleToFit();
        }
    }

    override public function update(delta:Float) {
        var textChanged = false;
        if (textField.text != _model.text) {
            textField.text = _model.text;
            textChanged = true;
        }
        var formatChanged = false;
        if (_config.font != _model.font) {
            _format.font = _config.font;
            formatChanged = true;
        }
        if (_format.size != _model.size) {
            _format.size = _model.size;
            formatChanged = true;
        }
        if (_format.color != _model.color) {
            _format.color = _model.color;
            formatChanged = true;
        }
        if (formatChanged) {
            textField.setTextFormat(_format);
        }
        textField.x = _model.x + _model.offsetX;
        textField.y = _model.y + _model.offsetY;
        _model.stageSize.x = Lib.current.stage.stageWidth;
        _model.stageSize.y = Lib.current.stage.stageHeight;
        if(_model.stageSize.x != _stageSize.x
        || _model.stageSize.y != _stageSize.y
        || _model.width != _lastW
        || _model.height != _lastH) {
            onResize();
        }
        if (textField.width != _lastW) {
            _model.width = textField.width;
        }
        if (textField.height != _lastH) {
            _model.height = textField.height;
        }
        _lastW = _model.width;
        _lastH = _model.height;
        textField.visible = _model.visible;
        if(textChanged || formatChanged) {
            if(_config.scaleToFit){
                textField.scaleToFit();
            }
        }
    }
    override public function dispose() {
        if(textField.parent != null) {
            textField.parent.removeChild(textField);
        }
    }

    function onResize(?event:Event) {
        _model.triggerEvent(EventType.RESIZE, { x:_model.stageSize.x, y:_model.stageSize.y}, owner);
    }
}