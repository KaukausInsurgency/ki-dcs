using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KIWebApp.Classes;

namespace KIWebApp.Models
{
    public class CapturePointModel
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string LatLong { get; set; }
        public string MGRS { get; set; }
        public string Status { get; set; }
        public string Capacity { get; set; }
        public int BlueUnits { get; set; }
        public int RedUnits { get; set; }
        public Position Pos { get; set; }
        public string Image { get; set; }
    }
}