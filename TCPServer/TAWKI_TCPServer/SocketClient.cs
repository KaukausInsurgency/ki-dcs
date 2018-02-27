using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TAWKI_TCPServer
{
    public class SocketClient : IDisposable
    {
        private Socket _clientsock;
        private string _address;
        private int _request_size;
        private Thread _thread;
        private SockBuffer _buffer;     // the actual received data
        private SockBuffer _req_buffer; // returns the size of the request to be sent
        private Exception _ex;
        private static Mutex _mut = new Mutex();
        private string _logPath;
        private static string _heartBeatResponse;
        // Determines whether a connection exists
        private bool _connected = false;
        // signal object used to signal a close/cancel to thread(s)
        private ManualResetEvent signal_close;
        // signal object used to signal a read event to thread(s)
        private ManualResetEvent signal_read;
        // signal object used to signal a write event to thread(s)
        private ManualResetEvent signal_write;

        public event ConnectedEventEventHandler ConnectedEvent;
        public delegate void ConnectedEventEventHandler(object sender, IPCConnectedEventArgs e);
        public event DisconnectedEventEventHandler DisconnectedEvent;
        public delegate void DisconnectedEventEventHandler(object sender, IPCConnectedEventArgs e);
        public event ReceivedEventEventHandler ReceivedEvent;
        public delegate void ReceivedEventEventHandler(object sender, IPCReceivedEventArgs e);
        public event SendEventEventHandler SendEvent;
        public delegate void SendEventEventHandler(object sender, IPCSendEventArgs e);

        public SocketClient(Socket s, int request_size, string log = "")
        {
            _clientsock = s;
            _address = ((IPEndPoint)_clientsock.RemoteEndPoint).Address.ToString();
            _thread = new Thread(ManageSocket);
            _connected = true;
            _request_size = request_size;
            _req_buffer = new SockBuffer(_request_size);
            signal_close = new ManualResetEvent(false);
            signal_read = new ManualResetEvent(false);
            signal_write = new ManualResetEvent(false);
            if (string.IsNullOrWhiteSpace(log))
            {
                log = Directory.GetCurrentDirectory();
            }
            this._logPath = log + "\\" + DateTime.Now.ToString("yyyyMMdd") + "_client_" + _address.Replace('.','_').Replace(":","_") + ".log";
            this.ConnectedEvent += KIDB.OnConnect;
            this.DisconnectedEvent += KIDB.OnDisconnect;
            this.SendEvent += KIDB.OnSend;
            this.ReceivedEvent += KIDB.OnReceived;
            // raise the connected event
            ConnectedEvent(_clientsock, new IPCConnectedEventArgs(_clientsock, _address, _logPath));
        }

        public void Start()
        {
            _thread.Start();
        }

        public static void SyncBegin()
        {
            _mut.WaitOne();
        }

        public static void SyncEnd()
        {
            _mut.ReleaseMutex();
        }

        public static void SetHeartBeatResponse(string heartbeat)
        {
            _heartBeatResponse = heartbeat;
        }

        public void JoinThread()
        {
            if (_thread.IsAlive)
            {
                _thread.Join();
            }
        }

        public void SignalClose()
        {
            signal_close.Set();
        }

        public void Dispose()
        {
            if (_clientsock != null)
            {
                //if (_clientsock.
                _clientsock.Close();
            }
        }

        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }

        public string LogFile
        {
            get { return _logPath; }
        }

        public Socket Client
        {
            get { return _clientsock; }
        }

        public bool Connected
        {
            get { return _connected; }
        }

        // Runs on seperate thread
        private void ManageSocket()
        {
                // Inner loop manages send/response
            while ((!signal_close.WaitOne(50)) & _connected)
            {
                try
                {
                    SocketError errorCode = 0;
                    IAsyncResult readResult = _clientsock.BeginReceive(_req_buffer.BufferByte, 0, _req_buffer.Size, SocketFlags.None, out errorCode, this.HandleReceive, null);

                    // if signal is from index 1 (signal_close) then close stream and cancel connection
                    if (WaitHandle.WaitAny(new WaitHandle[] { signal_read, signal_close }) == 1)
                    {
                        _buffer.Clear();
                        _clientsock.Shutdown(SocketShutdown.Both);
                        _clientsock.Close();
                        //_connected = false;
                        break; // TODO: might not be correct. Was : Exit While
                    }

                    // HandleRead will either raise the received event, or the disconnect event
                    if (!_connected)
                    {
                        _clientsock.Shutdown(SocketShutdown.Both);
                        _clientsock.Close();
                        //_clientsock.Disconnect(true);
                        signal_read.Reset();
                        // reset signal read to false (deactivate event)
                        break; // TODO: might not be correct. Was : Exit While
                    }

                    signal_read.Reset();
                    // reset signal read to false (deactivate event)

                }
                catch (Exception ex)
                {
                    _ex = ex;
                    if (_clientsock.Connected)
                    {
                        _clientsock.Shutdown(SocketShutdown.Both);
                        _clientsock.Close();
                    }
                        //_clientsock.Disconnect(true);

                    _connected = false;

                    break; // TODO: might not be correct. Was : Exit While
                }
            }
        }

        // BeginRead callback
        private void HandleReceive(IAsyncResult ar)
        {
            int numBytes = 0;
            _buffer = null;
            try
            {
                // end read returns number of bytes read
                numBytes = _clientsock.EndReceive(ar);

                if (numBytes > 0 && numBytes == _request_size)
                {

                    int req_size = -1;
                    if (!int.TryParse(_req_buffer.Decode(numBytes), out req_size))
                    {
                        throw new Exception("Client request is corrupted");
                    }
                    if (req_size > 0)
                    {
                        _buffer = new SockBuffer(req_size);
                        int num_bytes_request = 0;
                        int time_out = 0;   // 15 seconds
                       
                        while (_clientsock.Available < req_size)
                        {
                            if (time_out >= 15000)
                            {
                                throw new Exception("The timeout period elapsed while waiting for the client to finish sending data - the client has either disconnected or failed to send a complete message");
                            };
                            Thread.Sleep(50);
                            time_out += 50;
                        }

                        num_bytes_request += _clientsock.Receive(_buffer.BufferByte, 0, _buffer.Size, SocketFlags.None);

                    }
                }
                else if (numBytes > 0 && numBytes < _request_size)
                {
                    // drop this received data, it is probably garbage
                }
                else
                {
                    throw new Exception("Server did not receive any data from client");
                }
            }
            catch (Exception ex)
            {
                _ex = ex;
            } 
            if (_ex != null)
            {
                Console.WriteLine("Error encountered during reading client data: " + _ex.Message);
                if (DisconnectedEvent != null)
                {
                    DisconnectedEvent(this, new IPCConnectedEventArgs(_clientsock, _address, _logPath));
                }
                // raise disconnected event
                _connected = false;
            }
            else if (_buffer != null)
            {
                if (ReceivedEvent != null)
                {
                    ReceivedEvent(this, new IPCReceivedEventArgs(_clientsock, _buffer.Decode(_buffer.Size)));
                }
                // raise received event
            }
            signal_read.Set();
            //return ar;
        }

        // BeginSend callback
        private void HandleSend(IAsyncResult ar)
        {
            try
            {
                _clientsock.EndSend(ar);
                if (SendEvent != null)
                {
                    SendEvent(this, new IPCSendEventArgs(_clientsock, _buffer.OriginalData));
                }
            }
            catch (Exception ex)
            {
                _ex = ex;
            }
            signal_write.Set();
            //return ar;
        }

        private void CheckForException()
        {
            // Exception not null
            if ((_ex != null))
            {
                throw _ex;
            }
        }

        public void Write(string msg)
        {
            string nmsg = string.Format("{0:D6}", msg.Length) + msg;
            //string nmsg = msg;
            _buffer.Clear();
            _buffer = new SockBuffer(nmsg.Length);
            _buffer.Encode(nmsg);
            _buffer.OriginalData = nmsg;
            try
            {
                _clientsock.BeginSend(_buffer.BufferByte, 0, _buffer.BufferByte.Length, SocketFlags.None, HandleSend, null);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception encountered while attempting to send data to client - " + ex.Message);
                signal_close.Set();
            }
            if (WaitHandle.WaitAny(new WaitHandle[] { signal_write, signal_close }) == 1)
            {
                _clientsock.Shutdown(SocketShutdown.Both);
                _clientsock.Close();
                return;
            }
            // reset signal write to false (deactivate event)
            signal_write.Reset();
        }

    }
}
