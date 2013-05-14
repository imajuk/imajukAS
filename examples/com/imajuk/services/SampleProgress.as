package com.imajuk.services
{
    import flash.display.StageScaleMode;
    import com.imajuk.interfaces.IProgressView;
    import com.imajuk.logs.Logger;
    import com.imajuk.service.PreLoaderThread;
    import com.imajuk.service.ProgressInfo;
    import com.imajuk.threads.ThreadUtil;

    import org.libspark.thread.Thread;

    import flash.display.DisplayObject;
    import flash.display.Sprite;

    /**
     * @author imajuk
     */
    public class SampleProgress extends Sprite
    {
        public function SampleProgress()
        {
            Logger.release("SampleProgress");
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            /**
             * first client do task1, second client do task2.
             * progress indicates total progress percent.
             */
            
            //------------------------------------------------
            // create Progress View
            //------------------------------------------------
            var progressView:IProgressView = new MyProgressView();

            //------------------------------------------------
            // create ProgressInfo
            //------------------------------------------------
            var progressInfo:ProgressInfo = new ProgressInfo();
            progressInfo.progressView = progressView;
            
            //------------------------------------------------
            // the first task (Load something)
            //------------------------------------------------
            var task1 : Thread = 
                PreLoaderThread.create(
                    "http://imajuk.com/images/rogo.gif", 
                    function(d : DisplayObject) : void
                    {
                        stage.addChild(d);
                    }, 
                    //TODO defaultLoaderの順番は最後がいい
                    null, 
                    progressInfo
                );
                
            //------------------------
            // the second task
            //------------------------
            var task2 : Thread = new SecondTaskThread(progressInfo);
            
            //------------------------
            // do all tasks
            //------------------------
            ThreadUtil.initAsEnterFrame();
            ThreadUtil.serial([task1, task2]).start();
        }
    }
}
import com.imajuk.interfaces.IProgressView;
import com.imajuk.service.AbstractProgressView;

class MyProgressView extends AbstractProgressView implements IProgressView
{
    public function MyProgressView()
    {
        super();
    }
    
    override public function update(progress : Number) : void
    {
        trace(this + " : update " + [progress]);
        super.update(progress);
    }
    
    override public function destroy() : void
    {
    }
}
