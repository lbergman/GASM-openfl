package gasm.openfl.components;
import flash.text.TextFormatAlign;
import flash.text.TextFieldAutoSize;
import gasm.core.enums.EventType;
import openfl.events.Event;
import openfl.Lib;
import gasm.core.data.TextConfig;
import gasm.core.Component;
import gasm.core.components.TextModelComponent;
import gasm.core.enums.ComponentType;
import openfl.filters.GlowFilter;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Leo Bergman
 */
class OFLTextComponent extends Component {
    public var textField(default, null):TextField;
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
        textField = new TextField();
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
    }

    override public function update(delta:Float) {
        if (textField.text != _model.text) {
            textField.text = _model.text;
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