package com.imajuk.ui.scroll 
{
	import com.imajuk.motion.TweensyThread;
	import com.imajuk.threads.InvorkerThread;
	import com.imajuk.threads.ThreadUtil;
	import com.imajuk.ui.IUISlider;
	import com.imajuk.ui.slider.BasicSliderCommandFactory;
	import com.imajuk.ui.slider.UIScrollBarSlideBarThread;
	import fl.motion.easing.Exponential;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import org.libspark.thread.Thread;



    /**
     * @author shinyamaharu
     */
    public class BasicScrollCommandFactory extends BasicSliderCommandFactory implements IScrollCommandFactory 
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        public function BasicScrollCommandFactory(
                               scrollContainer : IScrollContainer,
                               uiScrollBar : IUISlider,
                               model:UIScrollBarModel
                        )       
        {
            super(DisplayObjectContainer(scrollContainer), uiScrollBar, model);
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var containerUpdate : Thread;

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        public function get wheelTarget() : DisplayObject
        {
            return DisplayObject(IScrollContainer(scrollContainer).contentMask);
        }

        //--------------------------------------------------------------------------
        //
        //  implementation of IScrollExecuter
        //
        //--------------------------------------------------------------------------

        override public function disposeCommand() : Thread
        {
            return ThreadUtil.serial(
                [
                    super.disposeCommand(), 
                    new InvorkerThread(
                        function():void
                        {
                            if (containerUpdate)
                                containerUpdate.interrupt();
                        }
                    )
                ]);
        }

        /**
         * UIを再構築するThreadを返します.
         * コンテナの内容が代わりサイズが変更された場合は、
         * このメソッドを呼び出してスクロールバーをアップデートする必要があります
         */
        override public function updateScrollbarCommand(autoCalcContentSize : Boolean = true) : Thread
        {
            return ThreadUtil.pararel(
                [
                    new InvorkerThread(
                        function():void
                        {
                        	new UIScrollBarBuildCommand(UIScrollBarModel(_model), IScrollContainer(scrollContainer), uiScrollBar).execute();
                    
                            if (!UIScrollBarModel(_model).needScrollbar)
                            {
                                uiScrollBar.alpha = 0;
                                interruptVisibleBehavior();
                                return;
                            }
                            showCommand().start();
                            positionCommand().start();
                        }
                    ), 
                ]
            );
        }


        public function autoScroll() : void
        {
            new TweensyThread(uiScrollBar.bar, 0, .5, Exponential.easeOut, null, {y:model.getBarRange().height}).start();
        }

        public function wheel(value : int) : void
        {
        	new UIScrollBarSlideBarThread(uiScrollBar.bar, model, value, false).start();
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: private
        //
        //--------------------------------------------------------------------------
        
        override protected function interactionCommand() : Thread 
        {
            interaction = new UIScrollBarInteractionThread(UIScrollBar(uiScrollBar), this);
            return interaction;
        }
        
        private function positionCommand() : Thread 
        {
        	if (containerUpdate)
                    containerUpdate.interrupt();
            containerUpdate = new ScrollContentPositionThread(uiScrollBar.bar, IScrollContainer(scrollContainer), model);
            return containerUpdate;
        }
        
        public function get model() : UIScrollBarModel
        {
            return UIScrollBarModel(_model);
        }
    }
}
