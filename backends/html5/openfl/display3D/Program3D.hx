/****
* 
****/

package openfl.display3D;

import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;

class Program3D 
{
   public var glProgram:GLProgram;

   /*#! Haxiomic Addition for performance improvements */
   public var glFCLocationMap:Array<GLUniformLocation>;
   public var glVCLocationMap:Array<GLUniformLocation>;
   public var glFSLocationMap:Array<GLUniformLocation>;//sampler
   public var glVALocationMap:Array<Int>;

    public function new(program:GLProgram) 
    {
        this.glProgram = program;
        this.glFCLocationMap = new Array<GLUniformLocation>();
        this.glVCLocationMap = new Array<GLUniformLocation>();
        this.glFSLocationMap = new Array<GLUniformLocation>();
        this.glVALocationMap = new Array<Int>();
    }

   public function dispose():Void 
   {
      GL.deleteProgram(glProgram);
   }

   // TODO: Use ByteArray instead of Shader?
    public function upload(vertexShader:GLShader, fragmentShader:GLShader):Void 
    {
      GL.attachShader(glProgram, vertexShader);
      GL.attachShader(glProgram, fragmentShader);
      GL.linkProgram(glProgram);

      if (GL.getProgramParameter(glProgram, GL.LINK_STATUS) == 0) 
      {
         var result = GL.getProgramInfoLog(glProgram);
         if (result != "") throw result;
      }
    }

    var yFlip:GLUniformLocation;
    var yFlipSet:Bool = false;
    public inline function yFlipLoc():GLUniformLocation{
      if(!yFlipSet){
        yFlip = GL.getUniformLocation(glProgram,"yflip");
        yFlipSet = true;
      }
      return yFlip;
    }

    public inline function fsUniformLocationFromAgal(i:Int):GLUniformLocation{
      /* This should be set when created, not each time location requested */
      if(i>=glFCLocationMap.length){
        glFCLocationMap[i] = GL.getUniformLocation(glProgram, "fc"+i);
      }
      return glFCLocationMap[i];
    }

    public inline function vsUniformLocationFromAgal(i:Int):GLUniformLocation{
      /* This should be set when created, not each time location requested */
      if(i>=glVCLocationMap.length){
        glVCLocationMap[i] = GL.getUniformLocation(glProgram, "vc"+i);
      }
      return glVCLocationMap[i];
    }

    //sampler
    public inline function fsampUniformLocationFromAgal(i:Int):GLUniformLocation{
      /* This should be set when created, not each time location requested */
      if(i>=glFSLocationMap.length){
        glFSLocationMap[i] = GL.getUniformLocation(glProgram, "fs"+i);
      }
      return glFSLocationMap[i];
    }

    public inline function vaUniformLocationFromAgal(i:Int):Int{
      /* This should be set when created, not each time location requested */
      if(i>=glVALocationMap.length){
        glVALocationMap[i] = GL.getAttribLocation(glProgram, "va"+i);
      }
      return glVALocationMap[i];
    }
}
