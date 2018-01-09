using KIWebApp.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KIWebApp.Controllers
{
    public class StatisticsController : Controller
    {
        private IDAL dal;
        private IDAL_Rpt rptdal;

        public StatisticsController()
        {
            dal = new DAL();
            rptdal = new DAL_Rpt();
        }

        public StatisticsController(IDAL dal, IDAL_Rpt rptdal)
        {
            this.dal = dal;
            this.rptdal = rptdal;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ServerStats(int serverID)
        {
            return View();
        }

        public ActionResult PlayerStats(string playerUCID)
        {
            return View(rptdal.GetOverallPlayerStats(playerUCID));
        }
    }
}
