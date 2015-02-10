/**
 * A Plane primitive mesh.
 */
package away3d.primitives;


import away3d.core.base.CompactSubGeometry;
import away3d.utils.ArrayUtils;
import openfl.Vector;

class PlaneGeometry extends PrimitiveBase {
    public var segmentsW(get_segmentsW, set_segmentsW):Int;
    public var segmentsH(get_segmentsH, set_segmentsH):Int;
    public var yUp(get_yUp, set_yUp):Bool;
    public var doubleSided(get_doubleSided, set_doubleSided):Bool;
    public var width(get_width, set_width):Float;
    public var height(get_height, set_height):Float;

    private var _segmentsW:Int;
    private var _segmentsH:Int;
    private var _yUp:Bool;
    private var _width:Float;
    private var _height:Float;
    private var _doubleSided:Bool;
    /**
	 * Creates a new Plane object.
	 * @param width The width of the plane.
	 * @param height The height of the plane.
	 * @param segmentsW The number of segments that make up the plane along the X-axis.
	 * @param segmentsH The number of segments that make up the plane along the Y or Z-axis.
	 * @param yUp Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false).
	 * @param doubleSided Defines whether the plane will be visible from both sides, with correct vertex normals.
	 */
    public function new(width:Float = 100, height:Float = 100, segmentsW:Int = 1, segmentsH:Int = 1, yUp:Bool = true, doubleSided:Bool = false) {
        super();
        _segmentsW = segmentsW;
        _segmentsH = segmentsH;
        _yUp = yUp;
        _width = width;
        _height = height;
        _doubleSided = doubleSided;
    }

    /**
	 * The number of segments that make up the plane along the X-axis. Defaults to 1.
	 */
    public function get_segmentsW():Int {
        return _segmentsW;
    }

    public function set_segmentsW(value:Int):Int {
        _segmentsW = value;
        invalidateGeometry();
        invalidateUVs();
        return value;
    }

    /**
	 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
	 * false, respectively. Defaults to 1.
	 */
    public function get_segmentsH():Int {
        return _segmentsH;
    }

    public function set_segmentsH(value:Int):Int {
        _segmentsH = value;
        invalidateGeometry();
        invalidateUVs();
        return value;
    }

    /**
	 *  Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false). Defaults to true.
	 */
    public function get_yUp():Bool {
        return _yUp;
    }

    public function set_yUp(value:Bool):Bool {
        _yUp = value;
        invalidateGeometry();
        return value;
    }

    /**
	 * Defines whether the plane will be visible from both sides, with correct vertex normals (as opposed to bothSides on Material). Defaults to false.
	 */
    public function get_doubleSided():Bool {
        return _doubleSided;
    }

    public function set_doubleSided(value:Bool):Bool {
        _doubleSided = value;
        invalidateGeometry();
        return value;
    }

    /**
	 * The width of the plane.
	 */
    public function get_width():Float {
        return _width;
    }

    public function set_width(value:Float):Float {
        _width = value;
        invalidateGeometry();
        return value;
    }

    /**
	 * The height of the plane.
	 */
    public function get_height():Float {
        return _height;
    }

    public function set_height(value:Float):Float {
        _height = value;
        invalidateGeometry();
        return value;
    }

