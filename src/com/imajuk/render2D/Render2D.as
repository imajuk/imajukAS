package com.imajuk.render2D
{
    import com.imajuk.graphics.LiquidLayout;
    import com.imajuk.render2D.logics.NodeLayoutLogic;
    import com.imajuk.render2D.utils.Render2DDebugger;
    import com.imajuk.utils.StageReference;

    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;

    
    /**
     * @author imajuk
     */
    public class Render2D extends Sprite
    {
        public static const LIQUID : int = -1;
        
        render_internal var layoutNodeLogic : IRenderLogic = new NodeLayoutLogic();
        render_internal var bmpTrimLogic : IRenderLogic;
        
        /**
         * @param width ビューの幅.
         *              Render2D.LIQUIDを指定すると常にステージの横幅にフィットするようになります.
         * @param height ビューの高さ.
         *              Render2D.LIQUIDを指定すると常にステージの縦幅にフィットするようになります.
         */
        public function Render2D(viewWidth:int = 450, viewHeight:int = 450, useMask:Boolean = true)
        {
        	//defaultCamera
        	createCamera(viewWidth, viewHeight);
        	
        	//mask
        	if (useMask)
                mask = addChild(new Shape()) as Shape;
        	
            if (viewWidth == LIQUID)
                LiquidLayout.resisterTask(fitToStageWidth)();
            else
                _viewWidth = viewWidth;
            
            if (viewHeight == LIQUID)
                LiquidLayout.resisterTask(fitToStageHeight)();
            else
                _viewHeight = viewHeight;
                
        	if (viewWidth == LIQUID || viewHeight == LIQUID)
                LiquidLayout.initialize(StageReference.stage);
        	
        	updateMask();
        }
        
        private var _viewWidth : int;
        public function get viewWidth() : int
        {
            return _viewWidth;
        }
        public function set viewWidth(value : int) : void
        {
            _viewWidth = camera.width = value;
            updateMask();
        }

        private var _viewHeight : int;
        public function get viewHeight() : int
        {
            return _viewHeight;
        }
        public function set viewHeight(value : int) : void
        {
            _viewHeight = camera.height = value;
            updateMask();
        }
        
        private function fitToStageWidth() : void
        {
            viewWidth = StageReference.stage.stageWidth;
        }
        
        private function fitToStageHeight() : void
        {
            viewHeight = StageReference.stage.stageHeight;
        }

        private var _world : Render2DWorld;
        public function get world() : Render2DWorld
        {
            return _world;
        }

        private var _camera : Render2DCamrera;
        public function get camera() : Render2DCamrera
        {
            return _camera;
        }
        
        public function render() : RenderThread
        {
        	if (render_internal::bmpTrimLogic)
        	   return new RenderThread(render_internal::bmpTrimLogic.render);
        	else
        	   return new RenderThread(render_internal::layoutNodeLogic.render);
        }

        public function createDebugger(size : int) : Render2DDebugger
        {
            return new Render2DDebugger(size).initialize(this);
        }

        public function createWorld(worldWidth : int, worldHeight : int) : Render2DWorld
        {
        	_world = new Render2DWorld(this, worldWidth, worldHeight); 
            return _world;
        }

        /**
         * 現在のカメラを破棄し新しいカメラを作成
         */
        private function createCamera(
                            cameraWidth : int, 
                            cameraHeight : int, 
                            cameraX:Number = 0, 
                            cameraY:Number = 0, 
                            cameraScale:Number = 1
                        ) : Render2DCamrera
        {
        	_camera = 
        	   new Render2DCamrera(
        	       cameraWidth, cameraHeight,
        	       cameraX, cameraY, cameraScale
        	   );
        	
            return _camera;
        }

        private function updateMask() : void
        {
        	if (!mask)
        	   return;
        	   
        	var g:Graphics = Shape(mask).graphics;
        	g.clear();
            g.beginFill(0);
            g.drawRect(0, 0, _viewWidth, _viewHeight);
        }
    }
}

import com.imajuk.utils.StageReference;

import org.libspark.thread.Thread;

import flash.display.Stage;
import flash.events.Event;
class RenderThread extends Thread
{
    private var stage : Stage;
    private var f : Function = function() : void
    {
    };
    private var renderMethod : Function;

    public function RenderThread(renderMethod:Function)
    {
        super();

        this.renderMethod = renderMethod;
        StageReference.dispatchRenderEvent = true;
        stage = StageReference.stage;
    }

    override protected function run() : void
    {
        if (isInterrupted) return;
        interrupted(f);

        event(stage, Event.RENDER, onRender);
    }

    private function onRender(...param) : void
    {
//    	var t:int = getTimer();
        renderMethod();
//        trace(getTimer()-t);
        run();
    }

    override protected function finalize() : void
    {
    }
}
