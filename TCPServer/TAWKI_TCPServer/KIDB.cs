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
        public const Int64 LUANULL = -9999;        // THIS IS IMPORTANT - CHANGING THIS WILL BREAK IF THE LUA NIL PLACEHOLDER IS NOT THE SAME!!!
        public const string ACTION_GET_SERVERID = "GetOrAddServer";
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

        public static ProtocolResponseSingleData SendToDBSingleData(string log, string action, string ip_address, dynamic j)
        {
            // serialize a new json string for just the data by itself
            string jdataString = Newtonsoft.Json.JsonConvert.SerializeObject(j["Data"]);
            // now deserialize this string into a list of dictionaries for parsing
            Dictionary<string, object> dataDictionary = null;

            if (((JToken)j["Data"]).Type == JTokenType.Object)
                dataDictionary = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, object>>(jdataString);
            else
                dataDictionary = new Dictionary<string, object>();

            // special scenario - because we cant get the ip address of the game server from DCS, we'll get it from the socket sender object
            // and specially insert it as a parameter into the data dictionary
            if (action == ACTION_GET_SERVERID)
            {
                dataDictionary.Add("IP", ip_address);
            }
            
            ProtocolResponseSingleData result = new ProtocolResponseSingleData();
            result.Action = action;
            result.Error = "";
            result.Data = new List<object>();

            MySql.Data.MySqlClient.MySqlConnection _conn = null;
            MySql.Data.MySqlClient.MySqlDataReader rdr = null;

            try
            {
                _conn = new MySql.Data.MySqlClient.MySqlConnection(DBConnection);
                _conn.Open();
                MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(action);
                cmd.Connection = _conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                foreach (var d in dataDictionary)
                {
                    if (d.Value.GetType() == typeof(Int64) && (Int64)d.Value == LUANULL)
                        cmd.Parameters.AddWithValue(d.Key, null);
                    else
                        cmd.Parameters.AddWithValue(d.Key, d.Value);                 
                }
                rdr = cmd.ExecuteReader();
                if (rdr.Read())
                {
                    for (int i = 0; i < rdr.FieldCount; i++)
                    {
                        result.Data.Add(rdr[i]);
                    }
                }

                rdr.Close();
                _conn.Close();
            }
            catch (Exception ex)
            {
                LogToFile("Error executing query against MySQL (Action: " + action + ") - " + ex.Message, log);
                result.Error = "Error executing query against MySQL (Action: " + action + ") - " + ex.Message;
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

        public static ProtocolResponseMultiData SendToDBMultiData(string log, string action, dynamic j)
        {

            // serialize a new json string for just the data by itself
            string jdataString = Newtonsoft.Json.JsonConvert.SerializeObject(j["Data"]);
            // now deserialize this string into a list of dictionaries for parsing
            List<Dictionary<string, object>> dataDictionary = 
                Newtonsoft.Json.JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(jdataString);

            ProtocolResponseMultiData result = new ProtocolResponseMultiData();
            result.Action = action;
            result.Error = "";
            result.Data = new List<List<object>>();

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
                        if (kv.Value.GetType() == typeof(Int64) && (Int64)kv.Value == LUANULL)
                             cmd.Parameters.AddWithValue(kv.Key, null);
                        else
                            cmd.Parameters.AddWithValue(kv.Key, kv.Value);
                    }
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        List<object> result_set = new List<object>();
                        for (int i = 0; i < rdr.FieldCount; i++)
                        {
                            result_set.Add(rdr[i]);
                        }
                        result.Data.Add(result_set);
                    }
                    else
                    {
                        result.Error += "No Results Returned\n";
                    }
                    rdr.Close();
                    _conn.Close();            
                }
            }
            catch (Exception ex)
            {
                LogToFile("Error executing query against MySQL (Action: " + action + ") - " + ex.Message, log);
                result.Error = "Error executing query against MySQL (Action: " + action + ") - " + ex.Message;
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
                if (j["Action"] != null && j["BulkQuery"] != null && j["Data"] != null)
                {
                    string action = j["Action"];
                    bool isBulkQuery = j["BulkQuery"];   
                    if (isBulkQuery)
                    {
                        ProtocolResponseMultiData resp = SendToDBMultiData(((SocketClient)(sender)).LogFile, action, j);
                        if (!string.IsNullOrWhiteSpace(resp.Error))
                            resp.Result = false;
                        else
                            resp.Result = true;

                        string jsonResp = JsonConvert.SerializeObject(resp);
                        ((SocketClient)(sender)).Write(jsonResp);
                    }
                    else
                    {
                        ProtocolResponseSingleData resp = SendToDBSingleData(((SocketClient)(sender)).LogFile, action, ((SocketClient)(sender)).Address, j);
                        if (!string.IsNullOrWhiteSpace(resp.Error))
                            resp.Result = false;
                        else
                            resp.Result = true;

                        string jsonResp = JsonConvert.SerializeObject(resp);
                        ((SocketClient)(sender)).Write(jsonResp);
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
                string jsonResponse = "{ \"Action\" : \"UNKNOWN\", \"Result\" : false, \"Error\" : \"Malformed JSON Request Received\", \"Data\" : null }";
                ((SocketClient)(sender)).Write(jsonResponse);
            }
            finally
            {
                //SocketClient.SyncEnd();
            }
        }

        public static void OnSend(object sender, IPCSendEventArgs e)
        {
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
