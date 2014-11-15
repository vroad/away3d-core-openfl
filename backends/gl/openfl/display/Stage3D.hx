package openfl.display;

import openfl.display3D.Context3D;
import openfl.display3D.AGLSLContext3D;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.geom.Rectangle;

class Stage3D extends EventDispatcher 
{
    public var context3D:Context3D;
    public var visible:Bool; // TODO
    public var x(default, set):Float; // TODO
    public var y(default, set):Float; // TODO

    public function new() {
        super();
    }

    public function requestContext3D(context3DRenderMode:String = "") {
        context3D = new Context3D();
        dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
    }

    public function requestAGLSLContext3D(?context3DRenderMode:String =  "auto"):Void 
    {
        #if !flash
        
        context3D = new AGLSLContext3D();   
        dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
        
        #else

        requestContext3D(context3DRenderMode);

        #end
    }
   
    public function set_x(x:Float)
    {
        this.x = x;
        return this.x;
    }

    public function set_y(y:Float)
    {
        this.y = y;
        return this.y;
    }
}
