package openfl.display;

import openfl.display3D.Context3D;
import openfl.display3D.AGLSLContext3D;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.display.OpenGLView;
import openfl.geom.Rectangle;

class Stage3D extends EventDispatcher 
{
   public var context3D:Context3D;
   public var visible:Bool; // TODO
   public var x(default, set):Float;
   public var y(default, set):Float;
   
   private var ogl:OpenGLView;

   public function new() {
      super();
   }

   public function requestContext3D(context3DRenderMode:String = "") {
      if (OpenGLView.isSupported) {
          ogl = new OpenGLView();
          ogl.x = x;
          ogl.y = y;
          context3D = new Context3D(ogl);
          dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
      } else {
          dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
   }

    public function requestAGLSLContext3D(?context3DRenderMode:String =  "auto"):Void 
    {
        #if !flash

        if (OpenGLView.isSupported) {
            ogl = new OpenGLView();
            ogl.x = x;
            ogl.y = y;
            context3D = new AGLSLContext3D(ogl);   
            dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
        } else
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));  

        #else

        requestContext3D(context3DRenderMode);

        #end
    }
   
    public function set_x(x:Float)
    {
        this.x = x;
        if (ogl != null)
            ogl.x = this.x;
        return this.x;
    }

    public function set_y(y:Float)
    {
        this.y = y;
        if (ogl != null)
            ogl.y = this.y;
        return this.y;
    }
}
