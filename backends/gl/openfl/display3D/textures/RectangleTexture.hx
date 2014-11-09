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

    public function uploadFromBitmapData (bitmapData:BitmapData):Void {
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
        uploadFromByteArray(p, 0);
    }

    private function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int):Void {
#if js
        var source = data.byteView;
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
