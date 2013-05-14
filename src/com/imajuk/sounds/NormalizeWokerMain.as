package com.imajuk.sounds
{
    import flash.display.IGraphicsData;
    import com.imajuk.logs.Logger;

    import flash.display.GraphicsPath;
    import flash.display.GraphicsPathCommand;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsStroke;
    import flash.display.LineScaleMode;
    import flash.display.Sprite;
    import flash.system.Worker;
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    /**
     * the main class for worker .swf
     * this must be compiled with parameter '-swf-version=17'
     * 
     * @author imajuk
     */
    public class NormalizeWokerMain extends Sprite
    {
        private var shared : ByteArray;
        private var copy : ByteArray;
        private var left : Number;
        private var right : Number;
        private var left_peak : Number;
        private var right_peak : Number;
        private var idx_peak : int;
        private var debug : ByteArray;
        private var loops : uint;
        private var graphicsSata : Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
        
        public function NormalizeWokerMain()
        {
            Logger.show(Logger.INFO);
            
            reset();
            waitSoundBinary();
        }

        private function waitSoundBinary() : void
        {
            var interval : uint = setInterval(function() : void
            {
                shared = Worker.current.getSharedProperty("result") as ByteArray;
                debug  = Worker.current.getSharedProperty("debug") as ByteArray;
                
                if (shared)
                {
                    clearInterval(interval);
                    
                    loops  = shared.length;
                    copy   = new ByteArray();
                    
                    shared.position = 0;
                    while (shared.position < loops)
                    {
                        copy.writeFloat(shared.readFloat());
                    }
                    
                    detectPeakLevel();
                }
                
            }, 1000 / 60);
        }

        private function detectPeakLevel() : void
        {
            var i : int;
            
            shared.position = 0;
            while (shared.position < loops)
            {
                i = shared.position;
                
                left  = shared.readFloat();
                right = shared.readFloat();

                left  = left < 0 ? -left : left;
                right = right < 0 ? -right : right;

                if (left > left_peak)
                {
                    left_peak = left;
                    idx_peak  = idx_peak > i ? idx_peak : i;
                }
                if (right > right_peak)
                {
                    right_peak = right;
                    idx_peak   = idx_peak > i ? idx_peak : i;
                }
            }
            
            normalize();
            
        }

        private function normalize() : void
        {
            var left_scale  : Number = 1 / left_peak,
                right_scale : Number = 1 / right_peak,
                left_norm   : Number, 
                right_norm  : Number,
                         i  : int, 
                        lx  : int;
            Logger.info(1, 'left_max  : ' + (left_peak));
            Logger.info(1, 'right_max : ' + (right_peak));
            Logger.info(1, 'scale     : ' + (left_scale));
            
            shared.position = 0;
              copy.position = 0;
            while (copy.position < loops)
            {
                i = copy.position;
                
                left  = copy.readFloat();
                right = copy.readFloat();
                
                left_norm  = left  * left_scale;
                right_norm = right * right_scale;

                shared.writeFloat(left_norm);
                shared.writeFloat(right_norm);

                if (debug && Math.abs(i - idx_peak) < 4000)
                    drawDebugData(lx++, left, right, left_norm, right_norm);
            }
            
            if (debug)
            {
                debug.clear();
                debug.writeObject(graphicsSata);
            }
            
            reset();

            Logger.info(1, 'complete.');
            Worker.current.setSharedProperty("complete", true);
        }

        private function drawDebugData(lx:int, left : Number, right : Number, left_norm : Number, right_norm : Number) : void
        {
            const       cmd_left : Vector.<int>    = new Vector.<int>(),
                       cmd_right : Vector.<int>    = new Vector.<int>(),
                       data_left : Vector.<Number> = new Vector.<Number>(),
                      data_right : Vector.<Number> = new Vector.<Number>(),
                     stroke_left : GraphicsStroke  = new GraphicsStroke(1, false, LineScaleMode.NONE, "none", "round", 3, new GraphicsSolidFill(0xff0000)),
                    stroke_right : GraphicsStroke  = new GraphicsStroke(1, false, LineScaleMode.NONE, "none", "round", 3, new GraphicsSolidFill(0x0000ff)),
                       path_left : GraphicsPath    = new GraphicsPath(cmd_left, data_left),
                      path_right : GraphicsPath    = new GraphicsPath(cmd_right, data_right);
            
            graphicsSata.push(stroke_left, path_left, stroke_right, path_right);
            
                
            cmd_left.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
            data_left.push(lx, 0, lx, -Math.abs(left * 100));
            cmd_right.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
            data_right.push(lx, 0, lx, Math.abs(right * 100));

            cmd_left.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
            data_left.push(lx, 200, lx, -Math.abs(left_norm * 100) + 200);
            cmd_right.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
            data_right.push(lx, 200, lx, Math.abs(right_norm * 100) + 200);
            
        }

        private function reset() : void
        {
            shared     = null;
            copy       = null;
            left_peak  = 0;
            right_peak = 0;
            idx_peak   = 0;
            debug      = null;
        }
    }
}
