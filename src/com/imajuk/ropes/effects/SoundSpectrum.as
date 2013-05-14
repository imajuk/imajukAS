package com.imajuk.ropes.effects
{
    import com.imajuk.geom.Vector2D;
    import com.imajuk.ropes.models.ControlPoint;
    import com.imajuk.ropes.shapes.IRopeShape;
    import com.imajuk.sounds.SoundSpectrumMapper;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;


    /**
     * @author imajuk
     */
    public class SoundSpectrum implements IEffect
    {
        public const PRIORITY : int = 0;
        private const HALF_PI : Number = Math.PI * .5;
        private static var mapper : Dictionary = new Dictionary(true);
        
        public var size : int;
        public var smoothing : Number;
        public var sampleingRate : uint = 1000/33;
        
        private var shape : IRopeShape;
        private var lastY : Vector.<Number>= new Vector.<Number>();
        private var control_points : int;
        private var result : Point;
        private var effectMask : Vector.<Number>;
        private var isInitialize : Boolean;
        private var left_channnel_spectrum : Vector.<Number>;
        private var custum_amplify : Function;
        private var minimam_watch_spectrum : uint;
        private var maximum_watch_spectrum : uint;
        private var FFT_mode : Boolean;
        private var lastTime : uint;

        private var _hmap : BitmapData;
        public function get hmap() : BitmapData
        {
            return _hmap;
        }

        /**
         * 3~256
         */
        private var _spectrum_partition : int;
        public function get spectrum_partition() : int
        {
            return _spectrum_partition;
        }
        public function set spectrum_partition(spectrum_partition : int) : void
        {
            _spectrum_partition = Math.max(Math.min(256, spectrum_partition), 3);
            
            const currentMapper : SoundSpectrumMapper = mapper[shape] as SoundSpectrumMapper;
            
            mapper[shape] = new SoundSpectrumMapper(_spectrum_partition, minimam_watch_spectrum, maximum_watch_spectrum, FFT_mode);
            
            if (currentMapper)
            {
                mapper[shape].onSound = currentMapper.onSound;
                mapper[shape].onSoundStop = currentMapper.onSoundStop;
            }
        }
        
        public function set onSound(f:Function):void
        {
            SoundSpectrumMapper(mapper[shape]).onSound= f;
        }
        public function set onSoundStop(f:Function):void
        {
            SoundSpectrumMapper(mapper[shape]).onSoundStop = f;
        }

        public function SoundSpectrum(
                            shape:IRopeShape, 
                            size:int, 
                            spectrum_partition : int = 50, 
                            sampleingRate : uint = 1000/60,
                            smoothing:Number = .1, 
                            FFT_mode:Boolean = true,
                            minimam_watch_spectrum :uint = 0,
                            maximum_watch_spectrum : uint = 11008,
                            effectMask:Vector.<Number> = null,
                            custum_amplify:Function = null
                        )
        {
            this.FFT_mode = FFT_mode;
            this.maximum_watch_spectrum = maximum_watch_spectrum;
            this.minimam_watch_spectrum = minimam_watch_spectrum;
            this.shape = shape;
            this.spectrum_partition = spectrum_partition;
            this.sampleingRate = sampleingRate;
            this.size = size;
            this.smoothing = Math.min(1, smoothing);
            this.effectMask = effectMask;
            this.custum_amplify = custum_amplify;
            this.lastTime = getTimer();
        }
        
        private function initialize(model : IRopeShape) : void
        {
            isInitialize = true;
            var cps : Array = model.getControlPoints(),
                 cp : ControlPoint;

            control_points = cps.length;

            for (var i : int = 0; i < control_points; i++)
            {
                cp = cps[i];
                lastY[i] = cp.x;
                lastY[i] = cp.y;
            }
            
            _hmap = new BitmapData(control_points, 1, false, 0);
            result = new Point();
        }

        public function exec(cp : ControlPoint, model:IRopeShape) : Point
        {
            if (this.shape !== model) return cp;
            if (!left_channnel_spectrum) return cp;
            
            const         cpid : int = cp.id - 1,
                   spectrum_id : int = cpid / control_points * _spectrum_partition, 
                             v : Vector2D = Vector2D.createFromPoint(cp, cp.next),
                             a : Number = v.angle - HALF_PI,
                           sin : Number = Math.sin(a), 
                           cos : Number = Math.cos(a);
                           
            var level : Number, // spectrum level -1~1
                 blue : uint,
                green : uint,
                color : Number,
               tgreen : uint,
                tblue : uint,
                   vy : Number,
                   tx : Number,
                   ty : Number,
                    b : Number;
            
            //スペクトラムレベルを取得
            level = left_channnel_spectrum[spectrum_id];
            
            //------------------------
            // update height map
            //------------------------
            level *= 0xFF;
            if (level > 0)
                blue = level;
            else
                green = -level;
                
            color  = _hmap.getPixel(cpid, 0);
            tgreen = (color & 0x00FF00) >> 8;
            tblue  = color & 0x0000FF;
            if (tgreen < green)
            {
                tgreen = tgreen + green * .2;
                tgreen = tgreen > 0xFF ? 0xFF: tgreen;
                color = (color & 0xFF00FF) | (tgreen<<8);
            }
            if ((color & 0x0000FF) < blue)
            {
                tblue = tblue + blue * .2;
                tblue = tblue > 0xFF ? 0xFF : tblue;
                color = (color & 0xFFFF00) | tblue;
            }
            _hmap.setPixel(cpid, 0, color);

            //------------------------
            // decides vertex position
            //------------------------
            //get level from height map. (-1~1)
            level = (color & 0x0000FF) / 0xFF - (((color & 0x00FF00) / 0xFF00));

            //apply amplify.
            if (custum_amplify !== null)
                level = custum_amplify(level);
            
            //calc vertex position
            b = level * size * (effectMask ? effectMask[cpid] : 1);
            tx = cp.x + cos * b;
            ty = cp.y + sin * b; 

            // smoothing if target y is more than current y
//            if (ty - lastY[cpid] < 0)
//                vy = lastY[cpid] + (ty - lastY[cpid]);
//            else
                vy = lastY[cpid] + (ty - lastY[cpid])* smoothing;
            lastY[cpid] = vy;
            
            result.x = cp.x;
            result.y = vy;
            return result;
        }


        public function execLoopStartTask() : void
        {
            if (!left_channnel_spectrum || getTimer()-lastTime > sampleingRate)
            {
                left_channnel_spectrum = SoundSpectrumMapper(mapper[shape]).map();
                lastTime = getTimer();
            }
                
            if (!isInitialize) initialize(shape);
        }
        
        public function execLoopEndTask() : void
        {
            _hmap.colorTransform(_hmap.rect, new ColorTransform(1, 1, 1, 1, 0, -6, -6));
        }

    }
}
