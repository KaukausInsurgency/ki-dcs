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
        List<DepotModel> GetDepots(int serverID);
        List<CapturePointModel> GetCapturePoints(int serverID);
        List<MapLayerModel> GetMapLayers(int mapID);
        List<OnlinePlayerModel> GetOnlinePlayers(int serverID);
        GameMapModel GetGameMap(int serverID);
        GameModel GetGame(int serverID);
        List<AirportModel> GetAirports(int serverID);
    }
}