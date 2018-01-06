using KIWebApp.Classes;
using KIWebApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace KIWebApp.Controllers
{
    public class HomeController : Controller
    {
        private IDAL dal;

        public HomeController()
        {
            dal = new DAL();
        }

        public HomeController(IDAL dal)
        {
            this.dal = dal;
        }

        public ActionResult Index(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        public ActionResult Search(SearchModel model)
        {
            return View(dal.GetSearchResults(model.Query));
        }
    }
}