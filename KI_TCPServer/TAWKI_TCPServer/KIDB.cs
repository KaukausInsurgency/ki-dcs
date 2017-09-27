using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft;
using Newtonsoft.Json;
using MySql.Data;
using System.IO;
using Newtonsoft.Json.Linq;
using MySql.Data.MySqlClient;

namespace TAWKI_TCPServer
{
    class KIDB
    {
        public static string DBConnection = "";

        public static void Invoke(ISynchronizeInvoke sync, Action action)
        {
            if (!sync.InvokeRequired)
            {
                action();
            }
            else
            {
                object[] args = new object[] { };
                sync.Invoke(action, args);
            }
        }

        public static Tuple<object, string> SendToDB(string log, string action, bool isBulkInsert, 
                                                     List<Dictionary<string, object>> dataDictionary)
        {
            Tuple<object, string> result = null;
            MySql.Data.MySqlClient.MySqlConnection _conn = null;
            MySql.Data.MySqlClient.MySqlDataReader rdr = null;
            try
            {
                

                foreach (var d in dataDictionary)
                {
                    _conn = new MySql.Data.MySqlClient.MySqlConnection(DBConnection);
                    _conn.Open();
                    MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(action);
                    cmd.Connection = _conn;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    foreach (var kv in d)
                    {
                        cmd.Parameters.AddWithValue(kv.Key, kv.Value);
                    }
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                        result = new Tuple<object, string>(rdr[0], "");
                    else
                        result = new Tuple<object, string>(null, "No results returned");
                    rdr.Close();
                    _conn.Close();
                    
                }

            }
            catch (Exception ex)
            {
                LogToFile("Error executing query against MySQL (Action: " + action + ") - " + ex.Message, log);
                Console.WriteLine("Problem Encountered Sending Data to DB " + ex.Message);
                result = new Tuple<object, string>(null, "Error executing query against MySQL (Action: " + action + ") - " + ex.Message);
            }
            finally
            {
                if (_conn != null)
                    if (_conn.State == System.Data.ConnectionState.Open || _conn.State == System.Data.ConnectionState.Connecting)
                        _conn.Close();

                if (rdr != null)
                    if (!rdr.IsClosed)
                        rdr.Close();
            }
            
            return result;
        }

        public static void OnConnect(object sender, IPCConnectedEventArgs e)
        {
            Console.WriteLine("Client has connected: " + e.address);
            LogToFile("Client has connected: " + e.address, e.logpath);
        }

        public static void OnDisconnect(object sender, IPCConnectedEventArgs e)
        {
            Console.WriteLine("Client has disconnected: " + e.address);
            LogToFile("Client has disconnected: " + e.address, e.logpath);
        }

        public static void OnReceived(object sender, IPCReceivedEventArgs e)
        {
            //SocketClient.SyncBegin();
            try
            {
                string _logFilePath = ((SocketClient)(sender)).LogFile;
                LogToFile(e.data, _logFilePath);
                Console.WriteLine("Received data from client (" + ((SocketClient)(sender)).Address + ")");

                dynamic j = Newtonsoft.Json.JsonConvert.DeserializeObject(e.data);

                // Verify the request format is valid
                if (j["Action"] != null && j["BulkInsert"] != null && j["Data"] != null)
                {
                    // serialize a new json string for just the data by itself
                    string jdataString = Newtonsoft.Json.JsonConvert.SerializeObject(j["Data"]);
                    // now deserialize this string into a list of dictionaries for parsing
                    List<Dictionary<string, object>> jdict = 
                        Newtonsoft.Json.JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(jdataString);

                    string action = j["Action"];
                    bool bulkInsert = j["BulkInsert"];

                    Tuple<object, string> result = SendToDB(((SocketClient)(sender)).LogFile, action, bulkInsert, jdict);

                    if (result.Item1 == null)
                    {
                        string jsonResponse = "{ \"Action\" : " + j["Action"] + ", \"Result\" : false, \"Error\" : \"" + result.Item2 + "\", \"Data\" : null }";
                        ((SocketClient)(sender)).Write(jsonResponse);
                    }
                    else
                    {
                        string jsonResponse = "{ \"Action\" : " + j["Action"] + ", \"Result\" : true, \"Error\" : \"\", \"Data\" : " + result.Item1 + " }";
                        ((SocketClient)(sender)).Write(jsonResponse);
                    }
                }
                else
                {
                    // send malformed request response
                    string jsonResponse = "{ \"Action\" : " + j["Action"] + ", \"Result\" : false, \"Error\" : \"Malformed Request Received\", \"Data\" : null }";
                    ((SocketClient)(sender)).Write(jsonResponse);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception encountered during OnReceived handler: " + ex.Message);
                LogToFile("Exception encountered during OnReceived handler: " + ex.Message, ((SocketClient)(sender)).LogFile);
            }
            finally
            {
                //SocketClient.SyncEnd();
            }
        }

        public static void OnSend(object sender, IPCSendEventArgs e)
        {
            Console.WriteLine("Sent data to client");
            LogToFile("Server Sent: " + e.data, ((SocketClient)(sender)).LogFile);
        }

        public static void LogToFile(string data, string path)
        {
            if (!File.Exists(path))
            {
                // Create a file to write to.
                using (StreamWriter sw = File.CreateText(path))
                {
                    sw.WriteLine(DateTime.Now.ToString("{0:d/M/yyyy HH:mm:ss}") + " - Log File for client");
                    sw.WriteLine(DateTime.Now.ToString("{0:d/M/yyyy HH:mm:ss}") + data);
                   // sw.WriteLine(data);
                }
            }
            else
            {
                using (StreamWriter sw = File.AppendText(path))
                {
                    sw.WriteLine(DateTime.Now.ToString("{0:d/M/yyyy HH:mm:ss}") + data);
                    //sw.WriteLine(data);
                }
            }
        }
    }
}
