package gasm.openfl;

import buddy.BuddySuite;
import gasm.core.Entity;
import gasm.core.System;
import gasm.core.Component;
import gasm.core.IEngine;
import gasm.core.ISystem;
import gasm.core.enums.SystemType;
import gasm.openfl.OFLContext;

using buddy.Should;


/**
 * ...
 * @author ...
 */
class OFLContextTest extends BuddySuite
{

	public function new() 
	{
		describe("OFLContext", {
			describe("constructor", {
				it("should add systems passed", {
					var core = new MockCoreSystem();
					var rendering = new MockRenderingSystem();
					var sound = new MockSoundSystem();
					var engine = new MockEngine();
					var ctx = new OFLContext(core, rendering, sound, engine);
					ctx.systems[0].should.be(rendering);
					ctx.systems[1].should.be(rendering);
					ctx.systems[2].should.be(rendering);
				});
			});
		});
	}
	
}


class MockCoreSystem extends System implements ISystem {
	public function new() {
		super();
		type = SystemType.CORE;
	}
	public function update(comp:Component, delta:Float):Void {
		
	}
}

class MockRenderingSystem extends System implements ISystem  {
	public function new() {
		super();
		type = SystemType.RENDERING;
	}
	public function update(comp:Component, delta:Float):Void {
		
	}
}

class MockSoundSystem extends System implements ISystem  {
	public function new() {
		super();
		type = SystemType.SOUND;
	}
	public function update(comp:Component, delta:Float):Void {
		
	}
}

class MockEngine implements IEngine {
	public function new() {
	}
	public var baseEntity(default, null):Entity;
	public function tick():Void {};
}