package com.imajuk.ui 
{
    import com.imajuk.ui.slider.UISliderModel;

    /**
     * @author shinyamaharu
     */
    public interface IUISlider extends IUIView
    {
    	function get bar():IUIView;    	function get backGround() : IUIView
    	
    	function set size(value : int) : void;

        function build(model : UISliderModel) : void;

        function reset() : void;

        function get direction() : String;        function set direction(value:String) : void;
    }
}
