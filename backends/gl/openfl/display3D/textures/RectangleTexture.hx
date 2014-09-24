/****
* 
****/

package openfl.display3D.textures;

import openfl.display.BitmapData;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.ByteArray;
import openfl.utils.UInt8Array;

class RectangleTexture extends TextureBase 
{
    public var optimizeForRenderToTexture:Bool;
    
    public function new(glTexture:GLTexture, optimize:Bool, width : Int, height : Int) {
		optimizeForRenderToTexture = optimize;
        if (optimizeForRenderToTexture==null) optimizeForRenderToTexture = false;
        
        super (glTexture, width , height);
	}

	//public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		// TODO
	//}

    public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void {
        var p = bitmapData.getPixels(new openfl.geom.Rectangle(0, 0, bitmapData.width, bitmapData.height));
        width = bitmapData.width;
        height = bitmapData.height;
        uploadFromUInt8Array(p.byteView);
    }

    public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int):Void {
        var source = new UInt8Array(data.length);
        data.position = byteArrayOffset;
        var i:Int = 0;
        while (data.position < data.length) {
            source[i] = data.readUnsignedByte();
            i++;
        }

        uploadFromUInt8Array(source);
    }
    
    public function uploadFromUInt8Array(data:UInt8Array)
    {
        GL.bindTexture (GL.TEXTURE_2D, glTexture);

        if (optimizeForRenderToTexture)
            GL.pixelStorei(GL.UNPACK_FLIP_Y_WEBGL, 1); 
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST); 			
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);

        // mipLevel always should be 0 in rectangle textures
        GL.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data );
        GL.bindTexture (GL.TEXTURE_2D, null);   
    }
}
