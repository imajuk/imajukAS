package com.imajuk.ui.scroll 
{
    import com.imajuk.ui.IUISlider;
    import com.imajuk.logs.Logger;
    import com.imajuk.commands.Command;
    import com.imajuk.commands.ICommand;

    /**
     * @author shinyamaharu
     */
    public class UIScrollBarBuildCommand extends Command implements ICommand 
    {
        public function UIScrollBarBuildCommand(model:UIScrollBarModel, scrollContainer:IScrollContainer, scrollBar:IUISlider)
        {
            super(function():void
            {
            	//=================================
                // calcurate the height of content
                //=================================
                if (model.autoCalcContentSize)
                    scrollContainer.actualHeight = -1;
                
                //=================================
                // get the height of mask
                //=================================
                var maskHeight:int = scrollContainer.contentMask.rectangle.height;
                
                //=================================
                // calcurate the sizes of bar and it's relational elements
                //=================================
                model.barSize = scrollContainer.actualHeight <= maskHeight ? 
                                0 :
                                (model.isFlexibleHandle) ?
                                    1 / (scrollContainer.actualHeight / maskHeight) * (model.size - model.arrowSpace) :
                                    model.barSize;
//                trace('scrollContainer.actualHeight: ' + (scrollContainer.actualHeight));
//                trace('maskHeight: ' + (maskHeight));
//                trace('model.arrowSpace: ' + (model.arrowSpace));
//                trace('model.size: ' + (model.size));
//                trace('model.barSize: ' + (model.barSize));
                                
                //=================================
                // logging
                //=================================
                Logger.info(1, "build UIScrollBar " + scrollContainer.parent.name);
                Logger.debug(null, "containerHeight:" + scrollContainer.actualHeight , "maskHeight:" + maskHeight);
                Logger.debug(null, "size:" + model.size , "barSize:" + model.barSize);                Logger.debug(null, "barSpace:" + model.barSpace);                Logger.debug(null, "needScrollbar:" + (model.needScrollbar ? "yes" : "no") );
                
                //=================================
                // build
                //=================================
                if (model.needScrollbar)
                    scrollBar.build(model);
                else
                    scrollBar.visible = false;            });
        }
    }
}
