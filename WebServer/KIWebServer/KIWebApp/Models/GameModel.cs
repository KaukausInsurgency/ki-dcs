using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class Point
    {
        public double X { get; set; }
        public double Y { get; set; }
        public Point(double _x, double _y)
        {
            X = _x;
            Y = _y;
        }
    }

    public class ImageLayer
    {
        public Point Resolution { get; set; }
        public string ImagePath { get; set; }
        public ImageLayer(Point res, string path)
        {
            Resolution = res;
            ImagePath = path;
        }
    }

    public class MapImage
    {
        public Point Resolution { get; set; }
        public string ImagePath { get; set; }
        public Point DCSOriginPoint { get; set; }
        public double Ratio;
        public List<ImageLayer> Layers { get; set; }
    }

    public class DepotModel
    {
        public string Name { get; set; }
        public string LatLong { get; set; }
        public string MGRS { get; set; }
        public string Capacity { get; set; }
        public string Status { get; set; }
        public string Resources { get; set; }
        public Point Pos { get; set; }
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
        public Point Pos { get; set; }
        public string Image { get; set; }
    }

    public class OnlinePlayersModel
    {
        public string UCID { get; set; }
        public string Name { get; set; }
        public string Role { get; set; }
        public string RoleImage { get; set; }
        public string Side { get; set; }
        public string Ping { get; set; }
    }


    public class GameModel
    {
        public int ServerID { get; set; }
        public string ServerName { get; set; }
        public string IPAddress { get; set; }
        public string Status { get; set; }
        public String RestartTime { get; set; }
        public int OnlinePlayersCount { get; set; }
        public List<DepotModel> Depots { get; set; }
        public List<CapturePointModel> CapturePoints { get; set; }
        public List<OnlinePlayersModel> OnlinePlayers { get; set; }
        public MapImage Map { get; set; }

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
                Pos = new Point(840106.5625, -150906.578125),
                Image = "Images/depot-red-256x256.png"
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
                Pos = new Point(829208, -153602),
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
                Pos = new Point(841868, -150358.28125),
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
                Pos = new Point(814918.625, -169069.359375),
                Image = "Images/depot-red-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                Name = "Vladikavkaz Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"DWM - Vladikavkaz Depot
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
                Pos = new Point(850409.1875, -168602.5625),
                Image = "Images/depot-contested-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                Name = "Buron Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"DWM - Buron Depot
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
                Pos = new Point(801123.5, -200446.28125),
                Image = "Images/depot-blue-256x256.png"
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
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
                Pos = new Point(104, 394),
                Image = "Images/flag-neutral-256x256.png"
            });

            List<OnlinePlayersModel> players = new List<OnlinePlayersModel>();
            players.Add(new OnlinePlayersModel()
            {
                UCID = "AAA",
                Name = "Igneous01",
                Role = "KA-50",
                RoleImage = "Images/role-ka50-256x256.png",
                Side = "Red",
                Ping = "50ms"
            });
            players.Add(new OnlinePlayersModel()
            {
                UCID = "BBB",
                Name = "HolyCrapBatman",
                Role = "AV-8B",
                RoleImage = "Images/role-av8b-256x256.png",
                Side = "Red",
                Ping = "121ms"
            });
            players.Add(new OnlinePlayersModel()
            {
                UCID = "CCC",
                Name = "JakeTheSnake",
                Role = "A10-C",
                RoleImage = "Images/role-a10c-256x256.png",
                Side = "Red",
                Ping = "150ms"
            });
            players.Add(new OnlinePlayersModel()
            {
                UCID = "DDD",
                Name = "MarvinStarvin",
                Role = "MI-8",
                RoleImage = "Images/role-mi8-256x256.png",
                Side = "Red",
                Ping = "132ms"
            });
            players.Add(new OnlinePlayersModel()
            {
                UCID = "EEE",
                Name = "PardonMeLads",
                Role = "A10-C",
                RoleImage = "Images/role-a10c-256x256.png",
                Side = "Red",
                Ping = "84ms"
            });

            MapImage m = new MapImage
            {
                DCSOriginPoint = new Point(734650, -123282),
                Resolution = new Point(800, 443),
                ImagePath = "Images/map-800x443.png",
                Ratio = 238.636171875,
                Layers = new List<ImageLayer>()
            };
            m.Layers.Add(new ImageLayer(new Point(1880, 1041), "Images/map-1880x1041.png"));
            m.Layers.Add(new ImageLayer(new Point(2685, 1487), "Images/map-2685x1487.png"));

            GameModel g = new GameModel()
            {
                ServerID = 4,
                ServerName = "Dev Server",
                IPAddress = "127.0.0.1",
                OnlinePlayersCount = 5,
                RestartTime = new TimeSpan(3, 30, 0).ToString(),
                Status = "Online",
                Depots = depots,
                CapturePoints = cps,
                OnlinePlayers = players,
                Map = m
            };
            return g;

        }
    }
}