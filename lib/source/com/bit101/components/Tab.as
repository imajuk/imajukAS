/**
 * Window.as
 * Keith Peters
 * version 0.9.10
 * 
 * A draggable window. Can be used as a container for other components.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package com.bit101.components
{
    import flash.events.IEventDispatcher;
    import flash.filters.ColorMatrixFilter;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.MouseEvent;

	[Event(name="select", type="flash.events.Event")]
	public class Tab extends Component
	{
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
        protected var _draggable:Boolean = true;
        protected var _tabs : Array;
        protected var _contents : Array;
        protected var _labels : Array;
        protected var _labelTexts : Array;
        protected var _current : int = 0;
        protected var _darkness : ColorMatrixFilter = 
                                    new ColorMatrixFilter([
                                        1, 0, 0, 0, -10, 
                                        0, 1, 0, 0, -10, 
                                        0, 0, 1, 0, -10, 
                                        0, 0, 0, 1, 0
                                    ]);

		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function Tab(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
        {
            super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(100, 100);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
            _tabs = [];
            _contents = [];
            _labels = [];
            _labelTexts = [];
            
			filters = [getShadow(4, false)];
        }

		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Overridden to add new child to current content.
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			getContent(_current).addChild(child);
			return child;
		}
		
		/**
		 * Access to super.addChild
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
        
        /**
         * add new page
         * @param label a label text of the page.
         * @param panel new page. if it's omitted a Panel object will be created automatically for new page.
         */
        public function addPage(label : String, panel : Panel = null) : void
        {
            var tab : Panel = new Panel();
            tab.filters = [];
            tab.buttonMode = true;
            tab.useHandCursor = true;
            tab.mouseChildren = false;
            tab.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
            tab.height = 20;
            tab.tag = _tabs.length;
            super.addChild(tab);

            _labels.push(new Label(tab.content, 5, 1, label));
            _labelTexts.push(label);
            _tabs.push(tab);
            
            if (!panel) panel = new Panel();
            panel.y = 20;
            _contents.push(panel);
        }

        /**
         * add new element to a page.
         * @param   index 0 base index of pages.
         * @param   child element you want to add to.
         * @return  added element.
         */
        public function addChildToPage(index : int, child : DisplayObject) : DisplayObject
        {
            getContent(index).addChild(child);
            return child;
        }
        
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
            
            _labels.forEach(function(label : Label, idx : int, ...param) : void
            {
                label.text = _labelTexts[idx];
                label.alpha = idx == _current ? 1 : .4;
            });
            var w:Number = (_width-20) / _tabs.length;
            _tabs.forEach(function(tab : Panel, idx : int, ...param) : void
            {
                tab.x = idx * w;
                tab.width = w;
                tab.color = _color;
                tab.filters = idx == _current ? [] : [_darkness];
                tab.draw();
            });
            _contents.forEach(function(content : Panel, ...param) : void
            {
                content.color = _color;
                content.setSize(_width, _height - 20);
                content.draw();
                if (content.parent)
                    content.parent.removeChild(content);
            });
            super.addChild(_contents[_current]);
            
        }


		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseDown handler. Starts a drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
            if(_draggable)
            {
                this.startDrag();
                stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
                parent.addChild(this); // move to top
            }
            var tab:Panel = event.target as Panel;
            if (tab)
            {
                super.addChild(tab);
                _current = tab.tag; 
                invalidate();
            }
			dispatchEvent(new Event(Event.SELECT));
		}
        
        /**
         * Internal mouseUp handler. Stops the drag.
         * @param event The MouseEvent passed by the system.
         */
        protected function onMouseGoUp(event:MouseEvent):void
        {
            this.stopDrag();
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
        }
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets whether or not this Window will have a drop shadow.
		 */
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(4, false)];
			}
			else
			{
				filters = [];
			}
		}
		public function get shadow():Boolean
		{
			return _shadow;
		}
		
		/**
		 * Gets / sets the background color of this panel.
		 */
		public function set color(c:int):void
		{
			_color = c;
			invalidate();
		}
		public function get color():int
		{
			return _color;
		}
        
        /**
         * Current container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
         */
        public function get content():DisplayObjectContainer
        {
            return getContent(_current);
        }
		
		/**
		 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
		 */
		public function getContent(index:int):DisplayObjectContainer
		{
            return Panel(_contents[index]).content;
        }
        
        /**
         * Sets / gets whether or not the window will be draggable by the title bar.
         */
        public function set draggable(b:Boolean):void
        {
            _draggable = b;
            _tabs.forEach(function(tab : Panel, ...param) : void
            {
                tab.buttonMode = _draggable;
                tab.useHandCursor = _draggable;
            });
        }
        
        public function get draggable():Boolean
        {
            return _draggable;
        }

        /**
         * gets index of current active page.
         */
        public function get current() : int
        {
            return _current;
        }
	}
}