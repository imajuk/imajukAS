package com.imajuk.logs
{
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;

    /**
     * @author imajuk
     */
    public class ExternalTrace implements IOutput
    {
        public static const CONNECTION_NAME : String = "ex";
        private var connection : LocalConnection = new LocalConnection();

        public function ExternalTrace()
        {
            connection.addEventListener(StatusEvent.STATUS, onStatus);
        }

        private function onStatus(event : StatusEvent) : void
        {
            switch (event.level)
            {
                case "status":
                    trace("LocalConnection.send() succeeded");
                    break;
                case "error":
                    trace("LocalConnection.send() failed");
                    break;
            }
        }

        public function log(string : String) : void
        {
            connection.send(CONNECTION_NAME, "log", string);

        }
    }
}
