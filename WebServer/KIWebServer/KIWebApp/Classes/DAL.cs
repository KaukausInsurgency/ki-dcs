using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KIWebApp.Models;
using MySql.Data;
using MySql.Data.MySqlClient;
using System.Data;

namespace KIWebApp.Classes
{
    public class DAL : IDAL
    {
        private const string SP_GET_SERVERS = "websp_GetServersList";
        private const string SP_GET_ONLINEPLAYERS = "websp_GetOnlinePlayers";
        private string _DBConnection;

        public DAL()
        {
            _DBConnection = System.Configuration.ConfigurationManager.ConnectionStrings["DBMySqlConnect"].ConnectionString;
        }

        List<AirportModel> IDAL.GetAirports(int serverID)
        {
            throw new NotImplementedException();
        }

        List<CapturePointModel> IDAL.GetCapturePoints(int serverID)
        {
            throw new NotImplementedException();
        }

        List<DepotModel> IDAL.GetDepots(int serverID)
        {
            throw new NotImplementedException();
        }

        GameModel IDAL.GetGame(int serverID)
        {
            throw new NotImplementedException();
        }

        GameMapModel IDAL.GetGameMap(int serverID)
        {
            throw new NotImplementedException();
        }

        List<MapLayerModel> IDAL.GetMapLayers(int mapID)
        {
            throw new NotImplementedException();
        }

        List<OnlinePlayerModel> IDAL.GetOnlinePlayers(int serverID)
        {
            List<OnlinePlayerModel> players = new List<OnlinePlayerModel>();
            using (MySqlConnection conn = new MySqlConnection(_DBConnection))
            {
                conn.Open();
                MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_ONLINEPLAYERS);
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
                MySqlDataReader rdr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(rdr);

                foreach (DataRow dr in dt.Rows)
                {

                    OnlinePlayerModel player = new OnlinePlayerModel
                    {
                        UCID = dr.Field<string>("UCID"),
                        Name = dr.Field<string>("Name"),
                        Role = dr.Field<string>("Role"),
                        RoleImage = dr.Field<string>("RoleImage"),
                        Side = dr.Field<int>("Side") == 1? "Red": "Blue",
                        Ping = dr.Field<string>("Ping")
                    };
                    players.Add(player);
                }
            }

            return players;
        }

        List<ServerModel> IDAL.GetServers()
        {
            List<ServerModel> servers = new List<ServerModel>();
            using (MySqlConnection conn = new MySqlConnection(_DBConnection))
            {
                conn.Open();
                MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_SERVERS);
                cmd.Connection = conn;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                MySqlDataReader rdr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(rdr);

                foreach (DataRow dr in dt.Rows)
                {
                    TimeSpan rt;
                    if (dr["RestartTime"] == DBNull.Value || dr["RestartTime"] == null)
                    {
                        rt = new TimeSpan(0, 0, 0);
                    }
                    else
                    {
                        rt = new TimeSpan(TimeSpan.TicksPerSecond * dr.Field<int>("RestartTime"));
                    }

                    string status = "Offline";
                    string img = "Images/status-red-128x128.png";
                    if (dr["Status"] != DBNull.Value && dr["Status"] != null)
                    {
                        status = dr.Field<string>("Status");
                        if (status.ToUpper() == "ONLINE")
                            img = "Images/status-green-128x128.png";
                        else if (status.ToUpper() == "OFFLINE")
                            img = "Images/status-red-128x128.png";
                        else
                            img = "Images/status-yellow-128x128.png";
                    }

                    ServerModel server = new ServerModel
                    {
                        ServerID = dr.Field<int>("ServerID"),
                        ServerName = dr.Field<string>("ServerName"),
                        IPAddress = dr.Field<string>("IPAddress"),
                        Status = status,
                        StatusImage = img,
                        RestartTime = rt,
                        OnlinePlayers = Convert.ToInt32(dr.Field<long>("OnlinePlayers"))
                    };
                    servers.Add(server);
                }
            }

            return servers;
        }
    }
}