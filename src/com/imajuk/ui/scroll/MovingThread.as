﻿package com.imajuk.ui.scroll{    import org.libspark.thread.Thread;    /**     * @author shin.yamaharu     */    public class MovingThread extends Thread     {        private var target:IScrollContainer;        private var destination:int;        public function MovingThread(target:IScrollContainer, destination:int)        {            super();            this.destination = destination;            this.target = target;        }        override protected function run():void        {            if (isInterrupted)        	   return;        	               target.content.y += (destination - target.content.y) * .2;                        if (Math.abs(target.content.y - destination) <= 1)            {                target.content.y = destination;                return;            }                        next(run);        }        override protected function finalize():void        {        }    }}