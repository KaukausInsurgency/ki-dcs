using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class ServerModel
    {
        public int ServerID { get; set; }
        public string ServerName { get; set; }
        public string IPAddress { get; set; }
        public bool Status { get; set; }
        public TimeSpan RestartTime { get; set; }
        public int OnlinePlayers { get; set; }
    }

    public class ServerModelList
    {
        public static List<ServerModel> GetServers()
        { 
            List<ServerModel> servers = new List<ServerModel>();
            servers.Add(new ServerModel
            {
                ServerID = 1,
                ServerName = "Demo Server",
                IPAddress = "127.0.0.1",
                OnlinePlayers = 5,
                RestartTime = new TimeSpan(3, 30, 0),
                Status = true
            });
            servers.Add(new ServerModel
            {
                ServerID = 2,
                ServerName = "Development Server",
                IPAddress = "192.105.24.87",
                OnlinePlayers = 1,
                RestartTime = new TimeSpan(4, 0, 0),
                Status = true
            });
            servers.Add(new ServerModel
            {
                ServerID = 3,
                ServerName = "Clan KI Server",
                IPAddress = "188.82.43.3",
                OnlinePlayers = 32,
                RestartTime = new TimeSpan(1, 32, 0),
                Status = true
            });
            return servers;
        }

    }

}