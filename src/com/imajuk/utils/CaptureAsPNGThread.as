package com.imajuk.utils
{
    import co.uk.mikestead.net.URLFileVariable;
    import co.uk.mikestead.net.URLRequestBuilder;
    import com.adobe.images.PNGEncoder;
    import com.bit101.components.PushButton;
    import com.imajuk.data.LinkList;
    import com.imajuk.data.LinkListNode;
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.SecurityErrorEvent;
    import flash.geom.Matrix;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    import org.libspark.thread.Thread;




    /**
     * @author shinyamaharu
     */
    public class CaptureAsPNGThread extends Thread
    {
        private var imgWidth : int;
        private var imgHeight : int;
        private var canvas : BitmapData;
        private var target : IBitmapDrawable;
        private var rowdata : LinkList = new LinkList();
        private var seq : LinkList = new LinkList();
        private var n : LinkListNode;
        private var c : int;
        private var frame : int;
        private var matrix : Matrix;
        private var button : PushButton;
        private var destination : String;
        private var phpPath : String;

        public function CaptureAsPNGThread(
                            target    : IBitmapDrawable, 
                            imgWidth  : int, 
                            imgHeight : int, 
                            frame     : int, 
                            matrix    : Matrix = null,
                            destination : String = "/Library/WebServer/Documents/seq/",
                            phpPath     : String = "http://localhost/CaptureAsPNG.php"
                        )
        {
            super();

            this.imgWidth = imgWidth;
            this.imgHeight = imgHeight;
            this.target = target;
            this.frame = frame;
            this.matrix = matrix || new Matrix();
            this.destination = destination;
            this.phpPath = phpPath;
        }

        override protected function run() : void
        {
            next(draw);
        }

        private function draw() : void
        {
            canvas = new BitmapData(imgWidth, imgHeight, false, 0xFFFFFF);
            canvas.draw(target, matrix, null, null, null, true);
            rowdata.push(canvas);

            if (rowdata.length > frame)
            {
                n = rowdata.first;
                c = 0;
                encode();
            }
            else
            {
                next(draw);
            }

            trace('capture frame: ' + (rowdata.length));
        }

        private function encode() : void
        {
            var b : ByteArray = PNGEncoder.encode(BitmapData(n.data));
            seq.push(b);
            n = n.next;
            
            trace("encoded frame:" + seq.length);

            if (n)
            {
                next(encode);
            }
            else
            {
                n = seq.first;
                next(save);
            }
        }

        private function save() : void
        {
            trace("uploading images to " + phpPath + ", click button to start.");

            button = new PushButton(StageReference.stage, 0, 0, "post");
            event(button, MouseEvent.CLICK, startSave);
        }

        private function startSave(...param) : void
        {
            // Create variables to send off to server
            var variables : URLVariables = new URLVariables(),
                params:Object = getParams();
            for (var prop : String in params)
                variables[prop] = params[prop];
                
                
            ObjectUtil.dump(params);
            
            // Build the multipart encoded request and set the url of where to send it
            var request : URLRequest = new URLRequestBuilder(variables).build();
            request.method = URLRequestMethod.POST;
            request.url = phpPath;

            // Create the loader and transmit the request
            var loader : URLLoader = new URLLoader();
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e : Event) : void
            {
                trace("SecurityError.");
            });
            loader.addEventListener(IOErrorEvent.IO_ERROR, function(e : Event) : void
            {
                trace("IO_ERROR.");
            });
            loader.addEventListener(Event.COMPLETE, function() : void
            {
                trace(loader.data);
            });
            loader.load(request);
        }
        
        private function getParams() : Object
        {
            var o:Object = {
                dir: destination
            };
            var c:int;
            
            while(n)
            {
                o["file"+(c++).toString()] = new URLFileVariable(n.data, "seq" + c + ".png");
                n = n.next;
            }
            
            return o;
        }

        override protected function finalize() : void
        {
        }
    }
}
