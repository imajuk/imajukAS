package com.imajuk.ui.scroll 
{
    import com.imajuk.ui.scroll.IScrollContainer;
    import com.imajuk.ui.scroll.IScrollContainerMask;
    import com.imajuk.ui.scroll.ScrollContainer;

    import flash.display.DisplayObject;
    import flash.display.Sprite;

    /**
     * @author shinyamaharu
     */
    public class MouseOverScrollContainer extends ScrollContainer implements IScrollContainer 
    {
        public function MouseOverScrollContainer(
                            content : DisplayObject, 
                            contentMask : IScrollContainerMask, 
                            contentHitArea : Sprite = null, 
                            debug : Boolean = false
                        )
        {
            super(content, contentMask, debug);
            
            if (!contentHitArea)
                throw new Error("ヒットエリアが渡されませんでした");

            _contentHitArea = addChild(contentHitArea) as Sprite;
            _contentHitArea.visible = debug;
            _contentHitArea.name = "_hitArea_";
            hitArea = _contentHitArea;
        }
        
        /**
         * コンテナのヒットエリアです
         */        
        protected var _contentHitArea : Sprite;
        public function get contentHitArea() : DisplayObject
        {
            return _contentHitArea;
        }
    }
    
    
}
