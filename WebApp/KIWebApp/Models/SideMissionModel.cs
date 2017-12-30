using KIWebApp.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class SideMissionModel
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Desc { get; set; }
        public string Image { get; set; }
        public string Status { get; set; }
        public bool StatusChanged { get; set; }
        public string TimeRemaining { get; set; }
        public double TimeInactive { get; set; }
        public string LatLong { get; set; }
        public string MGRS { get; set; }
        public Position Pos { get; set; }     
    }
}