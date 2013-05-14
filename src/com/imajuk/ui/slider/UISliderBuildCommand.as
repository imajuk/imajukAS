package com.imajuk.ui.slider 
{
    import com.imajuk.ui.IUISlider;
    import com.imajuk.logs.Logger;
    
    import com.imajuk.commands.ICommand;
    import com.imajuk.commands.Command;

    /**
     * @author shinyamaharu
     */
    public class UISliderBuildCommand extends Command implements ICommand 
    {
        public function UISliderBuildCommand(model:UISliderModel, slider:IUISlider)
        {
            super(function():void
            {
                //=================================
                // logging
                //=================================
                Logger.info(1, "build UISlider");
                Logger.debug(null, "size:" + model.size , "barSize:" + model.barSize);
                Logger.debug(null, "barSpace:" + model.barSpace);
                
                //=================================
                // build
                //=================================
                slider.build(model);
            });
        }
    }
}
