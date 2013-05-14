package com.imajuk.date 
{
    import com.imajuk.data.IIterator;    

    /**
     * カレンダーに関する機能を提供します。
     *               メソッドは、カレンダー共通の静的メソッドと、<br>
     *               ある年の月をターゲットにしたカレンダーインスタンスのメソッドが実装されています。
     *               カレンダーインスタンスは、そのカレンダー上の仮想的な位置を表す仮想ヘッダを持っています。
     * @author yamaharu
     */
    public class Calendar 
    {
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        private static const MONTH_EN_1:String = "January";        private static const MONTH_EN_2:String = "February";
        private static const MONTH_EN_3:String = "March";        private static const MONTH_EN_4:String = "April";        private static const MONTH_EN_5:String = "May";        private static const MONTH_EN_6:String = "June";        private static const MONTH_EN_7:String = "July";        private static const MONTH_EN_8:String = "August";        private static const MONTH_EN_9:String = "September";        private static const MONTH_EN_10:String = "October";        private static const MONTH_EN_11:String = "November";        private static const MONTH_EN_12:String = "December";

        private static const DAY_JP_1:String = "日";
        private static const DAY_JP_2:String = "月";
        private static const DAY_JP_3:String = "火";
        private static const DAY_JP_4:String = "水";
        private static const DAY_JP_5:String = "木";
        private static const DAY_JP_6:String = "金";
        private static const DAY_JP_7:String = "土";

        private static const DAY_EN_1:String = "sun";
        private static const DAY_EN_2:String = "mon";
        private static const DAY_EN_3:String = "tue";
        private static const DAY_EN_4:String = "wed";
        private static const DAY_EN_5:String = "thu";
        private static const DAY_EN_6:String = "fri";
        private static const DAY_EN_7:String = "sat";

        private static const monthName:Array = [ MONTH_EN_1,
                                                    MONTH_EN_2,
                                                    MONTH_EN_3,
                                                    MONTH_EN_4,
                                                    MONTH_EN_5,
                                                    MONTH_EN_6,
                                                    MONTH_EN_7,
                                                    MONTH_EN_8,
                                                    MONTH_EN_9,
                                                    MONTH_EN_10,
                                                    MONTH_EN_11,
                                                    MONTH_EN_12 ];

        private static const dayNameJP:Array = [ DAY_JP_1, DAY_JP_2, DAY_JP_3, DAY_JP_4, DAY_JP_5, DAY_JP_6, DAY_JP_7 ];
        private static const dayNameEN:Array = [ DAY_EN_1, DAY_EN_2, DAY_EN_3, DAY_EN_4, DAY_EN_5, DAY_EN_6, DAY_EN_7 ];
        private static const DAYTIME:Number = 24 * 60 * 60 * 1000;
        public static const LANG_JP:String = "jp";
        public static const LANG_EN:String = "LANG_EN";

        //--------------------------------------------------------------------------
        //
        //  Class properties
        //
        //--------------------------------------------------------------------------

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------
        
        /** 曜日を表す文字列を返します
         * @param   曜日を表す0-6の数値
         * @param   Calendar.LANG_EN または　Calendar.LANG_JP
         * @return  Calendar.LANG_ENを渡すと英語表記、Calendar.LANG_JPを渡すと日本語表記で曜日を返します。
         * @usage   trace(Calendar.getDayString(0, Calendar.LANG_EN));
         *          trace(Calendar.getDayString(2, Calendar.LANG_JP));
         *          //output
         *          sun
         *          火
         */
        public static function getDayString(dayIndex:int, lang:String = LANG_EN):String
        {
            var dList:Array;
            switch(lang)
            {
                case LANG_EN:
                    dList = dayNameEN;
                    break;
                case LANG_JP:
                    dList = dayNameJP;
                    break;
                default:
                    dList = dayNameEN;
            }
            return dList[dayIndex];
        }

        /**
         * 月を表す文字列を返します
         * @param   月を表す文字列を知りたい日付
         * @return  月を表す文字列を英語表記で返します。
         * @usage   trace(Calendar.getMonthString(0));
         *          trace(Calendar.getMonthString(1));
         *          //output
         *          January
         *          February
         */
        public static function getMonthAsEnglishString(date:Date, shortFrom:Boolean = false):String
        {
            var mString:String = monthName[date.month];
            return (shortFrom) ? mString.substr(0, 3) : mString;
        }

        /**
         * 二つの日付が同じかどうかを返します<br>
         * 時間は考慮しません
         * @param   ターゲトとなる日付
         * @param   ターゲトとなる日付
         * @return  二つの日付が同じ日かどうか
         */
        public static function equals(__d1:Date, __d2:Date):Boolean
        {
            return (
                __d1.getFullYear() == __d2.getFullYear() && __d1.getMonth() == __d2.getMonth() && __d1.getDate() == __d2.getDate()
                );      
        }

        /**
         * 渡された日付の月が、何日あるかを返します
         * @param   その月が何日あるか調べたい日付
         * @return  日数を数値で返します
         */
        public static function getLastDayOfMonth(date:Date):Number
        {
            var result:Number;
            switch(date.month)
            {
                case 1:
                    result = isLeapYear(date) ? 29 : 28;
                    break;
                case 3:
                case 5:
                case 8:
                case 10:
                    result = 30;
                    break;
                default:
                    result = 31;
                    break;      
            }
            return result;
        }

        /**
         * 仮想ヘッダのある月が、何日あるかを返します
         * @param   その月が何日あるか調べたい日付
         * @return  日数を数値で返します
         */
        public function getLastDayOfMonth():Number
        {
            return Calendar.getLastDayOfMonth(header);
        }

        /**
         * 渡された日付の年が閏年かどうかを返します
         * @param   閏年かどうかを知りたい日付
         * @return  閏年かどうかをBooleanで返します
         */
        public static function isLeapYear(date:Date):Boolean
        {
            //西暦年が4で割り切れる年は閏年とする。
            //西暦年が4で割り切れる年のうち、100で割り切れる年は閏年としない。
            //西暦年が4で割り切れ、100でも割り切れる年のうち、400で割り切れる年は閏年とする
            var year:Number = date.getFullYear();
            var byFour:Boolean = (year % 4 == 0);
            var byHandred:Boolean = (year % 100 == 0);
            var byFourHandred:Boolean = (year % 400 == 0);
            return (byFour && !byHandred) || (byFour && byHandred && byFourHandred);
        }

        /**
         * 渡された日付の月が何週間あるか返します
         * @param   何週間あるか知りたい月（0-11）<br>
         *          省略した場合は今月（システムのローカル時間による）が何週間あるかを調べます
         * @return  何週間あるかを数値で返します
         */
        public static function getWeekLength(date:Date):int
        {
            //渡された月の一日を生成する
            date = new Date(date.getFullYear(), date.month, 1);
            //1日の曜日を調べる
            var day:Number = date.getDay();
        
            //渡された月が何日あるか調べる
            var thisMonthDate:Number = Calendar.getLastDayOfMonth(date);
        
            //計算して結果を返す
            var result:int = Math.ceil((day + thisMonthDate) / 7);

            return result;
        }

        /**
         * 渡された日付の1日前の日を返します<br>
         * @param   ターゲットとなる日付
         * @return  ターゲットの1日前の日
         */
        public static function getYesterday(targetDate:Date):Date
        {
            return new Date(targetDate.getTime() - DAYTIME);
        }

        /**
         * 渡された日付の次の日を返します<br>
         * @param   ターゲットとなる日付
         * @return  ターゲットの次の日
         */
        public static function getTomorrow(targetDate:Date):Date
        {
            return new Date(targetDate.getTime() + DAYTIME);
        }

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function Calendar(date:Date = null)
        {
            create(date);     
        }

        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------

        private var _header:Date;
        private var _week:Array;

        //--------------------------------------------------------------------------
        //
        //  properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * 仮想ヘッダの日付を返します.
         * @return  現在の仮想ヘッダの日付
         */
        public function get header():Date
        {
            return _header;
        }

        /**
         * 仮想ヘッダの1日前の日を返します<br>
         * 仮想ヘッダを1日前に移動するにはpreviousDay()メソッドを使用します。
         * @return 仮想ヘッダの1日前の日
         */
        public function get yesterday():Date
        {
            return new Date(_header.getTime() - DAYTIME);
        }

        /**
         * 仮想ヘッダの次の日を返します<br>
         * 仮想ヘッダを1日進めるにはnextDay()メソッドを使用します。
         * @return 仮想ヘッダの次の日
         */
        public function get tomorrow():Date
        {
            return new Date(_header.getTime() + DAYTIME);
        }

        /**
         * 仮想ヘッダの1ヶ月前の日を返します 
         * このメソッドでは仮想ヘッダは移動しません。<br>
         * 仮想ヘッダを1ヶ月戻すにはgotoPreviousMonth()メソッドを使用します。
         */
        public function get previousMonth():Date
        {
            return new Date(_header.getFullYear(), _header.getMonth() - 1, _header.getDate());
        }

        /**
         * 仮想ヘッダの1ヶ月後を返します 
         * このメソッドでは仮想ヘッダは移動しません。<br>
         * 仮想ヘッダを1ヶ月戻すにはgotoNextMonth()メソッドを使用します。
         */
        public function get nextMonth():Date
        {
            return new Date(_header.getFullYear(), _header.getMonth() + 1, _header.getDate());
        }

        /**
         * 仮想ヘッダのある月の1日の日付を返します.
         * 仮想ヘッダを1日の日付に移動するにはgotoFirstDayThisMonth()メソッドを使用します。
         */
        public function get firstDay():Date
        {
            return new Date(_header.getFullYear(), _header.getMonth(), 1);
        }

        /**
         * 仮想ヘッダのある月が何週間あるか返します
         * @param   何週間あるか知りたい月（0-11）<br>
         *          省略した場合は仮想ヘッダがある月を調べます
         * @return  何週間あるかを数値で返します
         */
        public function get weekLength():Number
        {
            return getWeekLength(_header);
        }

        //--------------------------------------------------------------------------
        //
        //  Methods: discription
        //
        //--------------------------------------------------------------------------

        public function toString():String
        {
            return output();
        }

        /**
         * 仮想ヘッダのある月の、任意の週の第1日目を返します。
         * @param   第1日目を知りたい週のインデックス（0ベース。1週目は0になります）
         * @return  その週の第1日目.
         *          渡された週が存在しない場合はnullを返します.
         *          例えば、2007年8月の第6週の最初の日を取得しようとした場合はnullを返します.
         */
        public function getFirstDayInWeek(weekIndex:int):Date
        {
            if (weekIndex < _week.length)
                return _week[weekIndex][0];
            else
                return null;
        }

        /**
         * 仮想ヘッダのある月の、任意の週の最後の日を返します。
         * @param   現在のカレンダーの最後の日を知りたい週のインデックス（0ベース。1週目は0になります）
         * @return  その週の最後の日
         *          渡された週が存在しない場合はnullを返します.
         *          例えば、2007年8月の第6週の最後の日を取得しようとした場合はnullを返します.
         */
        public function getLastDayInWeek(weekIndex:Number):Date
        {
            if (weekIndex < _week.length)
            {
                var w:Array = _week[weekIndex]; 
                return w[w.length - 1];
            }
            else
            {
                return null;
            }
        }

        /**
         * 仮想ヘッダのある月の、渡された日が含まれる週のインデックスを返します.
         * @param   どの週にあるか探したい日（日にち）
         * @return  その日が含まれる週のインデックスを数値で返します<br>
         *          インデックスは0ベースです。第1週は0になります。<br>
         *          存在しない日にちを渡した場合例外を投げます.
         */
        public function getWeekIndex(date:int):int
        {
            var m:Number = _header.getMonth();
            var wLength:Number = getWeekLength(_header);
            for(var i:int = 0;i < wLength; i++)
            {
                for(var j:int = 0;j < 7; j++)
                {
                    var d:Date = _week[i][j];
                    if(d.getDate() == date && d.getMonth() == m) return i;
                }
            }
            
            throw new Error("存在しない日にちが渡されました.");
            return NaN;
        }

        /**
         * カレンダーインスタンスの仮想グリッド上にある特定の日付を返します
         * @param   仮想グリッドの列のインデックス（0ベース 0-6）
         * @param   仮想グリッドの行のインデックス（0ベース）
         * @return  仮想グリッド上の日付
         */
        public function getDateInMatrix(col:Number, row:Number):Date
        {
            return _week[row][col];
        }

        /**
         * 仮想ヘッダを一日前に戻し、その日の日付を返します
         * @return  仮想ヘッダ移動後の日付         */
        public function gotoPreviousDay():Date
        {
            updateCalendar(yesterday);
            return _header;
        }

        /**         * 仮想ヘッダを1日進め、その日の日付を返します.
         * @return  仮想ヘッダ移動後の日付         */
        public function gotoNextDay():Date
        {
            updateCalendar(tomorrow);
            return _header;
        }

        /**         * 仮想ヘッダを1ヶ月前に戻し、その日の日付を返します
         * @return  仮想ヘッダ移動後の日付         */
        public function gotoPreviousMonth():Date
        {
            updateCalendar(previousMonth);
            return _header;       
        }

        /**         * カレンダーの仮想ヘッダを1ヶ月進め、その日の日付を返します
         * @return  仮想ヘッダ移動後の日付
         */
        public function gotoNextMonth():Date
        {
            updateCalendar(nextMonth);
            return _header;       
        }

        /**
         * 仮想ヘッダのある月の最初の日に、仮想ヘッダを移動します
         */
        public function gotoFirstDayThisMonth():Date
        {
            updateCalendar(firstDay);
            return _header;     
        }

        /**
         * 初期化
         * @param   生成するカレンダーの仮想ヘッダの位置<br>
         *          省略した場合はこのメソッドが呼ばれたときのシステムの日付が仮想ヘッダとなります
         * @return  生成されたカレンダーインスタンス
         */
        private function create(date:Date = null):Calendar
        {
            _header = date || new Date();
            _week = [];
        
            //このカレンダーが始まる最初の日を取得
            var first:Date = getFirstDateMyCalender();
            var wLength:Number = getWeekLength(_header);
            for(var i:int = 0;i < wLength; i++)
            {
                var cols:Array = new Array();
                for(var j:int = 0;j < 7; j++)
                {
                    cols.push(new Date(first.getTime()));
                    first.setTime(first.getTime() + DAYTIME);
                }
                _week.push(cols);
            }
            return this;
        }

        /**
         * このカレンダーが始まる最初の日を返す
         */ 
        private function getFirstDateMyCalender():Date
        {
            //todayをコピー
            var d:Date = new Date(_header.getTime());
            d.setDate(1);
            return new Date(d.getTime() - ( DAYTIME * d.getDay()));
        }

        /**
         * カレンダーを出力
         */  
        private function output():String
        {
            var result:String = "\n----------" + [ _header.getFullYear(),(_header.getMonth() + 1) ] + "-------------\n";
            for(var i:int = 0;i < _week.length; i++)
            {
                for(var j:int = 0;j < _week[i].length; j++)
                {
                    result += _week[i][j].getDate() + " ";
                }
                result += "\n";
            }
            result += "-------------------------\n";
            return result;
        }

        /**
         * カレンダーをアップデートする
         */
        private function updateCalendar(date:Date):void
        {
            create(date);
        }

        /**
         * 仮想ヘッドの月の1日から最後の日までのイテレータを返す.
         */
        public function thisMonthAllIterator():IIterator
        {
            return new MonthIterator(this);
        }
    }
}

import com.imajuk.data.IIterator;import com.imajuk.date.Calendar;

class MonthIterator implements IIterator
{
    private var calendar:Calendar;
    private var pos:int = 0;

    public function MonthIterator(calendar:Calendar) 
    {
        this.calendar = calendar;
        calendar.gotoFirstDayThisMonth();
        calendar.gotoPreviousDay();
    }

    public function hasNext():Boolean
    {
        return !((pos > 0) && calendar.header.date == calendar.getLastDayOfMonth());
    }

    public function next():*
    {
        pos ++;
        return calendar.gotoNextDay();
    }

    public function get position():int
    {
        return pos;
    }
}
