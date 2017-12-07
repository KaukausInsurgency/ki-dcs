using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class OnlinePlayerModel
    {
        public string UCID { get; set; }
        public string Name { get; set; }
        public string Role { get; set; }
        public string RoleImage { get; set; }
        public string Side { get; set; }
        public string Ping { get; set; }
    }
}