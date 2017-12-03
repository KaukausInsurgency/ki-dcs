using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using KIWebApp.Classes;
using KIWebApp.Models;

namespace KIWebApp.Hubs
{
    public class GameHub : Hub
    {

        public void UpdateMarkers()
        {
            Clients.All.UpdateMarkers();
        }
    }
}