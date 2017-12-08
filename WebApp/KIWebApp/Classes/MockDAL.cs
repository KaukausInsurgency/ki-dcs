using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KIWebApp.Models;
using MySql.Data.MySqlClient;

namespace KIWebApp.Classes
{
    public class MockDAL : IDAL
    {

        GameModel IDAL.GetGame(int serverID)
        {
            GameModel g = new GameModel()
            {
                ServerID = serverID,
                ServerName = "Dev Server",
                IPAddress = "127.0.0.1",
                OnlinePlayersCount = 5,
                RestartTime = new TimeSpan(3, 30, 0).ToString(),
                Status = "Online",
                Depots = ((IDAL)this).GetDepots(serverID),
                CapturePoints = ((IDAL)this).GetCapturePoints(serverID),
                OnlinePlayers = ((IDAL)this).GetOnlinePlayers(serverID),
                Airports = ((IDAL)this).GetAirports(serverID),
                Map = ((IDAL)this).GetGameMap(serverID)
            };
            return g;
        }

        List<CapturePointModel> IDAL.GetCapturePoints(int serverID)
        {
            List<CapturePointModel> cps = new List<CapturePointModel>();

            cps.Add(new CapturePointModel()
            {
                ID = 1,
                Name = "Beslan City",
                LatLong = "43 11.707'N   44 33.693'E",
                MGRS = "38T MN 64375 82575",
                Status = "Red",
                BlueUnits = 0,
                RedUnits = 10,
                Pos = new Position(751123.5, -125446.28125),
                Image = "Images/markers/flag-red-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 2,
                Name = "Beslan Airport",
                LatLong = "43 12.216'N   44 36.394'E",
                MGRS = "38T MN 68038 83498",
                Status = "Blue",
                BlueUnits = 9,
                RedUnits = 0,
                Pos = new Position(801123.5, -150446.28125),
                Image = "Images/markers/flag-blue-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 3,
                Name = "Kirovo City",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Contested",
                BlueUnits = 9,
                RedUnits = 5,
                Pos = new Position(767123.5, -140426.28125),
                Image = "Images/markers/flag-contested-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 4,
                Name = "Alagir City",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                Pos = new Position(807123.5, -220426.28125),
                Image = "Images/markers/flag-neutral-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 5,
                Name = "Test 1",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                Pos = new Position(823123.5, -140426.28125),
                Image = "Images/markers/flag-neutral-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 6,
                Name = "Test 2",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                Pos = new Position(817123.5, -190426.28125),
                Image = "Images/markers/flag-neutral-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 7,
                Name = "Test 3",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                Pos = new Position(857123.5, -220426.28125),
                Image = "Images/markers/flag-neutral-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            cps.Add(new CapturePointModel()
            {
                ID = 8,
                Name = "Test 4",
                LatLong = "43 10.373'N   44 24.588'E",
                MGRS = "38T MN 52028 80182",
                Status = "Neutral",
                BlueUnits = 0,
                RedUnits = 0,
                Pos = new Position(774123.5, -220426.28125),
                Image = "Images/markers/flag-neutral-256x256.png",
                Resources = "Type|Fortified|Limit\nInfantry|0|4\n"
            });

            return cps;
        }

        List<DepotModel> IDAL.GetDepots(int serverID)
        {
            List<DepotModel> depots = new List<DepotModel>();
            depots.Add(new DepotModel()
            {
                ID = 1,
                Name = "Beslan Depot",
                LatLong = "43 11.430'N   44 33.547'E",
                MGRS = "38T MN 64175 82063",
                Capacity = "79 / 150",
                Status = "Online",
                Resources = @"
Resource|Count
Infantry|40   
Watchtower Wood|4    
Fuel Tanks|8    
Outpost Wood|4    
Outpost Pipes|4    
Power Truck|4    
Fuel Truck|4    
Cargo Crates|8    
Watchtower Supplies|4    
Command Truck|4    
Tank|8    
Outpost Supplies|4    
Ammo Truck|4    
APC|8    
",
                Pos = new Position(840106.5625, -150906.578125),
                Image = "Images/markers/depot-red-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                ID = 2,
                Name = "Kirovo Depot",
                LatLong = "43 10.755'N   44 25.379'E",
                MGRS = "38T MN 53104 80881",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"
Resource|Count
Infantry|40   
Watchtower Wood|4    
Fuel Tanks|8    
Outpost Wood|4    
Outpost Pipes|4    
Power Truck|4    
Fuel Truck|4    
Cargo Crates|8    
Watchtower Supplies|4    
Command Truck|4    
Tank|8    
Outpost Supplies|4    
Ammo Truck|4    
APC|8    
",
                Pos = new Position(829208, -153602),
                Image = "Images/markers/depot-blue-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                ID = 3,
                Name = "Beslan Backup Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"
Resource|Count
Infantry|40   
Watchtower Wood|4    
Fuel Tanks|8    
Outpost Wood|4    
Outpost Pipes|4    
Power Truck|4    
Fuel Truck|4    
Cargo Crates|8    
Watchtower Supplies|4    
Command Truck|4    
Tank|8    
Outpost Supplies|4    
Ammo Truck|4    
APC|8    
",
                Pos = new Position(841868, -150358.28125),
                Image = "Images/markers/depot-red-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                ID = 4,
                Name = "Alagir Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"
Resource|Count
Infantry|40   
Watchtower Wood|4    
Fuel Tanks|8    
Outpost Wood|4    
Outpost Pipes|4    
Power Truck|4    
Fuel Truck|4    
Cargo Crates|8    
Watchtower Supplies|4    
Command Truck|4    
Tank|8    
Outpost Supplies|4    
Ammo Truck|4    
APC|8    
",
                Pos = new Position(814918.625, -169069.359375),
                Image = "Images/markers/depot-red-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                ID = 5,
                Name = "Vladikavkaz Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Offline",
                Resources = @"
Resource|Count
Infantry|40   
Watchtower Wood|4    
Fuel Tanks|8    
Outpost Wood|4    
Outpost Pipes|4    
Power Truck|4    
Fuel Truck|4    
Cargo Crates|8    
Watchtower Supplies|4    
Command Truck|4    
Tank|8    
Outpost Supplies|4    
Ammo Truck|4    
APC|8    
",
                Pos = new Position(850409.1875, -168602.5625),
                Image = "Images/markers/depot-contested-256x256.png"
            });

            depots.Add(new DepotModel()
            {
                ID = 6,
                Name = "Buron Depot",
                LatLong = "43 11.537'N   44 34.866'E",
                MGRS = "38T MN 65962 82253",
                Capacity = "148 / 150",
                Status = "Online",
                Resources = @"
Resource|Count
Infantry|40   
Watchtower Wood|4    
Fuel Tanks|8    
Outpost Wood|4    
Outpost Pipes|4    
Power Truck|4    
Fuel Truck|4    
Cargo Crates|8    
Watchtower Supplies|4    
Command Truck|4    
Tank|8    
Outpost Supplies|4    
Ammo Truck|4    
APC|8    
",
                Pos = new Position(801123.5, -200446.28125),
                Image = "Images/markers/depot-blue-256x256.png"
            });

            return depots;
        }

        GameMapModel IDAL.GetGameMap(int serverID)
        {
            GameMapModel m = new GameMapModel
            {
                DCSOriginPosition = new Position(734650, -123282),
                Resolution = new Resolution(800, 443),
                ImagePath = "Images/map/map-800x443.png",
                Ratio = 238.636171875,
                Layers = this.GetLayers(1)
            };
            return m;
        }

        List<MapLayerModel> IDAL.GetMapLayers(int mapID)
        {
            return GetLayers(mapID);
        }

        List<OnlinePlayerModel> IDAL.GetOnlinePlayers(int serverID)
        {
            List<OnlinePlayerModel> players = new List<OnlinePlayerModel>();
            players.Add(new OnlinePlayerModel()
            {
                UCID = "AAA",
                Name = "Igneous01",
                Role = "KA-50",
                RoleImage = "Images/role/role-ka50-30x30.png",
                Side = "Red",
                Ping = "50ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "BBB",
                Name = "HolyCrapBatman",
                Role = "F-15C",
                RoleImage = "Images/role/role-f15-30x30.png",
                Side = "Red",
                Ping = "121ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "CCC",
                Name = "JakeTheSnake",
                Role = "A10-C",
                RoleImage = "Images/role/role-a10c-30x30.png",
                Side = "Red",
                Ping = "150ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "DDD",
                Name = "MarvinStarvin",
                Role = "MI-8",
                RoleImage = "Images/role/role-mi8-30x30.png",
                Side = "Red",
                Ping = "132ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "EEE",
                Name = "PardonMeLads",
                Role = "A10-C",
                RoleImage = "Images/role/role-a10c-30x30.png",
                Side = "Red",
                Ping = "84ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "FFF",
                Name = "LoneStar",
                Role = "GCI",
                RoleImage = "Images/role/role-gci-30x30.png",
                Side = "Red",
                Ping = "94ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "GGG",
                Name = "CarryMyPackBack",
                Role = "SU-25T",
                RoleImage = "Images/role/role-su25-30x30.png",
                Side = "Red",
                Ping = "92ms"
            });
            players.Add(new OnlinePlayerModel()
            {
                UCID = "HHH",
                Name = "TotalBiscuitEaten",
                Role = "UH-1H",
                RoleImage = "Images/role/role-uh1h-30x30.png",
                Side = "Red",
                Ping = "35ms"
            });
            return players;
        }

        List<ServerModel> IDAL.GetServers()
        {
            List<ServerModel> servers = new List<ServerModel>();
            servers.Add(new ServerModel
            {
                ServerID = 1,
                ServerName = "Demo Server",
                IPAddress = "127.0.0.1",
                OnlinePlayers = 5,
                RestartTime = new TimeSpan(3, 30, 0),
                Status = "Online"
            });
            servers.Add(new ServerModel
            {
                ServerID = 2,
                ServerName = "Development Server",
                IPAddress = "192.105.24.87",
                OnlinePlayers = 1,
                RestartTime = new TimeSpan(4, 0, 0),
                Status = "Offline"
            });
            servers.Add(new ServerModel
            {
                ServerID = 3,
                ServerName = "Clan KI Server",
                IPAddress = "188.82.43.3",
                OnlinePlayers = 32,
                RestartTime = new TimeSpan(1, 32, 0),
                Status = "Restarting"
            });
            return servers;
        }

        private List<MapLayerModel> GetLayers(int mapID)
        {
            List<MapLayerModel> layers = new List<MapLayerModel>();
            layers.Add(new MapLayerModel(new Resolution(1880, 1041), "Images/map/map-1880x1041.png"));
            layers.Add(new MapLayerModel(new Resolution(2685, 1487), "Images/map/map-2685x1487.png"));
            return layers;
        }

        List<AirportModel> IDAL.GetAirports(int serverID)
        {
            List<AirportModel> airports = new List<AirportModel>
            {
                new AirportModel()
                {
                    ID = 1,
                    Name = "Beslan Airport",
                    LatLong = "43 11.537'N   44 34.866'E",
                    MGRS = "38T MN 65962 82253",
                    Status = "Online",
                    Type = "AIRPORT",
                    Pos = new Position(803123.5, -170446.28125),
                    Image = "Images/markers/airport-red-200x200.png"
                },

                new AirportModel()
                {
                    ID = 2,
                    Name = "FARP Elburs",
                    LatLong = "43 11.537'N   44 34.866'E",
                    MGRS = "38T MN 65962 82253",
                    Status = "Online",
                    Type = "FARP",
                    Pos = new Position(853123.5, -170446.28125),
                    Image = "Images/markers/farp-red-200x200.png"
                },

                new AirportModel()
                {
                    ID = 3,
                    Name = "FARP Timoor",
                    LatLong = "43 11.537'N   44 34.866'E",
                    MGRS = "38T MN 65962 82253",
                    Status = "Online",
                    Type = "FARP",
                    Pos = new Position(873123.5, -160446.28125),
                    Image = "Images/markers/farp-blue-200x200.png"
                },

                new AirportModel()
                {
                    ID = 4,
                    Name = "FARP Timoor",
                    LatLong = "43 11.537'N   44 34.866'E",
                    MGRS = "38T MN 65962 82253",
                    Status = "Online",
                    Type = "AIRPORT",
                    Pos = new Position(893123.5, -140446.28125),
                    Image = "Images/markers/airport-blue-200x200.png"
                }
            };

            return airports;
        }

        MarkerViewModel IDAL.GetMarkers(int serverID)
        {
            MarkerViewModel mm = new MarkerViewModel()
            {
                Depots = ((IDAL)this).GetDepots(serverID),
                CapturePoints = ((IDAL)this).GetCapturePoints(serverID),
                Airports = ((IDAL)this).GetAirports(serverID)
            };

            return mm;
        }

        List<ServerModel> IDAL.GetServers(ref MySqlConnection conn)
        {
            return ((IDAL)this).GetServers();
        }

        List<DepotModel> IDAL.GetDepots(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetDepots(serverID);
        }

        List<CapturePointModel> IDAL.GetCapturePoints(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetCapturePoints(serverID);
        }

        List<MapLayerModel> IDAL.GetMapLayers(int mapID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetMapLayers(mapID);
        }

        List<OnlinePlayerModel> IDAL.GetOnlinePlayers(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetOnlinePlayers(serverID);
        }

        GameMapModel IDAL.GetGameMap(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetGameMap(serverID);
        }

        GameModel IDAL.GetGame(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetGame(serverID);
        }

        List<AirportModel> IDAL.GetAirports(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetAirports(serverID);
        }

        MarkerViewModel IDAL.GetMarkers(int serverID, ref MySqlConnection conn)
        {
            return ((IDAL)this).GetMarkers(serverID);
        }
    }
}