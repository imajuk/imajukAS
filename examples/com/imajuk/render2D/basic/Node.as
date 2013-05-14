package com.imajuk.render2D.basic
{
    import flash.display.Shape;

    /**
     * @author yamaharu
     */
    public class Node extends Shape
    {
        public function Node(nodeWidth : int, nodeHeight : int)
        {
        	graphics.beginFill(Math.random()*0xFFFFFF);
        	graphics.drawRect(-nodeWidth*.5, -nodeHeight*.5, nodeWidth, nodeHeight);
        }
    }
}
