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

        function getControlPoints() : Array;
        function getAnchorPoints() : Array;
        function getSegments() : Vector.<IMotionGuide>;

        // シェイプが持つ曲線の任意の1点を返す
        function getPoint(q : PointQuery) : Point;
        // シェイプに定義されているコントロールポイントを結ぶ直線上の任意の1点を返す
        function getPointOnControlPointsLocus(q : PointQuery) : Point;

    }
}
