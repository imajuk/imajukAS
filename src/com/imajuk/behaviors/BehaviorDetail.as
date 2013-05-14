package com.imajuk.behaviors 
{
    import org.libspark.betweenas3.core.easing.IEasing;
    import org.libspark.betweenas3.easing.Cubic;
    import org.libspark.betweenas3.easing.Expo;

    /**
     * @author shinyamaharu
     */
    public class BehaviorDetail 
    {
        public var overDuration : Number       = .4;        public var outDuration : Number        = .2;
        public var downDuration : Number       = .1;
        public var upDuration : Number         = .1;        public var enabledDuration : Number    = .4;        public var disabledDuration : Number   = .3;        public var selectedDuration : Number   = .4;        public var unSelectedDuration : Number = .3;
        
        public var overEasing : IEasing       = Expo.easeOut;        public var outEasing : IEasing        = Expo.easeOut;
        public var downEasing : IEasing       = Expo.easeOut;
        public var upEasing : IEasing         = Expo.easeOut;        public var enabledEasing : IEasing    = Expo.easeOut;        public var disabledEasing : IEasing   = Expo.easeOut;        public var selectedEasing : IEasing   = Expo.easeInOut;        public var unSelectedEasing : IEasing = Cubic.easeIn;
    }
}
