package com.imajuk.graphics
{
    import com.imajuk.data.LinkList;
    import com.imajuk.data.LinkListNode;
    import com.imajuk.logs.Logger;

    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.Dictionary;


    /**
     * @author imajuk
     */
    public class LiquidLayout
    {
        private static var isInitialized : Boolean;
        private static var stage : Stage;
        private static var task_align : LinkList = new LinkList();
        private static var task_fit : LinkList = new LinkList();
        private static var task_custum : LinkList = new LinkList();
        private static var task_before_fit : LinkList = new LinkList();
        private static var wrapperToTask : Dictionary = new Dictionary(true);
        public static const BEFORE_FIT : String = "BEFORE_FIT";

        //--------------------------------------------------------------------------
        //  Static API
        //--------------------------------------------------------------------------
        /**
         * 整列タスクを登録します.
         * @see Align
         */
        public static function align(align : Align) : LinkListNode
        {
            if (!isInitialized)
                throw new Error("LiquidLayout must be initialized.");

            var n:LinkListNode = task_align.push(align);
            
            return n;
        }
        
        /**
         * 整列タスクを削除します.
         * @see Align
         */
        public static function removeAlign(align : LinkListNode) : void
        {
        	task_align.remove(align);
        }

        /**
         * LiquidLayoutクラスを初期化します.
         * LiquidLayoutクラスは仕様前に必ず一度だけ初期化する必要があります.
         * 初期化をせずに使用しようとした場合例外が発生します.
         */
        public static function initialize(stage:Stage) : void
        {
        	if (isInitialized)
        	   return;
        	   
            isInitialized = true;

            LiquidLayout.stage = Fit.stage = Fit_Keep_Ratio.stage = stage;
            LiquidLayout.stage.addEventListener(Event.RESIZE, resizeHandler);
        }
        
        /**
         * 登録されたタスクをすべて実行します.
         * タスクは、before fit closure -> fit -> align -> closure の順で実行されます.
         */
        public static function layout() : void
        {
            var n:LinkListNode;
            
            //=================================
            // custom tasks
            //=================================
            n = task_before_fit.first;
            while(n)
            {
                n.data();
                n = n.next;
            }
            
            //=================================
            // fit to stage
            //=================================
            n = task_fit.first;
            while(n)
            {
                IFit(n.data).execute();
                n = n.next;
            }
            
            //=================================
            // align
            //=================================
            n = task_align.first;
            while(n)
            {
                try
                {
                    Align(n.data).execute();
                }
                catch(e:Error)
                {
                    Logger.warning("alignに失敗しました.[REASON]" + e.message);
                }
                n = n.next;
            }
            
            //=================================
            // custom tasks
            //=================================
            n = task_custum.first;
            while(n)
            {
                n.data();
                n = n.next;
            }
        }

        /**
         * ターゲットをステージにフィットするように変形する
         * 以後、ステージが変更された時更新される.
         * このタスクをキャンセルするにはメソッドの戻り値を引数にLiquidLayout.removeFit()を呼び出します.
         * 
         * @param target            対象となるDisplayObject
         * @param direction         水平方向と垂直方向どちらか、または両方で変形を指定します.
         *                          有効な値は以下の通りです.
         *                          
         *                          以下の値はDisplayObjectの縦横比が変更されます.
         *                          
         *                          Direction.HORIZON :                         ステージの水平方向に隙間が出来なくなるまでDisplayObjectを水平方向にスケールします.
         *                          Direction.VERTICAL :                        ステージの垂直方向に隙間が出来なくなるまでDisplayObjectを垂直方向にスケールします.
         *                          Direction.BOTH :                            ステージの水平方向および垂直方向に隙間が出来なくなるまでDisplayObjectをスケールします.
         *                  
         *                          以下の値はDisplayObjectの縦横比を保ったままスケールします.
         *                  
         *                          AspectRatio.KEEP_ASPECT_INSIDE_RECTANGLE :  ステージの水平方向または垂直方向どちらかに隙間が出来なくなるまでDisplayObjectをスケールします.
         *                                                                      DisplayObjectとステージのアスペクト比が一致しない場合はステージ内に隙間が出来ます.<br/>
         *                          AspectRatio.KEEP_ASPECT_OVER_RECTANGLE :    ステージの水平方向および垂直方向どちらにも隙間が出来なくなるまでDisplayObjectをスケールします.
         *                                                                      DisplayObjectとステージのアスペクト比が一致しない場合はDisplayObjectの縦横いずれかがステージ外にはみだします.
         *                          AspectRatio.KEEP_ASPECT_FILL_HORIZON :      ステージの水平方向に隙間が出来なくなるまでDisplayObjectをスケールします.
         *                                                                      DisplayObjectとステージのアスペクト比が一致しない場合はDisplayObjectの縦がステージ外にはみだすか隙間が出来ます.
         *                              
         */
        public static function fitToStage(target : DisplayObject, direction : String, fixingPosition:Boolean = true, ...margins_TRBL:Array) : LinkListNode
        {
            if (!stage)
                throw new Error("LiquidLayout must be initialized.");

            var task : LinkListNode = 
                task_fit.push(
                    direction == AspectRatio.KEEP_ASPECT_INSIDE_RECTANGLE || 
                    direction == AspectRatio.KEEP_ASPECT_OVER_RECTANGLE || 
                    direction == AspectRatio.KEEP_ASPECT_FILL_HORIZON ? 
                        new Fit_Keep_Ratio(target, direction, fixingPosition) : 
                        new Fit(target, direction, margins_TRBL, fixingPosition)
                );
            
            return task;
        }
        
        /**
         * ステージフィットタスクを削除します.
         * 削除に成功した場合はtrueを、失敗した場合はfalseを返します
         */
        public static function removeFit(task : LinkListNode) : Boolean
        {
            var n : LinkListNode = task_fit.first,
                res : Boolean = false;
            while (n)
            {
                if (task === n)
                {
                    task_fit.remove(task);
                    res = true;
                }
                n = n.next;
            }

            return res;
        }

        /**
         * ステージがリサイズされたときに実行するタスクを登録します
         * このタスクはステージがリサイズされた後初めて画面がレンダリングされる直前に実行されます
         */
        public static function resisterTask(task : Function, ...parameters) : Function
        {
            var collection:LinkList = task_custum;
            var order:String = parameters[0] as String;
            if (order)
            {
                switch(order)
                {
                    case LiquidLayout.BEFORE_FIT:
                        parameters.shift();
                        collection = task_before_fit;
                        break;
                }
            }
            
        	var f:Function = function() : void
            {
                task.apply(null, parameters);
            };
            
            collection.push(f);
            wrapperToTask[f] = task; 
            
            return f;
        }
        
        public static function removeTask(task : Function) : void
        {
        	var n:LinkListNode,
                f:Function;
                
            n = task_custum.first;
        	while(n)
        	{
                f = n.data;
        		if (wrapperToTask[f] === task)
        		{
        			task_custum.remove(n);
        			wrapperToTask[f] = null;
        		}
        		n = n.next;
        	}
            
            n = task_before_fit.first;
            while(n)
            {
                f = n.data;
                if (wrapperToTask[f] === task)
                {
                    task_before_fit.remove(n);
                    wrapperToTask[f] = null;
                }
                n = n.next;
            }
        }
        
        //--------------------------------------------------------------------------
        //  Event Handler
        //--------------------------------------------------------------------------
        private static function resizeHandler(event : Event) : void
        {
           stage.removeEventListener(Event.RENDER, renderHandler);
           stage.addEventListener(Event.RENDER, renderHandler);
        }

        private static function renderHandler(event : Event) : void
        {
           stage.removeEventListener(Event.RENDER, renderHandler);
           layout();
        }
    }
}
import com.imajuk.constants.Direction;
import com.imajuk.constructions.DocumentClass;
import com.imajuk.utils.DisplayObjectUtil;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.display.StageAlign;

