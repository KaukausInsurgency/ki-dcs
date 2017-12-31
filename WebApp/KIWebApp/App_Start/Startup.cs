﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Owin;
using Owin;
using log4net.Config;

[assembly: OwinStartup(typeof(KIWebApp.App_Start.Startup))]
[assembly: XmlConfigurator(ConfigFile = "Log4net.config", Watch = true)]

namespace KIWebApp.App_Start
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}