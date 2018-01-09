using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class RptAirframeOverallStatsModel
    {
        public string Airframe { get; set; }
        public long TotalFlightTime { get; set; }
        public long AverageFlightTime { get; set; }

        public int TakeOffs { get; set; }
        public int Landings { get; set; }
        public int SlingLoadHooks { get; set; }
        public int SlingLoadUnhooks { get; set; }
        public int Kills { get; set; }
        public int KillsPlayer { get; set; }
        public int KillsFriendly { get; set; }
        public int Deaths { get; set; }
        public int Ejects { get; set; }
        public int TransportMounts { get; set; }
        public int TransportDismounts { get; set; }
        public int DepotResupplies { get; set; }
        public int CargoUnpacked { get; set; }

        public double SortieSuccessRatio { get; set; }
        public double SlingLoadSuccessRatio { get; set; }
        public double KillDeathEjectRatio { get; set; }
        public double TransportSuccessRatio { get; set; }
        public double FriendlyFireRatio { get; set; }
    }
}