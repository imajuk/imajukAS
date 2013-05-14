package com.imajuk.display
{
    import com.imajuk.color.Color;
    import com.imajuk.geom.Circle;
    import com.imajuk.geom.IGeom;
    import com.imajuk.utils.GraphicsUtil;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     * @author imajuk
     */
    public class DraggableSprite extends Sprite
    {
        private var _dragging : Boolean;
        private var s : Stage;
        private var draggingTask : Function;
        private var _geom : IGeom = new Circle(0, 0, 5);
        private var ignoreChildren : Array;
        private var lockCenter : Boolean;
        private var _dragBounds : Rectangle;
        private var compTask : Function;

        public function DraggableSprite(
                            lockCenter : Boolean = false, 
                            bounds : Rectangle = null, 
                            draggingTask : Function = null, 
                            compTask:Function = null,
                            ...ignoreChildren
                        )
        {
            this.lockCenter = lockCenter;
            this._dragBounds = bounds;
            this.draggingTask = draggingTask;
            this.compTask = compTask;
            this.ignoreChildren = ignoreChildren;

            buttonMode = true;
            useHandCursor = true;

            addEventListener(Event.ADDED_TO_STAGE, function() : void
            {
                s = stage;
                addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
                stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
                stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            });

            addEventListener(Event.REMOVED_FROM_STAGE, function() : void
            {
                removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
                s.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
                s.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            });
        }

        private function moveHandler(event : MouseEvent) : void
        {
            if (_dragging && stage)
            {
                if (draggingTask != null)
                    draggingTask();
            }
        }

        private function upHandler(event : MouseEvent) : void
        {
            if (_dragging && compTask != null) compTask();
            
            _dragging = false;
            stopDrag();
        }

        private function downHandler(event : MouseEvent) : void
        {
            if (ignoreChildren.some(function(d:DisplayObject, ...param) : Boolean
            {
                return d.hitTestPoint(event.stageX, event.stageY);
            })) return;
            
            _dragging = true;
            startDrag(lockCenter, _dragBounds);
        }

        public function set type(geom : IGeom) : void
        {
            _geom = geom;
            GraphicsUtil.drawGeom(geom, graphics, _fill, _line, _tickness);
        }

        private var _fill : Color = Color.fromARGB(0xFF000000);
        public function get fill() : Color
        {
            return _fill;
        }
        public function set fill(fill : Color) : void
        {
            _fill = fill;
            type = _geom;
        }

        private var _line : Color;
        public function get line() : Color
        {
            return _line;
        }
        public function set line(line : Color) : void
        {
            _line = line;
        }

        private var _tickness : Number = 0;
        public function get tickness() : Number
        {
            return _tickness;
        }
        public function set tickness(tickness : Number) : void
        {
            _tickness = tickness;
        }

        public function get isDragging() : Boolean
        {
            return _dragging;
        }

        public function get dragBounds() : Rectangle
        {
            return _dragBounds;
        }

        public function set dragBounds(dragBounds : Rectangle) : void
        {
            _dragBounds = dragBounds;
        }
    }
}
