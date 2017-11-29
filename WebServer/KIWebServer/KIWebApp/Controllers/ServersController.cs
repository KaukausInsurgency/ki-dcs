using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using KIWebApp.Models;

namespace KIWebApp.Controllers
{
    public class ServersController : Controller
    {
        //
        // GET: /Servers/

        public ActionResult Index()
        {
            List<ServerModel> servers = ServerModelList.GetServers();
            return View(servers);
        }

        public ActionResult Game(int serverID)
        {
            
            GameModel game = GameData.GetGame();
            return View(game);
        }

    }
}
