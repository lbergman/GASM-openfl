package gasm.openfl.text;

import openfl.text.TextField;

class ScalingTextField extends TextField {
    public function new() {
        super();
    }

    public inline function scaleToFit() {
        while(textWidth > width) {
            var fmt = getTextFormat();
            fmt.size--;
            setTextFormat(fmt);
        }
    }
}
