package com.imajuk.commands {
    import com.imajuk.commands.ICommand;        import com.imajuk.commands.AbstractAsyncCommand;    import com.imajuk.commands.IAsynchronousCommand;import flash.utils.setTimeout;    /**
     * @author yamaharu
     */
    public class AbstractAsyncCommandMock extends AbstractAsyncCommand implements IAsynchronousCommand     {
        public function AbstractAsyncCommandMock(closure:Function, ...param)        {
            super(closure, param);
        }                override public function execute():ICommand        {            super.execute();                        //このコマンドは1秒後に終了する            setTimeout(finish, 1000);            return this;        }            }
}
