using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KIWebApp.Models;
using KIWebApp.Classes;

namespace KIWebApp.Controllers
{
    public class ServersController : Controller
    {
        //
        // GET: /Servers/

        public ActionResult Index()
        {
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
