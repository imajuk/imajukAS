package com.imajuk.service
{
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import com.imajuk.interfaces.IProgess;
    import com.imajuk.interfaces.IProgessComponent;

    import flash.events.EventDispatcher;

    /**
     * @author shin.yamaharu
     */
    public class AbstractProgress extends EventDispatcher implements IProgessComponent
    {
        public function AbstractProgress(value : Number = 0, total : Number = 0)
        {
            _value = value;
            _total = total;
    	}
    	
        override public function toString() : String
        {
            return "AbstractProgress[ " + value + " / " + total + " (" + percent * 100 + "%) ]";
        }
    	
        protected var _value : Number;
        public function get value() : Number
        {
            var sum : Number = _value;
            children.forEach(function(m : IProgess, ...param) : void
            {
                sum += m.value;
            });
            return sum;
        }
        public function set value(value : Number) : void
        {
            _value = value;
            
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _value, _total));
            if (percent == 1)
                dispatchEvent(new Event(Event.COMPLETE));
        }

        protected var _total : Number;
        public function get total() : Number
        {
            var sum : Number = _total;
            children.forEach(function(m : IProgess, ...param) : void
            {
                sum += m.total;
            });
            return sum;
        }
        public function set total(value : Number) : void
        {
            _total = value;
        }
        
        
        public function get percent() : Number
        {
            var sum : Number = (_total == 0) ? 0 : _value / _total;
            var l : int = children.length + 1 || 2;
            children.forEach(function(m : IProgess, ...param) : void
            {
                sum += m.percent;
            });
            return sum / l;
        }


        protected var children : Array = [];        public function add(progressModel : IProgess) : void
        {
            children.push(progressModel);
            
            progressModel.addEventListener(ProgressEvent.PROGRESS, dispatchEvent);
        }
    }
}
