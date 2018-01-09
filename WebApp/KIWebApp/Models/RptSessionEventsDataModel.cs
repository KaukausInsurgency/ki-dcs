using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    // Violating style conventions here because HighCharts expects the JSON property names to be lowercase
    // Rather than add yet more code on JS side to convert the model data into a highchart plot series
    // This will convert into the series that Highcharts expects, meaning no middle translations required
    public class RptSessionEventsDataModel
    {
        public RptSessionEventsDataModel()
        {
            data = new List<int>();
        }
        public string name { get; set; }
        public List<int> data { get; set; }
    }
}