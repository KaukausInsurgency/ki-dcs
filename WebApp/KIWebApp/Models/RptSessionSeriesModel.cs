using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{

    public class RptSessionSeriesModel
    {
        public RptSessionSeriesModel()
        {
            data = new List<SessionDataPlotModel>();
        }
        public string name { get; set; }
        public List<SessionDataPlotModel> data { get; set; }
    }
}