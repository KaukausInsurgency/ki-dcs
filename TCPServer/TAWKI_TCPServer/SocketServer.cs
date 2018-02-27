
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
        private List<string> _whitelist_clients;

        public SocketServer(int maxConn, int port, List<string> whitelist, int req_size = 6)
        {
            this._maxConnections = maxConn;
            this._port = port;
            this._whitelist_clients = whitelist;
            signal_close = new ManualResetEvent(false);
            _thread = new Thread(ManageSocket);
            _serversock = new Socket(SocketType.Stream, ProtocolType.Tcp);
            _serversock.ReceiveBufferSize = 256000;
            _serversock.NoDelay = true;
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
            while (!signal_close.WaitOne(100))
            {
                // Wait for a connection to be made, or for the cancel event to be signaled
                try
                {
                    string connect_msg = "";
                    if (WaitForConnectionEx(signal_close, ref connect_msg))
                    {
                        Console.WriteLine(connect_msg);
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

        private bool WaitForConnectionEx(ManualResetEvent cancelEvent, ref string message)
        {
            bool result = false;
            string connect_msg = "";
            AutoResetEvent connectEvent = new AutoResetEvent(false);
            _serversock.BeginAccept(ar =>
            {
                try
                {
                    SocketClient client = new SocketClient(_serversock.EndAccept(ar), _request_size);
                    
                    bool is_valid = false;

                    if (_whitelist_clients != null)
                    {
                        foreach (string valid_ip in _whitelist_clients)
                        {
                            if (client.Address == valid_ip)
                            {
                                is_valid = true;
                                break;
                            }
                        }
                    }
                    else
                        is_valid = true;
                    

                    if (!is_valid)
                    {
                        connect_msg = "Unknown client tried to connect (Address: " + client.Address + ") - this address is not whitelisted - dropping";
                        client.Dispose();
                    }
                    else if (_clients.Count >= _maxConnections)
                    {
                        connect_msg = "A client tried to connect, but the maximum number of clients allowed (Count: " + _maxConnections + ") has been exceeded";
                        client.Dispose();
                    }
                    else
                    {
                        connect_msg = "Connection Accepted Successfully";
                        client.Start();
                        _clients.Add(client);
                    }          
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
            message = connect_msg;
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
