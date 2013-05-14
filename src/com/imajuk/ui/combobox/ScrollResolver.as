package com.imajuk.ui.combobox 
{
    import flash.display.Sprite;

    import com.imajuk.ui.scroll.IScrollContainerMask;

    /**
     * @author shinyamaharu
     */
    public class ScrollResolver 
    {
        public var contentMask : IScrollContainerMask;
        public var contenthitArea : Sprite;

        public function ScrollResolver(mask : IScrollContainerMask, hitarea : Sprite) 
        {
            this.contentMask = mask;
            this.contenthitArea = hitarea;	
        }
    }
}
