using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class MarkerViewModel
    {
        public List<DepotModel> Depots { get; set; }
        public List<CapturePointModel> CapturePoints { get; set; }
        public List<SideMissionModel> Missions { get; set; }
    }
}