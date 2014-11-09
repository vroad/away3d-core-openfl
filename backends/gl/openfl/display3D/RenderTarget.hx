package openfl.display3D;
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;

class RenderTarget
{

    public function new() 
    {
    }
    
    public function dispose()
    {
        GL.deleteFramebuffer(framebuffer);
        GL.deleteRenderbuffer(renderbuffer);
        //GL.deleteRenderbuffer(depthbuffer);
        //GL.deleteRenderbuffer(stencilbuffer);
    }
    
    public var framebuffer : GLFramebuffer;
	public var renderbuffer : GLRenderbuffer;
    //public var depthbuffer : GLRenderbuffer;
    //public var stencilbuffer : GLRenderbuffer;
}