    /**
	 * @inheritDoc
	 */
    override private function buildGeometry(target:CompactSubGeometry):Void {
        var data:Vector<Float>;
        var indices:Vector<UInt>;
        var x:Float;
        var y:Float;
        var numIndices:Int;
        var base:Int;
        var tw:Int = _segmentsW + 1;
        var numVertices:Int = (_segmentsH + 1) * tw;
        var stride:Int = target.vertexStride;
        var skip:Int = stride - 9;
        if (_doubleSided) numVertices *= 2;
        numIndices = _segmentsH * _segmentsW * 6;
        if (_doubleSided) numIndices <<= 1;
        if (numVertices == target.numVertices) {
            data = target.vertexData;
            indices = target.indexData ;
            if (indices == null) {
                indices = ArrayUtils.Prefill( new Vector<UInt>(), numIndices, 0 );
            }
        }

        else {
            data = ArrayUtils.Prefill( new Vector<Float>(), numVertices * stride, 0 );
            indices = ArrayUtils.Prefill( new Vector<UInt>(), numIndices, 0 );
            invalidateUVs();
        }

        numIndices = 0;
        var index:Int = target.vertexOffset;
        var yi:Int = 0;
        while (yi <= _segmentsH) {
            var xi:Int = 0;
            while (xi <= _segmentsW) {
                x = (xi / _segmentsW - .5) * _width;
                y = (yi / _segmentsH - .5) * _height;
                data[index++] = x;
                if (_yUp) {
                    data[index++] = 0;
                    data[index++] = y;
                }

                else {
                    data[index++] = y;
                    data[index++] = 0;
                }

                data[index++] = 0;
                if (_yUp) {
                    data[index++] = 1;
                    data[index++] = 0;
                }

                else {
                    data[index++] = 0;
                    data[index++] = -1;
                }

                data[index++] = 1;
                data[index++] = 0;
                data[index++] = 0;
                index += skip;
                
                // add vertex with same position, but with inverted normal & tangent
                if (_doubleSided) {
                    var i:Int = 0;
                    while (i < 3) {
                        data[index] = data[index - stride];
                        ++index;
                        ++i;
                    }
                    i = 0;
                    while (i < 3) {
                        data[index] = -data[index - stride];
                        ++index;
                        ++i;
                    }
                    i = 0;
                    while (i < 3) {
                        data[index] = -data[index - stride];
                        ++index;
                        ++i;
                    }
                    index += skip;
                }
                if (xi != _segmentsW && yi != _segmentsH) {
                    base = xi + yi * tw;
                    var mult:Int = (_doubleSided) ? 2 : 1;
                    indices[numIndices++] = base * mult;
                    indices[numIndices++] = (base + tw) * mult;
                    indices[numIndices++] = (base + tw + 1) * mult;
                    indices[numIndices++] = base * mult;
                    indices[numIndices++] = (base + tw + 1) * mult;
                    indices[numIndices++] = (base + 1) * mult;
                    if (_doubleSided) {
                        indices[numIndices++] = (base + tw + 1) * mult + 1;
                        indices[numIndices++] = (base + tw) * mult + 1;
                        indices[numIndices++] = base * mult + 1;
                        indices[numIndices++] = (base + 1) * mult + 1;
                        indices[numIndices++] = (base + tw + 1) * mult + 1;
                        indices[numIndices++] = base * mult + 1;
                    }
                }
                ++xi;
            }
            ++yi;
        }
        target.updateData(data);
        target.updateIndexData(indices);
    }

    /**
	 * @inheritDoc
	 */
    override private function buildUVs(target:CompactSubGeometry):Void {
        var data:Vector<Float>;
        var stride:Int = target.UVStride;
        var numUvs:Int = (_segmentsH + 1) * (_segmentsW + 1) * stride;
        var skip:Int = stride - 2;
        if (_doubleSided) numUvs *= 2;
        if (target.UVData != null && numUvs == target.UVData.length) 
            data = target.UVData
        else {
            data = ArrayUtils.Prefill( new Vector<Float>(), numUvs, 0);
            invalidateGeometry();
        }

        var index:Int = target.UVOffset;
        var yi:Int = 0;
        while (yi <= _segmentsH) {
            var xi:Int = 0;
            while (xi <= _segmentsW) {
                data[index++] = (xi / _segmentsW) * target.scaleU;
                data[index++] = (1 - yi / _segmentsH) * target.scaleV;
                index += skip;
                if (_doubleSided) {
                    data[index++] = (xi / _segmentsW) * target.scaleU;
                    data[index++] = (1 - yi / _segmentsH) * target.scaleV;
                    index += skip;
                }
                ++xi;
            }
            ++yi;
        }
        target.updateData(data);
    }
}

