using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class RptPlayerOverallStatsModel
    {
        public string PlayerName { get; set; }
        public int PlayerLives { get; set; }
        public bool PlayerBanned { get; set; }
        public string TotalGameTime { get; set; }
        public int TakeOffs { get; set; }
        public int Landings { get; set; }
        public int SlingLoadHooks { get; set; }
        public int SlingLoadUnhooks { get; set; }
        public int Kills { get; set; }
        public int Deaths { get; set; }
        public int Ejects { get; set; }
        public int TransportMounts { get; set; }
        public int TransportDismounts { get; set; }
        public int DepotResupplies { get; set; }
        public int CargoUnpacked { get; set; }

        public decimal? SortieSuccessRatio { get; set; }
        public decimal? SlingLoadSuccessRatio { get; set; }
        public decimal? KillDeathEjectRatio { get; set; }
        public decimal? TransportSuccessRatio { get; set; }

        public List<RptTopAirframeSeriesModel> TopAirframesSeries { get; set; }
        public List<RptSessionSeriesModel> LastSessionSeries { get; set; }
        public List<RptSessionEventsDataModel> LastXSessionsEventsSeries { get; set; }
    }
}