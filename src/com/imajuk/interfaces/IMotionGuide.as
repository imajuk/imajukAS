package com.imajuk.interfaces
{
    import flash.geom.Point;
    /**
     * 0~1(始点〜終点)の値から2次元座標を返すインターフェイス.
     * 
     * @author imajuk
     */
    public interface IMotionGuide
    {
    	function getValue(time : Number) : Point;
    }
}
