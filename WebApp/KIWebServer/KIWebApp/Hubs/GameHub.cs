using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using KIWebApp.Classes;
using KIWebApp.Models;
using System.Threading.Tasks;
using KIWebApp.Singletons;

namespace KIWebApp.Hubs
{
    public class GameHub : Hub
    {
        public override Task OnConnected()
        {       
            return base.OnConnected();
        }

        public override Task OnDisconnected(bool stopCalled)
        {
            return base.OnDisconnected(stopCalled);
        }

        public Task Subscribe(int serverID)
        {
            Task result = Groups.Add(Context.ConnectionId, serverID.ToString());
            IHubContext hub = GlobalHost.ConnectionManager.GetHubContext<KIWebApp.Hubs.GameHub>();
            hub.Groups.Add(Context.ConnectionId, serverID.ToString());
            lock (GLOBAL.SignalRGameSessions)
            {
                int count = 0;
                if (GLOBAL.SignalRGameSessions.TryGetValue(serverID, out count))
                {
                    GLOBAL.SignalRGameSessions[serverID] = count + 1;//increment client number
                }
                else
                {
                    // Spin up a new background thread to poll the database for this game
                    GLOBAL.BackgroundThreadWorkers.Add(serverID, new Asyncs.GameThreadWorker(serverID));
                    GLOBAL.SignalRGameSessions.Add(serverID, 1);// add group and set its client number to 1
                }
            }
              
            return result;
        }

        public Task Unsubscribe(int serverID)
        {
            Task result = Groups.Remove(Context.ConnectionId, serverID.ToString());
            lock (GLOBAL.SignalRGameSessions)
            {
                int count = 0;
                if (GLOBAL.SignalRGameSessions.TryGetValue(serverID, out count))
                {
                    if (count == 1)//if group contains only 1client
                    {
                        GLOBAL.BackgroundThreadWorkers[serverID].Pause();
                        GLOBAL.BackgroundThreadWorkers[serverID].Dispose();
                        GLOBAL.BackgroundThreadWorkers.Remove(serverID);
                        GLOBAL.SignalRGameSessions.Remove(serverID);
                    }
                    else
                    {
                        GLOBAL.SignalRGameSessions[serverID] = count - 1;
                    }
                }
            }
            
            return result;
        }

    }
}