using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class ServerViewModel
    {
        public int ServerID { get; set; }
        public string Status { get; set; }
        public string RestartTime { get; set; }
    }
}