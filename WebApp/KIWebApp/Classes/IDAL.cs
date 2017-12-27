using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KIWebApp.Models;

namespace KIWebApp.Classes
{
    public interface IDAL
    {
        List<ServerModel> GetServers();
        List<ServerModel> GetServers(ref MySql.Data.MySqlClient.MySqlConnection conn);
        List<DepotModel> GetDepots(int serverID);
        List<DepotModel> GetDepots(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        List<CapturePointModel> GetCapturePoints(int serverID);
        List<CapturePointModel> GetCapturePoints(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        List<SideMissionModel> GetSideMissions(int serverID);
        List<SideMissionModel> GetSideMissions(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        List<MapLayerModel> GetMapLayers(int mapID);
        List<MapLayerModel> GetMapLayers(int mapID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        List<OnlinePlayerModel> GetOnlinePlayers(int serverID);
        List<OnlinePlayerModel> GetOnlinePlayers(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        GameMapModel GetGameMap(int serverID);
        GameMapModel GetGameMap(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        GameModel GetGame(int serverID);
        GameModel GetGame(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
        MarkerViewModel GetMarkers(int serverID);
        MarkerViewModel GetMarkers(int serverID, ref MySql.Data.MySqlClient.MySqlConnection conn);
    }
}