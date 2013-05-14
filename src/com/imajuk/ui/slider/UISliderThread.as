package com.imajuk.ui.slider{    import com.imajuk.logs.Logger;    import com.imajuk.ui.IUISlider;    import com.imajuk.ui.IUIView;    import com.imajuk.ui.UIType;    import com.imajuk.utils.StageReference;    import org.libspark.thread.Thread;    import flash.display.Sprite;    import flash.events.MouseEvent;    import flash.geom.Rectangle;    /**     *      * @author shinyamaharu     */    public class UISliderThread extends Thread     {        private var model : UISliderModel;        private var slider : IUISlider;
        private var bar : IUIView;
        private var draggableArea : Rectangle;
        public function UISliderThread(slider : IUISlider, model : UISliderModel)        {            super();            this.model = model;            this.slider = slider;            this.bar = slider.bar;        }        override protected function run() : void        {        	interaction();        }        private function interaction() : void         {        	if(isInterrupted) return;        	interrupted(function():void{});                        event(bar,               MouseEvent.MOUSE_DOWN, startDrag);
            event(slider.backGround, MouseEvent.MOUSE_DOWN, bgClicked);
        }
        
        private function startDrag(e : MouseEvent) : void
        {
        	if(isInterrupted) return;
        	interrupted(function():void{});                     draggableArea = model.getBarRange();                        Sprite(bar).startDrag(false, draggableArea);
                        dragging();
        }

        private function dragging() : void
        {
        	if(isInterrupted) return;
            interrupted(function():void{});
            
            event(StageReference.stage, MouseEvent.MOUSE_MOVE, mouseMove);
            event(StageReference.stage, MouseEvent.MOUSE_UP, stopDrag);        }

        private function mouseMove(e : MouseEvent) : void
        {
            if (e.stageY < 0)
            {
                stopDrag(null);
                return;
            }            
        	var v:Number = bar.x / (draggableArea.x + draggableArea.width);
        	if (model.value != v)
        	   model.value = v;
        	   
        	dragging();
        }
                private function stopDrag(e : MouseEvent) : void        {            if(isInterrupted)               return;                           Sprite(bar).stopDrag();
                        model.value = bar.x / (draggableArea.x + draggableArea.width);                        next(run);        }                protected function bgClicked(e:MouseEvent) : void         {            var direction : int = 0;            
            if (model.direction == UIType.HORIZONAL)            {                if (e.localX < bar.x)                    direction = -1;                 else if (e.localX > bar.x + bar.externalWidth)                    direction = 1;                if (direction != 0)                    new UIScrollBarSlideBarThread(bar, model, bar.externalWidth * direction).start();            }            else            {                if (e.localY < bar.y)                    direction = -1;                 else if (e.localY > bar.y + bar.externalHeight)                    direction = 1;                if (direction != 0)                    new UIScrollBarSlideBarThread(bar, model, bar.externalHeight * direction).start();            }                                            next(interaction);        }        override protected function finalize() : void        {            Logger.debug(this);        }    }}