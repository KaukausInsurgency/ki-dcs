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
        public string Status { get; set; }
        public string StatusImage { get; set; }
        public TimeSpan RestartTime { get; set; }
        public int OnlinePlayers { get; set; }
    }
}