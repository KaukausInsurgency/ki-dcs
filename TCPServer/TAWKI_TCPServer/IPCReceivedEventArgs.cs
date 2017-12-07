
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO.Pipes;
using System.Net.Sockets;

namespace TAWKI_TCPServer
{
    public class IPCReceivedEventArgs : System.EventArgs
    {
        private Socket _shandle;

        private string _data;
        public string data
        {
            get { return _data; }
            set { _data = value; }
        }

        public Socket shandle
        {
            get { return _shandle; }
        }

        public IPCReceivedEventArgs(Socket handleID, string data)
            : base()
        {
            _data = data;
            _shandle = handleID;
        }
    }
}
//=======================================================
//Service provided by Telerik (www.telerik.com)
//Conversion powered by NRefactory.
//Twitter: @telerik
//Facebook: facebook.com/telerik
//=======================================================
