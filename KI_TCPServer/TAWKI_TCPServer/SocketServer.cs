
using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;
using System.Threading;
using System.Text;
using System.Net.Sockets;
using System.Net;

namespace TAWKI_TCPServer
{
    public class SocketServer
    {

        private Socket _serversock;
        private List<SocketClient> _clients;
        private string _address;
        private int _port;
        private Thread _thread;
        private Exception _exception;
        private int _maxConnections;
        // signal object used to signal a close/cancel to thread(s)
        private ManualResetEvent signal_close;
        private int _request_size;

        public SocketServer(int maxConn, int port, int req_size = 6)
        {
            this._maxConnections = maxConn;
            this._port = port;

            signal_close = new ManualResetEvent(false);
            _thread = new Thread(ManageSocket);
            _serversock = new Socket(SocketType.Stream, ProtocolType.Tcp);
            _serversock.ReceiveBufferSize = 256000;
            _request_size = req_size;
            _clients = new List<SocketClient>();
        }
        

        public void Close()
        {
            signal_close.Set();
            // signal close event
            _thread.Join();

            // signal all other threads about close event
            foreach (SocketClient c in _clients)
            {
                c.SignalClose();
                c.JoinThread();
            }
            // wait for the thread to finish
            //CheckForException();
            // check exception and rethrow if necessary
        }

        public void Open()
        {
            _serversock.Bind(new IPEndPoint(IPAddress.Any, _port));
            _address = ((IPEndPoint)_serversock.LocalEndPoint).ToString();
            _thread.Start();
        }

        public string Address()
        {
            return _address;
        }

        private void RestartSocket()
        {
            //Dim ipAddress = Dns.GetHostEntry("localhost").AddressList(0)

            //handle.Bind(New IPEndPoint(IPAddress.Parse(address), port))
            //handle.Bind(New IPEndPoint(ipAddress, port))

            _serversock.Listen(_maxConnections);
        }

        // Runs on seperate thread
        private void ManageSocket()
        {
            RestartSocket();
            // Restarts listening on socket
            // This outer loop manages connection (whether client connects, or loses connection)
            while (!signal_close.WaitOne(1000))
            {
                // Wait for a connection to be made, or for the cancel event to be signaled
                try
                {
                    if (WaitForConnectionEx(signal_close))
                    {
                        Console.WriteLine("Connection Accepted Successfully");
                    }

                    for (int i = _clients.Count - 1; i >= 0; i--)
                    {
                        if (!_clients[i].Connected)
                        {
                            Console.WriteLine("Client connection no longer available - removing from queue");
                            _clients.RemoveAt(i);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Socket Server encountered an error accepting connection: " + ex.Message);
                    break; // TODO: might not be correct. Was : Exit While
                }
            }
        }

        private bool WaitForConnectionEx(ManualResetEvent cancelEvent)
        {
            bool result = false;
            AutoResetEvent connectEvent = new AutoResetEvent(false);
            _serversock.BeginAccept(ar =>
            {
                try
                {
                    SocketClient client = new SocketClient(_serversock.EndAccept(ar), _request_size, _clients.Count);
                    
                    client.Start();
                    _clients.Add(client);
                }
                catch (Exception er)
                {
                    _exception = er;
                }
                connectEvent.Set();
                //return ar;
            }, null);

            // if signal is from index 1 (cancelEvent) then close sock and cancel connection
            if (WaitHandle.WaitAny(new WaitHandle[] {connectEvent,cancelEvent}) == 1)
            {
                _serversock.Close();
                foreach (SocketClient c in _clients)
                {
                    c.SignalClose();
                    c.JoinThread();
                }
            }
            else if (_exception != null)
            {
                Console.WriteLine("Exception encountered during server accepting connection: " + _exception.Message);
                _exception = null;
            }
            else
            {
                result = true;
            }
            return result;
        }

        
    }
}
//=======================================================
//Service provided by Telerik (www.telerik.com)
//Conversion powered by NRefactory.
//Twitter: @telerik
//Facebook: facebook.com/telerik
//=======================================================
