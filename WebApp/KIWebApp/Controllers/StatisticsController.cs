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

        public StatisticsController()
        {
            dal = new DAL();
        }

        public StatisticsController(IDAL dal)
        {
            this.dal = dal;
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult ServerStats(int serverID)
        {
            return View();
        }

        public ActionResult PlayerStats(string ucid)
        {
            return View();
        }
    }
}
