package gasm.openfl.components;

import gasm.core.components.SoundModelComponent;
import openfl.events.Event;
import openfl.media.Sound;
import gasm.core.Component;
import gasm.core.enums.ComponentType;
import openfl.media.SoundChannel;

/**
 * ...
 * @author Leo Bergman
 */
class OFLSoundComponent extends Component
{
	public var sound(default, default):Sound;
	var _channel:Null<SoundChannel> = null;
	var _triggered:Bool;
	public function new(?sound:Sound) 
	{
		this.sound = sound;
		componentType = ComponentType.Sound;
	}
	
	override public function update(delta:Float):Void 
	{
		var model = owner.get(SoundModelComponent);
		if (model.playing)
		{
			if (_channel == null || !_triggered)
			{
				_channel = sound.play(model.pos);
				_triggered = true;
				_channel.addEventListener(Event.SOUND_COMPLETE, function(e:Event) { 
					model.playing = false;
					_triggered = false;
				});
			}
		}
		else
		{
			_triggered = false;
			if (_channel != null)
			{
				_channel.stop();
			}
		}
	}
}