package com.imajuk.ui.slider 
{
	
    import com.imajuk.motion.TweensyThread;
    import com.imajuk.threads.InvorkerThread;
    import com.imajuk.threads.ThreadUtil;
    import com.imajuk.ui.IUISlider;
    import com.imajuk.ui.UIType;
    import fl.motion.easing.Cubic;
    import fl.motion.easing.Exponential;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import org.libspark.thread.Thread;

    



    /**
     * @author shinyamaharu
     */
    public class BasicSliderCommandFactory implements ISliderCommandFactory
    {
    	protected var reset : Thread;
    	protected var display : Thread;
    	protected var scrollBarVisible : Thread;
    	protected var interaction : Thread;
        protected var scrollContainer : DisplayObjectContainer;
        protected var uiScrollBar : IUISlider;
        protected var _model : UISliderModel;

        public function BasicSliderCommandFactory(
    	                       scrollContainer : DisplayObjectContainer,
                               uiScrollBar : IUISlider,
                               model : UISliderModel) 
        {
            this._model = model;
            this.uiScrollBar = uiScrollBar;
            this.scrollContainer = scrollContainer;
        }

        //--------------------------------------------------------------------------
        //
        //  implementation of IScrollExecuter
        //
        //--------------------------------------------------------------------------
        public function startCommand() : Thread
        {
            return ThreadUtil.pararel(
                [
                   resetCommand(),
                   displayCommand(),
                   interactionCommand(),
                   updateScrollbarCommand()
                ]
            );
        }
        
        protected function resetCommand() : Thread 
        {
            reset = new UISliderResetThread(uiScrollBar);
            return reset;
        }
        
        protected function displayCommand() : Thread 
        {
            display = new UISliderDisplayThread(scrollContainer, DisplayObject(uiScrollBar));
            return display;
        }
        
        protected function showCommand() : Thread
        {
            if (uiScrollBar.alpha != 0)
               return new Thread();
               
            interruptVisibleBehavior();
            
            if (_model.barSize < 0)
                return new Thread();
                
            scrollBarVisible = new TweensyThread(uiScrollBar, 0, 1, Exponential.easeInOut, null, {alpha:1}); 
            return scrollBarVisible;
        }
        
        protected function interruptVisibleBehavior() : void 
        {
            if (scrollBarVisible)
                scrollBarVisible.interrupt();
        }
        
        protected function interactionCommand() : Thread 
        {
            interaction = new UISliderThread(uiScrollBar, _model);
            return interaction;
        }
        
        public function updateScrollbarCommand(autoCalcContentSize : Boolean = true) : Thread
        {
            return new InvorkerThread(
                function():void
                {
                	new UISliderBuildCommand(_model, uiScrollBar).execute();
                    showCommand().start();
                }
            );
        }
        
        public function resetScrollbarCommand() : Thread
        {
            if (uiScrollBar.direction == UIType.HORIZONAL)
                return new TweensyThread(uiScrollBar.bar, 0, .5, Exponential.easeOut, null, {x:_model.destMin});            else                return new TweensyThread(uiScrollBar.bar, 0, .5, Exponential.easeOut, null, {y:_model.destMin});        }
        
        public function disposeCommand() : Thread
        {
            return ThreadUtil.serial(
               [
                   ThreadUtil.pararel(
                       [
                           resetScrollbarCommand(),
                           
                           (uiScrollBar.direction == UIType.HORIZONAL) ?
                                new TweensyThread(scrollContainer, 0, .5, Cubic.easeOut, null, {x:0}) :                                new TweensyThread(scrollContainer, 0, .5, Cubic.easeOut, null, {y:0}),
                                
                           new TweensyThread(uiScrollBar, 0, 1, Exponential.easeInOut, null, {alpha:0})
                       ]
                   ),
                   new InvorkerThread(
                       function():void
                       {
                            if (interaction)
                                interaction.interrupt();
                            if (display)
                                display.interrupt();
                       }
                   )
               ]);
        }
        
        
    }
}
