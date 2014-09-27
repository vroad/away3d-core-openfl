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
    
    public function new(glTexture:GLTexture, optimize:Bool = false, width : Int, height : Int) {
		optimizeForRenderToTexture = optimize;
        
        super (glTexture, width , height);
        uploadFromUInt8Array(null);
	}

	//public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		// TODO
	//}

    public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void {
#if html5
        var p = bitmapData.getPixels(new openfl.geom.Rectangle(0, 0, bitmapData.width, bitmapData.height));
        width = bitmapData.width;
        height = bitmapData.height;
        uploadFromUInt8Array(p.byteView);
#else
        var p = BitmapData.getRGBAPixels(bitmapData);
        uploadFromByteArray(p, 0);
#end
    }

    private function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int):Void {
#if html5
        var source = new UInt8Array(data.length);
        data.position = byteArrayOffset;
        var i:Int = 0;
        while (data.position < data.length) {
            source[i] = data.readUnsignedByte();
            i++;
        }
#else
        //TODO byteArrayOffset ?
        var source = new UInt8Array(data);
#end
        uploadFromUInt8Array(source);
    }
    
    private function uploadFromUInt8Array(data:UInt8Array)
    {
        GL.bindTexture (GL.TEXTURE_2D, glTexture);

        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST); 			
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);

        // mipLevel always should be 0 in rectangle textures
        GL.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data );
        GL.bindTexture (GL.TEXTURE_2D, null);   
    }
}
