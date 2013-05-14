package com.imajuk.render2D
{
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    /**
     * IRenderFactoryはどのIRrenderLogicの実装を生成すべきか知っている
     * @author imajuk
     */
    public interface IRenderPlugin
    {
        function initialize(render2D : Render2D) : void;

        function drawDebugResource(b : BitmapData, m : Matrix) : void;
    }
}
