package com.imajuk.ropes.shapes
{
    import com.imajuk.interfaces.IMotionGuide;
    import com.imajuk.ropes.models.PointAnimateInfo;
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
        function get amount() : int;
        function set amount(value : int) : void;

        function getControlPoints() : Array;
        function getAnchorPoints() : Array;
        function getSegments() : Vector.<IMotionGuide>;

        // シェイプが持つ曲線の任意の1点を返す
        function getPoint(q : PointAnimateInfo) : Point;
        // シェイプに定義されているコントロールポイントを結ぶ直線上の任意の1点を返す
        function getPointOnControlPointsLocus(q : PointAnimateInfo) : Point;

    }
}
