package com.imajuk.site
{
    import com.imajuk.interfaces.IProgressView;
    import com.imajuk.service.AbstractProgressView;

    import org.libspark.thread.Thread;

    /**
     * @author shin.yamaharu
     */
    public class ProgressView extends AbstractProgressView implements IProgressView
    {
        internal static var sid : int = 0;
        private var sid : int;

        public function ProgressView(...param)
        {
            this.sid = ProgressView.sid++;
            
            Log.logs += "progressCreated(" + this.sid + ")";
        }
        
        override public function build(...pram):void
        {
        	super.build.apply(null, pram);
            Log.logs += "progressBuilded(" + this.sid + ")";
        }

        override public function show() : Thread
        {
        	Log.logs += "progressShow(" + this.sid + ")";            return new Thread();
        }

        override public function hide() : Thread
        {
        	Log.logs += "progressHide(" + this.sid + ")";
            return new Thread();
        }

        override public function destroy() : void
        {
            Log.logs += "progressDestroyed(" + this.sid + ")";
        }
        
        override public function update(progress:Number):void
        {
        	super.update(progress);
        }
    }
}
