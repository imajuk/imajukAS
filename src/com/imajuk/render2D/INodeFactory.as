package com.imajuk.render2D
{
    import com.imajuk.data.LinkList;

    import flash.display.BitmapData;
    import flash.geom.Matrix;
    
    /**
     * @author imajuk
     */
    public interface INodeFactory
    {
        function create(render2D : Render2D) : LinkList;

        function drawDebugResource(b : BitmapData, m : Matrix) : void;
    }
}
