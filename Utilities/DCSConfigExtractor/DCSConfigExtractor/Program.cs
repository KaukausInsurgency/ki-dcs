using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DCSConfigExtractor
{
    class Program
    {
        private const string DCS_DB_PATH = "Scripts\\Database";
        private const string DCS_HELI_FOLDER = "helicopters";
        private const string DCS_SHIPS_FOLDER = "navy";
        private const string DCS_PLANES_FOLDER = "planes";
        private const string DCS_VEH_FOLDER = "vehicles";

        static void Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("Invalid Arguments");
                Console.WriteLine("DCSConfigExtractor.exe \"DCSPATH\"");
                Console.ReadKey();
                return;
            }
            string DCSPATH = args[0];
            string DCS_DB_FULL_PATH = DCSPATH + "\\" + DCS_DB_PATH;

            if (!Directory.Exists(DCSPATH))
            {
                Console.WriteLine("Invalid Path - Path cannot be found");
                Console.ReadKey();
                return;
            }
            else if (!Directory.Exists(DCS_DB_FULL_PATH))
            {
                Console.WriteLine("Invalid Path - Could not find DCS folders - please ensure path parameter points to parent DCS install folder");
                Console.ReadKey();
                return;
            }

            string LuaString = @"
KI.Defines.WeaponCategories =
{
  [Weapon.Category.SHELL] = ""SHELL"",
  [Weapon.Category.MISSILE] = ""MISSILE"",
  [Weapon.Category.ROCKET] = ""ROCKET"",
  [Weapon.Category.BOMB] = ""BOMB""
}

KI.Defines.UnitCategories =
{
  [Unit.Category.AIRPLANE] = ""AIR"",
  [Unit.Category.HELICOPTER] = ""HELICOPTER"",
  [Unit.Category.GROUND_UNIT] = ""GROUND"",
  [Unit.Category.SHIP] = ""SHIP"",
  [Unit.Category.STRUCTURE] = ""STRUCTURE""
}

KI.Defines.UnitTypes = 
{";

            Dictionary<string, string> entries = new Dictionary<string, string>();


            // Vehicles
            Console.WriteLine("Processing Path: " + DCS_DB_FULL_PATH + "\\" + DCS_VEH_FOLDER);
            foreach (string f in Directory.GetFiles(DCS_DB_FULL_PATH + "\\" + DCS_VEH_FOLDER, "*.lua", SearchOption.AllDirectories))
            {
                DirectoryInfo dir = new DirectoryInfo(System.IO.Path.GetDirectoryName(f));

                string category = "";
                switch (dir.Name.ToUpper()) 
                {
                    case "HOWITZERS":
                            category = "ARTILLERY";
                            break;
                    case "MLRS":
                            category = "MLRS";
                            break;
                    case "STRUCTURES":
                            category = "FORTIFICATION";
                            break;
                    case "TRAINS":
                            category = "FORTIFICATION";
                            break;
                    default:
                            category = "";
                            break;
                }

                string content = File.ReadAllText(f);

                if (String.IsNullOrWhiteSpace(category))
                {
                    category = GetLuaString(ref content, "GT.attribute");
                    switch (category.ToUpper())
                    {
                        case "FORTIFICATIONS":
                                category = "FORTIFICATION";
                                break;
                        case "TANKS":
                                category = "TANK";
                                break;
                        case "ARTILLERY":
                                category = "ARTILLERY";
                                break;
                        case "INFANTRY":
                                category = "INFANTRY";
                                break;
                        case "AA_MISSILE":
                                category = "SAM";
                                break;
                        case "AA_FLAK":
                                category = "AAA";
                                break;
                        case "SAM CC":
                                category = "SAM_CC";
                                break;
                        case "TRUCKS":
                                category = "TRUCK";
                                break;
                        case "SAM SR":
                                category = "SAM_RADAR";
                                break;
                        case "MR SAM":
                                category = "SAM_RADAR";
                                break;
                        case "LR SAM":
                                category = "SAM_RADAR";
                                break;
                        case "CARS":
                                category = "CAR";
                                break;
                        case "MANPADS AUX":
                                category = "MANPADS";
                                break;
                    }
                }
                string name = GetLuaString(ref content, "GT.Name");
                if (String.IsNullOrWhiteSpace(name))
                    name = GetLuaString(ref content, "GT.DisplayName");
                if (content.Contains("SAM CC") && category == "TRUCK")
                    category = "SAM_CC";
                Console.WriteLine("Processed " + name);
                entries.Add(name, category);
            }




            Console.WriteLine("Processing Path: " + DCS_DB_FULL_PATH + "\\" + DCS_PLANES_FOLDER);
            // Planes
            foreach (string f in Directory.GetFiles(DCS_DB_FULL_PATH + "\\" + DCS_PLANES_FOLDER, "*.lua", SearchOption.AllDirectories))
            {     
                string category = "";
                string content = File.ReadAllText(f);
                category = GetLuaString(ref content, "attribute");
                switch (category.ToUpper())
                {
                    case "BATTLEPLANES":
                        category = "STRIKER";
                        break;
                    case "AWACS":
                        category = "AWACS";
                        break;
                    case "TRANSPORTS":
                        category = "TRANSPORT";
                        break;
                    case "STRATEGIC BOMBERS":
                        category = "BOMBER";
                        break;
                    case "BOMBERS":
                        category = "BOMBER";
                        break;
                    case "FIGHTERS":
                        category = "FIGHTER";
                        break;
                    case "INTERCEPTORS":
                        category = "FIGHTER";
                        break;
                    case "MULTIROLE FIGHTERS":
                        category = "MULTIROLE";
                        break;
                    case "TANKERS":
                        category = "TANKER";
                        break;
                    case "UAVS":
                        category = "UAV";
                        break;
                }
                string name = GetLuaString(ref content, "return plane(");
                if (name == "MiG-25RBT" || name == "Su-24MR")
                    category = "FIGHTER";
                else if (name == "S-3B Tanker")
                    category = "TANKER";
                else if (name == "S-3B")
                    category = "STRIKER";

                Console.WriteLine("Processed " + name);
                entries.Add(name, category);
            }





            Console.WriteLine("Processing Path: " + DCS_DB_FULL_PATH + "\\" + DCS_HELI_FOLDER);
            // Helicopters
            foreach (string f in Directory.GetFiles(DCS_DB_FULL_PATH + "\\" + DCS_HELI_FOLDER, "*.lua", SearchOption.AllDirectories))
            {
                string category = "";
                string content = File.ReadAllText(f);
                category = GetLuaString(ref content, "attribute");
                switch (category.ToUpper())
                {
                    case "ATTACK HELICOPTERS":
                        category = "ATTACK_HELO";
                        break;
                    case "TRANSPORT HELICOPTERS":
                        category = "TRANSPORT_HELO";
                        break;
                }
                string name = GetLuaString(ref content, "return helicopter(");
                if (name == "Mi-8MT" || name == "UH-1H")
                    category = "TRANSPORT_HELO";
                Console.WriteLine("Processed " + name);
                entries.Add(name, category);
            }


            var items = from pair in entries
                        orderby pair.Value descending,
                                pair.Key
                        select pair;

            string currentcat = "";
            foreach (var pair in items)
            {
                if (currentcat == "")
                {
                    currentcat = pair.Value;
                }
                else if(currentcat != pair.Value)
                {
                    currentcat = pair.Value;
                    LuaString += "\n";
                }
                LuaString += "\n\t[\"" + pair.Key + "\"] = \"" + pair.Value + "\",";
            }
            LuaString += "\n}";
            string LuaPath = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            File.WriteAllText(LuaPath + "\\KI_Defines.lua", LuaString);

            Console.WriteLine("Completed - wrote to file: " + LuaPath + "\\KI_Defines.lua");
            Console.ReadKey();
        }


        private static string GetLuaString(ref string content, string toMatch)
        {
            string result = "";
            if (content.Contains(toMatch))
            {
                int lineIndex = content.IndexOf(toMatch);
                int firstQuoteIndex = content.IndexOf("\"", lineIndex);
                int secondQuoteIndex = content.IndexOf("\"", firstQuoteIndex + 1);
                int length = secondQuoteIndex - firstQuoteIndex - 1;
                result = content.Substring(firstQuoteIndex + 1, length);            
            }
            return result;
        }
    }
}
