package com.imajuk.ropes.shapes
{
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.PointQuery;
    import flash.geom.Point;


    /**
     * @author imajuk
     */
    public interface IRopeShape
    {
        //全体の長さ
        function get length() : Number;
        function get isInitialized() : Boolean;
        function get closed() : Boolean;
        function set closed(value : Boolean) : void;
        
        // t時間めの位置を返す
        function getPoint(q : PointQuery) : Point;

        // 形を変える
//        function change(type : int) : void;

        function getControlPoints() : Array;
        function getAnchorPoints() : Array;
        function getSegments() : Vector.<IMotionGuide>;

    }
}
