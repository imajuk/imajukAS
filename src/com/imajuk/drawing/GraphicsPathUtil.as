package com.imajuk.drawing 
{
    import flash.display.GraphicsPathCommand;
    import flash.display.GraphicsPath;
    import flash.geom.Point;

    /**
     * @author shinyamaharu
     */
    public class GraphicsPathUtil 
    {
        public static function getLinePathData(a : Point, b : Point) : GraphicsPath 
        {
            var cmd : Vector.<int> = new Vector.<int>(); 
            var data : Vector.<Number> = new Vector.<Number>(); 
            var path : GraphicsPath = new GraphicsPath(cmd, data);
            cmd.push(GraphicsPathCommand.MOVE_TO);
            data.push(a.x, a.y);
            cmd.push(GraphicsPathCommand.LINE_TO);
            data.push(b.x, b.y);
            return path;
        }
    }
}