interface IFit
{
    function execute() : void;
}

class Fit implements IFit
{
    public static var stage : Stage;
    private var target : DisplayObject;
    private var initW : Number;
    private var direction : String;
    private var margin : Array;
    private var fixingPosition : Boolean;

    public function Fit(target : DisplayObject, direction : String, margins_TRBL : Array, fixingPosition : Boolean)
    {
        this.target = target;
        this.direction = direction;
        this.margin = [];
        this.fixingPosition = fixingPosition;
        
        var sx : Number = target.scaleX,
            i : int = 0;
        
        for (i = 0; i < 4; i++) {
            margin.push(margins_TRBL[i] || 0);
        }

        target.scaleX = 1;
        initW = target.width;
        target.scaleX = sx;
    }

    public function execute() : void
    {
        var w : int = (stage.stageWidth - initW) >> 1;
        
        switch (direction)
        {
            case Direction.HORIZON:
                if (fixingPosition) target.x = -w;
                target.width = stage.stageWidth - (margin[0] + margin[1]);
                break;
            case Direction.VERTICAL:
                if (fixingPosition) target.y = 0;
                target.height = stage.stageHeight;
                break;                
            case Direction.BOTH:
                if (fixingPosition) 
                {
                    target.x = (stage.align == StageAlign.TOP) ? -w : 0;
                    target.y = 0;
                }
                target.width = stage.stageWidth;
                target.height = stage.stageHeight;
                break;                
        }
    }
}

class Fit_Keep_Ratio implements IFit
{
    public static var stage : Stage;
    private var target : DisplayObject;
    private var keepAspectRatio : String;
    private var fixingPosition : Boolean;

    public function Fit_Keep_Ratio(target : DisplayObject, keepAspectRatio : String, fixingPosition : Boolean)
    {
        this.target = target;
        this.keepAspectRatio = keepAspectRatio;
        this.fixingPosition = fixingPosition;
    }

    public function execute() : void
    {
        DisplayObjectUtil.fitToRectangle(target, stage.stageWidth, stage.stageHeight, keepAspectRatio);
        
        if (!fixingPosition) return;
        
        if (stage.align == StageAlign.TOP)
        {
            target.x = (DocumentClass.swfWidth - stage.stageWidth) >> 1;
            if (target.width > stage.stageWidth)
                target.x += (stage.stageWidth-target.width) >> 1;
            target.y = 0;
        }
    }
}
