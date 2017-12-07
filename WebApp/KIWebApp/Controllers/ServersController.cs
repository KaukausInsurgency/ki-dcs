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
        private IDAL dal;

        public ServersController()
        {
            dal = new DAL();
        }

        public ServersController(IDAL dal)
        {
            this.dal = dal;
        }

        public ActionResult Index()
        {
            return View(dal.GetServers());
        }

        public ActionResult Game(int serverID)
        {
            return View(dal.GetGame(serverID));
        }

    }
}
