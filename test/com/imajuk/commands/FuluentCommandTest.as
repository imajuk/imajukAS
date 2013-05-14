package com.imajuk.commands
{
    import flash.utils.Dictionary;    
    import flash.events.Event;    
    import flash.utils.setTimeout;    
    import flash.display.*;

    import org.libspark.as3unit.after;
    import org.libspark.as3unit.assert.*;
    import org.libspark.as3unit.before;
    import org.libspark.as3unit.test;
    use namespace test;
    use namespace before;
    use namespace after;
    internal class FuluentCommandTest extends Sprite
    {
        private var check:String;        private var check2:int;
        private var previous_sync:Function;
        private var after_sync:Function;
        private var after_sync2:Function;
        private var asyncPrevious:AbstractAsyncCommandMock;
        private var asyncPrevious2:AbstractAsyncCommandMock;
        private var after_sync3:Function;
        private var after_sync4:Function;
        private var closeAfter3Times:Function;
        private var _reference:Dictionary;

        before function setup():void
        {
            var c:int = 0;
            var c2:int = 9;
            var c3:int = 49;
            var c4:int = 99;
            var counter:Function = function():String
            {
                return String(++c) + " ";
            };
            var counter2:Function = function():String
            {
                return String(++c2) + " ";
            };
            var counter3:Function = function():String
            {
                return String(++c3) + " ";
            };
            var counter4:Function = function():String
            {
                return String(++c4) + " ";
            };
            check = "";
            check2 = 999;
            closeAfter3Times = function():void
            {
                check2++;
                
                dispatchEvent(new Event(Event.COMPLETE));
                
                if (check2 == 1002)                    dispatchEvent(new Event(Event.CLOSE));
            };
            previous_sync = function():void
            {                check += counter();
            };
            after_sync = function():void
            {
                check += counter2();
            };
            after_sync2 = function():void
            {
                check += counter3();
            };
            after_sync3 = function(s:String):void
            {
                check += s + " ";
            };
            after_sync4 = function(s1:String, s2:String):void
            {
                check += s1 + " " + s2 + " ";
            };
            asyncPrevious = new AbstractAsyncCommandMock(function():void
            {
                check += counter();
            });
            asyncPrevious2 = new AbstractAsyncCommandMock(function():void
            {
                check += counter4();
            });
        }

        /**
         * 流れるインターフェイス
         * 
         * //Viewがhide()されたときに一度だけコマンドを実行する.
         * FuluentCommand.when(currentImage.hideen).Do(currentImage.show);
         * 
         * 		//View.hidden
         * 		public function get hidden():ViewHiddingCOmmand
         * 		{
         * 			return new ViewHiddingCommand(this);
         * 		}
         * 
         * //Viewがhide()されたときはいつでもコマンドを実行する.
         * FuluentCommand.when(currentImage.hideen).always().do(currentImage.show);
         * 
         * //Viewをhide()して一度だけコマンドを実行する.
         * FuluentCommand
         * 		.when(currentImage.hideen).Do(new Command(currentImage.show))
         * .execute();
         * 
         * //Viewをhide()してコマンドを実行する.このコマンドは、以後このViewがhide()されるたびに実行される
         * FuluentCommand
         * 		.when(currentImage.hideen).always().Do(new Command(currentImage.show))
         * .execute();
         */

        test function sync_define_once():void
        {
            //同期（リスナの定義のみで後から実行）
            //一度だけ、doする
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
            				.Do(after_sync)
            .create();
            
            cmd.execute();
            cmd.execute();
            cmd.execute();
            
            assertEquals("1 10 2 3 ", check);
        }

        test function sync_define_execution_once():void
        {
            //同期コマンドcmdが実行された時は、一度だけdoする.
            //（リスナの定義と実行）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd).Do(after_sync).execute();
            cmd.execute();
            assertEquals("1 10 2 ", check);
                    
            //もう一度、FuluentCommandの実行
            FuluentCommand.when(cmd).Do(after_sync).execute();
            assertEquals("1 10 2 3 11 ", check);
        }

        test function sync_define_execution_once_multipleDo():void
        {
            //同期コマンドcmdが実行された時は、一度だけdoする.
            //（リスナの定義と実行、doすることが複数）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
                    				.Do(after_sync)
                    				.Do(after_sync)
                    .execute();
            cmd.execute();
            assertEquals("1 10 11 2 ", check);
        			
            //もう一度、FuluentCommandの実行
            FuluentCommand.when(cmd)
                    				.Do(after_sync)
                    				.Do(after_sync)
                    .execute();
            assertEquals("1 10 11 2 3 12 13 ", check);
        }

        test function sync_define_execution_always():void
        {
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（リスナの定義と実行）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
                    				.Do(after_sync).always()
                   	.execute();
            cmd.execute();
            assertEquals("1 10 2 11 ", check);
        }

        test function sync_define_execution_always_multipleDo():void
        {
            var answer:String = "";
                	
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（リスナの定義と実行、doすることが複数）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
                    				.Do(after_sync).always()
                    				.Do(after_sync2).always()
                    				//完全に重複した定義は無視
                    				.Do(after_sync).always()
                    .execute();
            cmd.execute();
            answer = "1 50 10 2 51 11 ";
            assertEquals(answer, check);
                    
            check = "";
        }

        //alywaysとoneceの混在
        test function sync_define_execution_mix_multiple1():void
        {
            var answer:String = "";
            var cmd3:Command = new Command(previous_sync);
            FuluentCommand.when(cmd3)
                    				.Do(after_sync).always()
                    				.Do(after_sync2)
                    .execute();
            cmd3.execute();
            answer = "1 10 50 2 11 ";
            assertEquals(answer, check);
        }

        test function sync_define_execution_mix_multiple2():void
        {
            var answer:String = "";
                	
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（リスナの定義と実行、doすることが複数）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
                    				.Do(after_sync).always()
                    				.Do(after_sync2).always()
                    				//重複した定義はオプションを上書き
                    				.Do(after_sync)
                    .execute();
            cmd.execute();
            answer = "1 50 10 2 51 ";
            assertEquals(answer, check);
        }

        test function sync_define_always():void
        {
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（リスナの定義のみで後から実行）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
            				.Do(after_sync).always()
            .create();
            
            cmd.execute();
            cmd.execute();
            assertEquals("1 10 2 11 ", check);
        }

        test function sync_define_once_multipleDo():void
        {
            //同期コマンドcmdが実行された時は、一度だけdoする.
            //（リスナの定義と実行、doすることが複数）
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
            				.Do(after_sync)
            				.Do(after_sync)
            .create();
            
            cmd.execute();
            cmd.execute();
            assertEquals("1 10 11 2 ", check);
			
            //もう一度、FuluentCommandの実行
            FuluentCommand.when(cmd)
            				.Do(after_sync)
            				.Do(after_sync)
            .create();
            
            cmd.execute();
            assertEquals("1 10 11 2 3 12 13 ", check);
        }

        
        test function async_define_execution_once():void
        {
            //非同期コマンドasyncPreviousが実行されたとき、一度だけdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> after_sync -> after_sync
            FuluentCommand.when(asyncPrevious).Do(after_sync).execute();
            FuluentCommand.when(asyncPrevious).Do(after_sync).execute();
            asyncPrevious.execute();
                    
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 10 11 ", check);
            }), 2000);
        }

        test function async_define_execution_once_multiple():void
        {
            //非同期コマンドasyncPreviousが実行されたとき、一度だけdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> after_sync -> after_sync2
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync)
                    				.Do(after_sync2)
                    .execute();
            asyncPrevious.execute();
                    
            setTimeout(async(function():void
            {
                assertEquals("1 2 10 50 ", check);
            }), 2000);
        }

        
        test function async_define_execution_always():void
        {
            //非同期コマンドasyncPreviousが実行されたときはいつでもdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> after_sync -> after_sync
            FuluentCommand.when(asyncPrevious).Do(after_sync).always().execute();
            //このように違う場所で同じように呼び出される可能性もある
            FuluentCommand.when(asyncPrevious).Do(after_sync).always().execute();
            asyncPrevious.execute();
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 10 11 12 ", check);
            }), 2000);
        }

        test function async_define_execution_always_multiple():void
        {
            //非同期コマンドasyncPreviousが実行されたときはいつでもdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> asyncPrevious -> 
            //			after_sync -> after_sync2 -> after_sync -> after_sync2 -> after_sync -> after_sync2
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync).always()
                    				.Do(after_sync2).always()
                    .execute();
                    
            //このように違う場所で同じように呼び出される可能性もある
            //asyncPreviousは実行されるが、doは重複して実行はされない
            FuluentCommand.when(asyncPrevious).Do(after_sync).always().execute();
            asyncPrevious.execute();
                    
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 50 10 51 11 52 12 ", check);
            }), 2000);
        }

        test function async_define_execution_mix_multiple1():void
        {
            //混在
            //実行順　：　asyncPrevious　-> asyncPrevious -> asyncPrevious -> after_sync -> after_sync2 -> after_sync -> after_sync2
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync)
                    				.Do(after_sync2).always()
                    .execute();
                    
            //このように違う場所で同じように呼び出される可能性もある
            //asyncPreviousは実行されるが、doは重複して実行はされない
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync2).always()
                   	.execute();
            asyncPrevious.execute();
                    
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 10 50 51 52 ", check);
            }), 2000);
        }

        test function async_define_execution_mix_multiple2():void
        {
            //混在
            //実行順　：　asyncPrevious　-> asyncPrevious -> asyncPrevious -> after_sync -> after_sync2
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync)
                    				.Do(after_sync2).always()
                    .execute();
                    
            //このように違う場所で同じように呼び出される可能性もある
            //コマンドasyncPreviousは実行され、doは上書きされる（after_sync2のalways属性がonceに上書き）
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync2)
                   	.execute();
            asyncPrevious.execute();
                    
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 10 50 ", check);
            }), 2000);
        }

        test function async_define_always():void
        {
            //非同期コマンドasyncPreviousが実行されたときはいつでもdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> asyncAfter -> asyncAfter
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync).always()
                    .create();
            //このように違う場所で同じように呼び出される可能性もある
            //これは完全に重複しているので無視されるべき.
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync).always()
                    .create();
                    
            asyncPrevious.execute();
            asyncPrevious.execute();
            asyncPrevious.execute();
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 10 11 12 ", check);
            }), 2000);
        }

        test function async_define_always2():void
        {
            //非同期コマンドasyncPreviousが実行されたときはいつでもdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> asyncAfter -> asyncAfter
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync).always()
                    .create();
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync2).always()
                    .create();
                    
            asyncPrevious.execute();
            asyncPrevious.execute();
            asyncPrevious.execute();
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 10 50 11 51 12 52 ", check);
            }), 2000);
        }

        test function async_define_always_multiple():void
        {
            //非同期コマンドasyncPreviousが実行されたときはいつでもdoする
            //実行順　：　asyncPrevious　-> asyncPrevious -> asyncAfter -> asyncAfter
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync).always()
                    				.Do(after_sync2).always()
                    .create();
                    		
            //このように違う場所で同じように呼び出される可能性もある
            //これは完全に重複しているので無視されるべき.
            FuluentCommand.when(asyncPrevious)
                    				.Do(after_sync).always()
                    .create();
                    
            asyncPrevious.execute();
            asyncPrevious.execute();
            asyncPrevious.execute();
            setTimeout(async(function():void
            {
                assertEquals("1 2 3 50 10 51 11 52 12 ", check);
            }), 2000);
        }

        test function nest_sync_async():void
        {
            var cmd:Command = new Command(previous_sync);
            FuluentCommand.when(cmd)
            				.Do(after_sync).always()
            				.Do(FuluentCommand.when(asyncPrevious2)
	        										.Do(after_sync).always()
	        										.Do(after_sync2).always()).always()
            				.Do(after_sync2)
            .create();

            cmd.execute();
            asyncPrevious2.execute();
            
            setTimeout(async(function():void
            {
                assertEquals("1 10 50 100 11 51 ", check);
            }), 2000);
        }

        test function nest_async_async():void
        {
            FuluentCommand.when(asyncPrevious)
            				.Do(after_sync).always()
            				.Do(FuluentCommand.when(asyncPrevious2)
	            										.Do(after_sync).always()
	            										.Do(after_sync2).always()).always()
            				.Do(after_sync2)
            .create();

            asyncPrevious.execute();
            asyncPrevious2.execute();
            
            setTimeout(async(function():void
            {
                assertEquals("1 100 10 50 11 51 ", check);
            }), 2000);
        }

        test function passArguments():void
        {
            FuluentCommand.when(asyncPrevious)
            				.Do(after_sync3, "A").always()            				.Do(function(i:int):void
				            {
				                check += String(i) + " ";
				            }, 9)
            				.Do(after_sync4, "B", "C")
            .create();

            asyncPrevious.execute();            asyncPrevious.execute();
            
            setTimeout(async(function():void
            {
                assertEquals("1 2 A 9 B C A ", check);
            }), 2000);
        }

        test function sync_always_withEventCommand():void
        {
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（前提コマンドにEventCommandを使用、終了条件なし）
            var cmd:Command = new Command(previous_sync);
            var eCmd:EventCommand = new EventCommand(cmd, Event.COMPLETE);
            
            FuluentCommand.when(eCmd)
                                    .Do(after_sync).always()
                    .create();
                    
            cmd.execute();            cmd.execute();
            assertEquals("1 10 2 11 ", check);
        }
        
        test function sync_always_withEventCommand_withFinishing():void
        {
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（前提コマンドにEventCommandを使用、終了条件あり）
            var cmd:Command = new Command(closeAfter3Times);
            var eCmd:EventCommand = new EventCommand(this, Event.COMPLETE, Event.CLOSE);
            
            //ガベージコレクトテスト
            _reference = new Dictionary(true);
            _reference[eCmd] = true;
            
            FuluentCommand.when(eCmd)
                                    .Do(after_sync).always()
                    .create();
                    
            cmd.execute();//1000
            cmd.execute();//1001            cmd.execute();//1002            cmd.execute();//1003
            //closeAfter3Timesは4回実行されるが、
            assertEquals(1003, check2);
            //after_syncは3回しか実行されないはず.
            assertEquals("10 11 12 ", check);
        }
        
        test function sync_always_withEventCommand_canNot_execution():void
        {
            //同期コマンドcmdが実行された時は、いつでもdoする.
            //（when()にEventCommandを渡す場合は、execute()できない。create()のみ）
            var cmd:Command = new Command(previous_sync);
            var eCmd:EventCommand = new EventCommand(cmd, Event.COMPLETE);
            
            try
            {
                FuluentCommand.when(eCmd)
                                        .Do(after_sync).always()
                        .execute();
                cmd.execute();
                fail();
            }
            catch(e:Error)
            {
            	assertEquals("前提コマンド（when()に渡すコマンド）がEventCommandの場合はexecute()できません。create()を使用して下さい.", e.message);
            }
        }
        
         /**
         * TODO waitの実装
         *  FuluentCommand.when(behavior.isComplete)
                            .Do(trace, "behavior complete ", application.initialized, getTimer())
                            .wait(50)
                            .Do(function():void
                                {
                                    if (closure != null)
                                          closure();
                                    finish();
                                })
                          .create();
         */
        
    }
}