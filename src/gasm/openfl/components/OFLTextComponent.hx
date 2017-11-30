package gasm.openfl.components;
import openfl.Assets;
import openfl.filters.GlowFilter;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import gasm.core.Component;
import gasm.core.components.TextModelComponent;
import gasm.core.enums.ComponentType;

/**
 * ...
 * @author Leo Bergman
 */
class OFLTextComponent extends Component {
    public var textField(default, null):TextField;
    var _font:Null<Font>;
    var _format:Null<TextFormat>;
    var _fontId:Null<String>;

    public function new(font:Font) {
        componentType = ComponentType.Text;
        textField = new TextField();
        _font = font;
    }

    public function outline(color:UInt = 0x000000, alpha:Float = 1.0, blurX:Float = 4.0, blurY:Float = 4.0, strength:Float = 5.0, quality:Int = 1) {
        var glow = new GlowFilter(color, alpha, blurX, blurY, strength, quality);
        textField.filters = [glow];
    }

    override public function init() {
        var model = owner.get(TextModelComponent);
        model.font = _font.fontName;
        _format = new TextFormat(model.font, model.size, model.color);
        textField.defaultTextFormat = _format;
        textField.selectable = model.selectable;
        textField.text = model.text;
    }

    override public function update(delta:Float) {
        var model = owner.get(TextModelComponent);
        if (textField.text != model.text) {
            textField.text = model.text;
        }
        var formatChanged = false;
        if (_fontId != model.font) {
            _font = Assets.getFont(model.font);
            _format.font = _font.fontName;
            _fontId = model.font;
            formatChanged = true;
        }
        if (_format.size != model.size) {
            _format.size = model.size;
            formatChanged = true;
        }
        if (_format.color != model.color) {
            _format.color = model.color;
            formatChanged = true;
        }
        if (formatChanged) {
            textField.setTextFormat(_format);
        }
    }
}