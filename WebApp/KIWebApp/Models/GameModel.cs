using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class GameModel
    {
        public int ServerID { get; set; }
        public string ServerName { get; set; }
        public string IPAddress { get; set; }
        public string Status { get; set; }
        public string RestartTime { get; set; }
        public int OnlinePlayersCount { get; set; }
        public List<DepotModel> Depots { get; set; }
        public List<CapturePointModel> CapturePoints { get; set; }
        public List<OnlinePlayerModel> OnlinePlayers { get; set; }
        public List<SideMissionModel> Missions { get; set; }
        public GameMapModel Map { get; set; }

    }
}