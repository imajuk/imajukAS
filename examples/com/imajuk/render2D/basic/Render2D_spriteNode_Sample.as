package com.imajuk.render2D.basic
{
    import com.imajuk.constructions.DocumentClass;
    import com.imajuk.data.LinkList;
    import com.imajuk.logs.Logger;
    import com.imajuk.render2D.Render2D;
    import com.imajuk.render2D.Render2DCamrera;
    import com.imajuk.render2D.Render2DWorld;
    import com.imajuk.render2D.plugins.dowrap.DONode;
    import com.imajuk.utils.PerformanceChecker;

    import org.libspark.betweenas3.BetweenAS3;
    import org.libspark.betweenas3.easing.Back;
    import org.libspark.betweenas3.easing.Cubic;
    import org.libspark.betweenas3.easing.Quad;
    import org.libspark.thread.EnterFrameThreadExecutor;
    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.StageQuality;


    /**
     * @author yamaharu
     */
    public class Render2D_spriteNode_Sample extends DocumentClass 
    {
        private var nodes : LinkList;
        
        public function Render2D_spriteNode_Sample()
        {
            super(StageQuality.HIGH);
            
            Thread.initialize(new EnterFrameThreadExecutor());
            
            Logger.release("Render2D sample DO");
            
            
            nodes = new LinkList();
            var node : DONode;
            for (var i : int = 0; i < 1000; i++)
            {
                node = new DONode(new Node(100, 100));
                node.worldX = node.x = Math.random() * 4000;
                node.worldY = node.y = Math.random() * 4000;
                node.rotation = Math.random() * 360;
                nodes.push(node);
            }
        }

        override protected function start() : void
        {
            //create Render2D
            var render2D:Render2D = new Render2D(450, 450);
            
            //camera
            var camera:Render2DCamrera = render2D.camera; 
            
        	//this is a world
            var world:Render2DWorld = render2D.createWorld(4000, 4000);
            
            //add nodes from DO to world
            world.addDONodes(nodes);
            
            
            //render
            render2D.render().start();

            //debug
            var debug:DisplayObject = render2D.createDebugger(400);
            debug.x = 500;
            debug.y = 30;
            
            
            addChild(render2D);
            addChild(debug);
            

            BetweenAS3.serial(
                BetweenAS3.to(camera, {x:1000, y:3000}, 5, Quad.easeIn),
                BetweenAS3.to(camera, {y:1000},  6, Cubic.easeOut),
                BetweenAS3.to(camera, {scale:4},4, Back.easeInOut),
                BetweenAS3.to(camera, {scale:1},9, Back.easeInOut),
                BetweenAS3.to(camera, {rad:Math.PI - .3},4, Back.easeOut),
                BetweenAS3.to(camera, {rad:0},6, Back.easeOut),
                BetweenAS3.to(camera, {x:2000, y:2000},6, Back.easeOut)
            ).play();
            
//            setInterval(function() : void
//            {
//                BetweenAS3.to(nodes[int(Math.random()*nodes.length)], {worldX:Math.random()*4000, worldY:Math.random()*4000}, 30, Back.easeInOut).play();
//            }, 30);
            
            PerformanceChecker.instance.initialize(this);
        }

    }
}


