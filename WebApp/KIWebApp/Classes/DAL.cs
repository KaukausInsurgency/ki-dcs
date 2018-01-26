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
        private const string SP_GET_GAMEMAP = "websp_GetGameMap";
        private const string SP_GET_LAYERS = "websp_GetGameMapLayers";
        private const string SP_GET_DEPOTS= "websp_GetDepots";
        private const string SP_GET_CAPTUREPOINTS = "websp_GetCapturePoints";
        private const string SP_GET_GAME = "websp_GetGame";
        private const string SP_GET_SIDEMISSIONS = "websp_GetSideMissions";
        private const string SP_SEARCH_PLAYERS = "websp_SearchPlayers";
        private const string SP_SEARCH_SERVERS = "websp_SearchServers";
        private string _DBConnection;
       
        public DAL()
        {
            _DBConnection = System.Configuration.ConfigurationManager.ConnectionStrings["DBMySqlConnect"].ConnectionString;
        }

        public DAL(string connection)
        {
            _DBConnection = connection;
        }

        List<CapturePointModel> IDAL.GetCapturePoints(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetCapturePoints(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        List<CapturePointModel> IDAL.GetCapturePoints(int serverID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();
            List<CapturePointModel> capturepoints = new List<CapturePointModel>();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_CAPTUREPOINTS);
            cmd.Connection = conn;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                string cpText = "";
                if (dr["Text"] != DBNull.Value && dr["Text"] != null)
                    cpText = dr.Field<string>("Text");

                CapturePointModel capturepoint = new CapturePointModel
                {
                    ID = dr.Field<int>("CapturePointID"),
                    Type = dr.Field<string>("Type"),
                    Name = dr.Field<string>("Name"),
                    LatLong = dr.Field<string>("LatLong"),
                    MGRS = dr.Field<string>("MGRS"),
                    MaxCapacity = dr.Field<int>("MaxCapacity"),
                    Text = cpText,
                    Status = dr.Field<string>("Status"),
                    StatusChanged = dr.Field<ulong>("StatusChanged") == 1,  // for some reason MySql treats BIT(1) as ulong
                    BlueUnits = dr.Field<int>("BlueUnits"),
                    RedUnits = dr.Field<int>("RedUnits"),
                    Pos = new Position(dr.Field<double>("X"), dr.Field<double>("Y")),
                    Image = dr.Field<string>("ImagePath")
                };
                capturepoints.Add(capturepoint);
            }
            return capturepoints;
        }

        List<DepotModel> IDAL.GetDepots(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetDepots(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        List<DepotModel> IDAL.GetDepots(int serverID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();
            List<DepotModel> depots = new List<DepotModel>();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_DEPOTS)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                DepotModel depot = new DepotModel
                {
                    ID = dr.Field<int>("DepotID"),
                    Name = dr.Field<string>("Name"),
                    LatLong = dr.Field<string>("LatLong"),
                    MGRS = dr.Field<string>("MGRS"),
                    Capacity = dr.Field<int>("CurrentCapacity") + " / " + dr.Field<int>("Capacity"),
                    Status = dr.Field<string>("Status"),
                    StatusChanged = dr.Field<ulong>("StatusChanged") == 1,  // for some reason MySQL treats BIT(1) as ulong
                    Resources = dr.Field<string>("Resources"),
                    Pos = new Position(dr.Field<double>("X"), dr.Field<double>("Y")),
                    Image = dr.Field<string>("ImagePath")
                };
                depots.Add(depot);
            }
            return depots;
        }

        GameModel IDAL.GetGame(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetGame(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        GameModel IDAL.GetGame(int serverID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();

            GameModel g = new GameModel();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_GAME)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                TimeSpan rt;
                if (dr["RestartTime"] == DBNull.Value || dr["RestartTime"] == null)
                    rt = new TimeSpan(0, 0, 0);
                else
                    rt = new TimeSpan(TimeSpan.TicksPerSecond * dr.Field<int>("RestartTime"));

                string status = "Offline";
                if (dr["Status"] != DBNull.Value && dr["Status"] != null)
                    status = dr.Field<string>("Status");

                g.ServerID = serverID;
                g.ServerName = dr.Field<string>("ServerName");
                g.IPAddress = dr.Field<string>("IPAddress");
                g.OnlinePlayersCount = Convert.ToInt32(dr.Field<long>("OnlinePlayerCount"));
                g.RestartTime = rt.ToString();
                g.Status = status;
                g.Depots = ((IDAL)this).GetDepots(serverID, ref conn);
                g.CapturePoints = ((IDAL)this).GetCapturePoints(serverID, ref conn);
                g.Missions = ((IDAL)this).GetSideMissions(serverID, ref conn);
                g.OnlinePlayers = ((IDAL)this).GetOnlinePlayers(serverID, ref conn);
                g.Map = ((IDAL)this).GetGameMap(serverID, ref conn);
                break;
            }
            return g;
        }

        GameMapModel IDAL.GetGameMap(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetGameMap(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        GameMapModel IDAL.GetGameMap(int serverID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();

            GameMapModel map = new GameMapModel
            {
                MapExists = false,
                Layers = new List<MapLayerModel>()
            };
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_GAMEMAP)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                map.ImagePath = dr.Field<string>("ImagePath");
                map.DCSOriginPosition = new Position(dr.Field<double>("X"), dr.Field<double>("Y"));
                map.Resolution = new Resolution(dr.Field<double>("Width"), dr.Field<double>("Height"));
                map.Ratio = dr.Field<double>("Ratio");
                map.Layers = ((IDAL)this).GetMapLayers(dr.Field<int>("GameMapID"), ref conn);
                map.MapExists = true;
                break;
            }
            return map;
        }

        List<MapLayerModel> IDAL.GetMapLayers(int mapID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetMapLayers(mapID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        List<MapLayerModel> IDAL.GetMapLayers(int mapID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();
            List<MapLayerModel> layers = new List<MapLayerModel>();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_LAYERS)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new MySqlParameter("GameMapID", mapID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                MapLayerModel layer = new MapLayerModel(new Resolution(dr.Field<double>("Width"), dr.Field<double>("Height")), dr.Field<string>("ImagePath"));
                layers.Add(layer);
            }
            return layers;
        }

        MarkerViewModel IDAL.GetMarkers(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetMarkers(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        MarkerViewModel IDAL.GetMarkers(int serverID, ref MySqlConnection conn)
        {
            MarkerViewModel mm = new MarkerViewModel()
            {
                Depots = ((IDAL)this).GetDepots(serverID, ref conn),
                CapturePoints = ((IDAL)this).GetCapturePoints(serverID, ref conn),
                Missions = ((IDAL)this).GetSideMissions(serverID, ref conn)
            };

            return mm;
        }

        List<OnlinePlayerModel> IDAL.GetOnlinePlayers(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetOnlinePlayers(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        List<OnlinePlayerModel> IDAL.GetOnlinePlayers(int serverID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();

            List<OnlinePlayerModel> players = new List<OnlinePlayerModel>();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_ONLINEPLAYERS)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                string Side = "Neutral";
                if (dr.Field<int>("Side") == 1)
                    Side = "Red";
                else if (dr.Field<int>("Side") == 2)
                    Side = "Blue";

                string Lives = "";
                if (dr["Lives"] != DBNull.Value && dr["Lives"] != null)
                {
                    Lives = dr.Field<int>("Lives").ToString();
                }

                OnlinePlayerModel player = new OnlinePlayerModel
                {
                    UCID = dr.Field<string>("UCID"),
                    Name = dr.Field<string>("Name"),
                    Role = dr.Field<string>("Role"),
                    RoleImage = dr.Field<string>("RoleImage"),
                    Side = Side,
                    Ping = dr.Field<string>("Ping"),
                    Lives = Lives
                };
                players.Add(player);
            }
            return players;
        }

        List<ServerModel> IDAL.GetServers()
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetServers(ref conn);
            }
            finally
            {
                conn.Close();
            }              
        }

        List<ServerModel> IDAL.GetServers(ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();
            List<ServerModel> servers = new List<ServerModel>();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_SERVERS)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
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

            return servers;
        }

        List<SideMissionModel> IDAL.GetSideMissions(int serverID)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetSideMissions(serverID, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        List<SideMissionModel> IDAL.GetSideMissions(int serverID, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();
            List<SideMissionModel> missions = new List<SideMissionModel>();
            MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_GET_SIDEMISSIONS)
            {
                Connection = conn,
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new MySqlParameter("ServerID", serverID));
            MySqlDataReader rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(rdr);

            foreach (DataRow dr in dt.Rows)
            {
                TimeSpan rt;
                if (dr["TimeRemaining"] == DBNull.Value || dr["TimeRemaining"] == null)
                    rt = new TimeSpan(0, 0, 0);
                else
                    rt = new TimeSpan(TimeSpan.TicksPerSecond * Convert.ToInt32(dr.Field<double>("TimeRemaining")));

                double it = 0;
                if (dr["TimeInactive"] != DBNull.Value && dr["TimeInactive"] != null)
                    it = ((TimeSpan)(DateTime.Now - dr.Field<DateTime>("TimeInactive"))).TotalSeconds;

                SideMissionModel mission = new SideMissionModel
                {
                    ID = dr.Field<int>("ServerMissionID"),
                    Name = dr.Field<string>("Name"),
                    Desc = dr.Field<string>("Description"),
                    Image = dr.Field<string>("ImagePath"),
                    Status = dr.Field<string>("Status"),
                    StatusChanged = dr.Field<ulong>("StatusChanged") == 1,  // for some reason MySQL treats BIT(1) as ulong
                    TimeRemaining = rt.ToString(),
                    TimeInactive = it,
                    LatLong = dr.Field<string>("LatLong"),
                    MGRS = dr.Field<string>("MGRS"),     
                    Pos = new Position(dr.Field<double>("X"), dr.Field<double>("Y"))         
                };
                missions.Add(mission);
            }
            return missions;
        }

        SearchResultsModel IDAL.GetSearchResults(string query)
        {
            MySqlConnection conn = new MySqlConnection(_DBConnection);
            try
            {
                conn.Open();
                return ((IDAL)this).GetSearchResults(query, ref conn);
            }
            finally
            {
                conn.Close();
            }
        }

        SearchResultsModel IDAL.GetSearchResults(string query, ref MySqlConnection conn)
        {
            if (conn.State == ConnectionState.Closed || conn.State == ConnectionState.Broken)
                conn.Open();
            SearchResultsModel results = new SearchResultsModel();

            { 
                MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_SEARCH_PLAYERS)
                {
                    Connection = conn,
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.Add(new MySqlParameter("Criteria", query));
                MySqlDataReader rdr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(rdr);

                foreach (DataRow dr in dt.Rows)
                {
                    PlayerModel player = new PlayerModel
                    {
                        UCID = dr.Field<string>("UCID"),
                        Name = dr.Field<string>("Name")
                    };
                    results.PlayerResults.Add(player);
                }
            }

            {
                MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand(SP_SEARCH_SERVERS)
                {
                    Connection = conn,
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                cmd.Parameters.Add(new MySqlParameter("Criteria", query));
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
                    results.ServerResults.Add(server);
                }
            }

            return results;
        }
    }
}