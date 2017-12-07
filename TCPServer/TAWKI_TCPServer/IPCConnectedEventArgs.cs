
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
    public class IPCConnectedEventArgs : System.EventArgs
    {
        private Socket _handleSock;

        private string _address = "";

        private string _logfile = "";

        public string address
        {
            get { return _address; }
            set { _address = value; }
        }

        public string logpath
        {
            get { return _logfile; }
        }

        public Socket shandle
        {
            get { return _handleSock; }
        }

        public IPCConnectedEventArgs(Socket sockID, string address, string log = "")
            : base()
        {
            _handleSock = sockID;
            _address = address;
            _logfile = log;
        }
    }
}
//=======================================================
//Service provided by Telerik (www.telerik.com)
//Conversion powered by NRefactory.
//Twitter: @telerik
//Facebook: facebook.com/telerik
//=======================================================
