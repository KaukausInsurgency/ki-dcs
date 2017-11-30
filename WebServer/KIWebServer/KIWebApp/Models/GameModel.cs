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

    public class CapturePointModel
    {
        public string Name { get; set; }
        public string LatLong { get; set; }
        public string MGRS { get; set; }
        public string Status { get; set; }
        public int BlueUnits { get; set; }
        public int RedUnits { get; set; }
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
        public List<CapturePointModel> CapturePoints { get; set; }
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
                Resources = @"DWM - Beslan Depot
 Depot Capacity: 79 / 150
 Resource                 |Count
 Infantry                 |40   
 Watchtower Wood          |4    
 Fuel Tanks               |8    
 Outpost Wood             |4    
 Outpost Pipes            |4    
 Power Truck              |4    
 Fuel Truck               |4    
 Cargo Crates             |8    
 Watchtower Supplies      |4    
 Command Truck            |4    
 Tank                     |8    
 Outpost Supplies         |4    
 Ammo Truck               |4    
 APC                      |8    
 ",
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
                Resources = @"DWM - Kirovo Depot
 Depot Capacity: 148 / 150
 Resource                 |Count
 Infantry                 |40   
 Watchtower Wood          |4    
 Fuel Tanks               |8    
 Outpost Wood             |4    
 Outpost Pipes            |4    
 Power Truck              |4    
 Fuel Truck               |4    
 Cargo Crates             |8    
 Watchtower Supplies      |4    
 Command Truck            |4    
 Tank                     |8    
 Outpost Supplies         |4    
 Ammo Truck               |4    
 APC                      |8    
 ",
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
                Resources = @"DWM - Beslan Backup Depot
 Depot Capacity: 148 / 150
 Resource                 |Count
 Infantry                 |40   
 Watchtower Wood          |4    
 Fuel Tanks               |8    
 Outpost Wood             |4    
 Outpost Pipes            |4    
 Power Truck              |4    
 Fuel Truck               |4    
 Cargo Crates             |8    
 Watchtower Supplies      |4    
 Command Truck            |4    
 Tank                     |8    
 Outpost Supplies         |4    
 Ammo Truck               |4    
 APC                      |8    
 ",
                MapX = 504,
                MapY = 84,
                Image = "Images/depot-red-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                Name = "Alagir Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"DWM - Alagir Depot
 Depot Capacity: 148 / 150
 Resource                 |Count
 Infantry                 |40   
 Watchtower Wood          |4    
 Fuel Tanks               |8    
 Outpost Wood             |4    
 Outpost Pipes            |4    
 Power Truck              |4    
 Fuel Truck               |4    
 Cargo Crates             |8    
 Watchtower Supplies      |4    
 Command Truck            |4    
 Tank                     |8    
 Outpost Supplies         |4    
 Ammo Truck               |4    
 APC                      |8    
 ",
                MapX = 104,
                MapY = 394,
                Image = "Images/depot-red-256x256.png"
            });

            List<CapturePointModel> cps = new List<CapturePointModel>();
            cps.Add(new CapturePointModel()
            {
                Name = "Beslan City",
                LatLong = "43 11.707'N   44 33.693'E",
                MGRS = "38T MN 64375 82575",
                Status = "Red",
                BlueUnits = 0,
                RedUnits = 10,
                MapX = 194,
                MapY = 340,
                Image = "Images/flag-red-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Beslan Airport",
                LatLong = "43 12.216'N   44 36.394'E",
                MGRS = "38T MN 68038 83498",
                Status = "Blue",
                BlueUnits = 9,
                RedUnits = 0,
                MapX = 461,
                MapY = 377,
                Image = "Images/flag-blue-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Kirovo City",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Contested",
                BlueUnits = 9,
                RedUnits = 5,
                MapX = 44,
                MapY = 90,
                Image = "Images/flag-contested-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Alagir City",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                MapX = 114,
                MapY = 382,
                Image = "Images/flag-neutral-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Test 1",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                MapX = 348,
                MapY = 155,
                Image = "Images/flag-neutral-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Test 2",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                MapX = 414,
                MapY = 185,
                Image = "Images/flag-neutral-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Test 3",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                MapX = 578,
                MapY = 33,
                Image = "Images/flag-neutral-256x256.png"
            });

            cps.Add(new CapturePointModel()
            {
                Name = "Test 4",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                MapX = 678,
                MapY = 243,
                Image = "Images/flag-neutral-256x256.png"
            });

            GameModel g = new GameModel()
            {
                ServerID = 4,
                ServerName = "Dev Server",
                IPAddress = "127.0.0.1",
                OnlinePlayers = 5,
                RestartTime = new TimeSpan(3, 30, 0).ToString(),
                Status = true,
                Depots = depots,
                CapturePoints = cps
            };
            return g;

        }
    }
}