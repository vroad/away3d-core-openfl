package openfl.display3D;

import openfl.display.Stage;
import openfl.display.Stage3D;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.display3D.Context3D;
#if !flash
import openfl.display3D.AGLSLContext3D;
import openfl.display.OpenGLView;
#end

class OpenFLStage3D {   

    #if !flash
    static private var stage3Ds:Array<Stage3D> = []; 
    #end
    
    static public function getStage3D(stage : Stage, index : Int) : Stage3D{
        #if flash
        
        return stage.stage3Ds[index];
        
        #else
        
        if (stage3Ds.length > index) {
            return stage3Ds[index];
        } else {
            if (index > 0)
                throw "Only 1 Stage3D supported for now";

            var stage3D = new Stage3D();
            stage3Ds[index] = stage3D;
            return stage3D;
        }
        
        #end
    }

    /**
     * Common API for both cpp and flash to set the render callback
     **/
    inline static public function setRenderCallback(context3D : Context3D, func : Event -> Void) : Void{
        flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, func);
    }

    /**
     * Common API for both cpp and flash to remove the render callback
     **/
    inline static public function removeRenderCallback(context3D : Context3D, func : Event -> Void) : Void{
        flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, func);
    }
}
