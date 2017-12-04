using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KIWebApp.Models;
using KIWebApp.Classes;
using KIWebApp.Asyncs;
using Microsoft.AspNet.SignalR;

namespace KIWebApp.Controllers
{
    public class ServersController : Controller
    {
        private List<GameThreadWorker> _schedulers;

        public ServersController()
        {
            _schedulers = new List<GameThreadWorker>();
        }

        public ActionResult Index()
        {
            if (_schedulers != null && _schedulers.Count > 0)
                _schedulers.Clear();

            IDAL dal;
            if (true)
            {
                dal = new DAL();
            }
            else
            {
                dal = new MockDAL();
            }
            return View(dal.GetServers());
        }

        public ActionResult Game(int serverID)
        {
            IDAL dal = new MockDAL();
            return View(dal.GetGame(serverID));
        }

    }
}
