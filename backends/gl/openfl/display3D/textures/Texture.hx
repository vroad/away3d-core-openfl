/****
* 
****/

package openfl.display3D.textures;

import openfl.display.BitmapData;
import openfl.gl.GL;
import openfl.gl.GLTexture;
import openfl.utils.ByteArray;
import openfl.utils.UInt8Array;

class Texture extends TextureBase 
{
    public var optimizeForRenderToTexture:Bool;
    
    public function new(glTexture:GLTexture, optimize:Bool = false, width : Int, height : Int) {
		optimizeForRenderToTexture = optimize;
        
        super (glTexture, width , height);
        uploadFromUInt8Array(null, 0);
	}

	public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:Int, async:Bool = false):Void {
		// TODO
	}

    public function uploadFromBitmapData (bitmapData:BitmapData, miplevel:Int = 0):Void {
        width = bitmapData.width;
        height = bitmapData.height;
        var p = bitmapData.getPixels(new openfl.geom.Rectangle(0, 0, bitmapData.width, bitmapData.height));
#if !html5
        var p2 = new ByteArray(p.length);
        var bytesPerLine:Int = bitmapData.width * 4;
        var dstPosition:Int = (bitmapData.height - 1) * bytesPerLine;
        
        for(i in 0 ... bitmapData.height)
        {
            p.readBytes(p2, dstPosition, bytesPerLine);
            dstPosition -= bytesPerLine;
        }
        p = p2;
#end
        uploadFromByteArray(p, 0, miplevel);
    }

    private function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, mipLevel:Int):Void {
#if js
        var source = data.byteView;
#else
        //TODO byteArrayOffset ?
        var source = new UInt8Array(data);
#end
        uploadFromUInt8Array(source, mipLevel);
    }
    
    private function uploadFromUInt8Array(data:UInt8Array, mipLevel:Int)
    {
        GL.bindTexture (GL.TEXTURE_2D, glTexture);

        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST); 			
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);

        GL.texImage2D( GL.TEXTURE_2D, mipLevel, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data );
        GL.bindTexture (GL.TEXTURE_2D, null);
    }
}
