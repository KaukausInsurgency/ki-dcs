using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class DepotModel
    {
        public string Name { get; set; }
        public string LatLong { get; set; }
        public string MGRS { get; set; }
        public string Capacity { get; set; }
        public string Status { get; set; }
        public string Resources { get; set; }
        public int MapX { get; set; }
        public int MapY { get; set; }
        public string Image { get; set; }
    }

    public class GameModel
    {
        public int ServerID { get; set; }
        public string ServerName { get; set; }
        public string IPAddress { get; set; }
        public bool Status { get; set; }
        public String RestartTime { get; set; }
        public int OnlinePlayers { get; set; }
        public List<DepotModel> Depots { get; set; }
    }

    public class GameData
    {
        public static GameModel GetGame()
        {
            List<DepotModel> depots = new List<DepotModel>();
            depots.Add(new DepotModel()
            {
                Name = "Beslan Depot",
                LatLong = "43 11.430'N   44 33.547'E",
                MGRS = "38T MN 64175 82063",
                Capacity = "79 / 150",
                Status = "Online",
                Resources = @"DWM - Beslan Depot Depot Capacity: 79 / 150 Resource                 |Count Infantry                 |40    Watchtower Wood          |4     Fuel Tanks               |8     Outpost Wood             |4     Outpost Pipes            |4     Power Truck              |4     Fuel Truck               |4     Cargo Crates             |8     Watchtower Supplies      |4     Command Truck            |4     Tank                     |8     Outpost Supplies         |4     Ammo Truck               |4     APC                      |8     ",
                MapX = 200,
                MapY = 120,
                Image = "Images/depot-contested-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                Name = "Kirovo Depot",
                LatLong = "43 10.755'N   44 25.379'E",
                MGRS = "38T MN 53104 80881",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"DWM - Kirovo Depot Depot Capacity: 148 / 150 Resource                 |Count Infantry                 |40    Watchtower Wood          |4     Fuel Tanks               |8     Outpost Wood             |4     Outpost Pipes            |4     Power Truck              |4     Fuel Truck               |4     Cargo Crates             |8     Watchtower Supplies      |4     Command Truck            |4     Tank                     |8     Outpost Supplies         |4     Ammo Truck               |4     APC                      |8     ",
                MapX = 700,
                MapY = 300,
                Image = "Images/depot-blue-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                Name = "Beslan Backup Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"DWM - Beslan Backup Depot Depot Capacity: 148 / 150 Resource                 |Count Infantry                 |40    Watchtower Wood          |4     Fuel Tanks               |8     Outpost Wood             |4     Outpost Pipes            |4     Power Truck              |4     Fuel Truck               |4     Cargo Crates             |8     Watchtower Supplies      |4     Command Truck            |4     Tank                     |8     Outpost Supplies         |4     Ammo Truck               |4     APC                      |8     ",
                MapX = 504,
                MapY = 84,
                Image = "Images/depot-red-256x256.png"
            });

            GameModel g = new GameModel()
            {
                ServerID = 4,
                ServerName = "Dev Server",
                IPAddress = "127.0.0.1",
                OnlinePlayers = 5,
                RestartTime = new TimeSpan(3, 30, 0).ToString(),
                Status = true,
                Depots = depots
            };
            return g;

        }
    }
}