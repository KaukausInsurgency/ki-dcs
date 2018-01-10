using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;

namespace SlingloadEventsWatcher
{
    class Program
    {

        static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.WriteLine("Invalid Arguments Provided - expected 2 arguments : [1] DCS.log directory path [2] Slingload events write directory");
                Console.ReadKey();
                return;
            }
            else if (!Directory.Exists(args[0]))
            {
                Console.WriteLine("Invalid Arguments Provided - path '" + args[0] + "' cannot be found");
                Console.ReadKey();
                return;
            }
            else if (!Directory.Exists(args[1]))
            {
                Console.WriteLine("Invalid Arguments Provided - path '" + args[1] + "' cannot be found");
                Console.ReadKey();
                return;
            }

            string path = args[0];
            string writePath = args[1];
            string ChoosingCargoString = "DCS: CargoManager::choosingCargo:";
            string HookCargoString = "DCS: chooseCargo:";
            string UnhookCargoString = "DCS: unhookCargo:";
            string CargoCrashString = "DCS: cargoCrashed:";

            AutoResetEvent wh = new AutoResetEvent(false);
            FileSystemWatcher fsw = new FileSystemWatcher(path)
            {
                Filter = "dcs.log",
                EnableRaisingEvents = true
            };
            fsw.Changed += (s, e) => wh.Set();

            Console.WriteLine("Watching for slingload events in dcs.log...");

            FileStream fs = new FileStream(path + "\\dcs.log", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            using (var sr = new StreamReader(fs))
            {
                string s = "";
                Dictionary<string, string> hash = new Dictionary<string, string>();
                int filecount = 0;
                long filesize = fs.Length;
                while (true)
                {
                    // if the file size has been reduced (ie because DCS restart) then reset the stream position back to 0 to read from the beginning of the file again
                    if (fs.Length < filesize)
                    {
                        Console.WriteLine("dcs.log has been refreshed - detecting DCS start up");
                        fs.Seek(0, SeekOrigin.Begin);
                        filesize = fs.Length;
                    }
                    else if (fs.Length > filesize)
                    {
                        filesize = fs.Length;
                        Console.WriteLine("dcs.log size: " + filesize + " bytes");
                    }

                    while (true)
                    {
                        try
                        {
                            s = sr.ReadLine();
                            if (s == null)
                                break;

                            if (s.Contains(ChoosingCargoString))
                            {
                                int startIndex = s.IndexOf(ChoosingCargoString) + ChoosingCargoString.Length;
                                int lastIndex = s.IndexOf(' ', startIndex) - startIndex;

                                string cargoID = s.Substring(startIndex, lastIndex);
                                string heliID = "";

                                if (s.Contains("HelId:"))
                                {
                                    int sIndex = s.IndexOf("HelId:") + "HeliID".Length;
                                    int lIndex = s.Length - sIndex;
                                    heliID = s.Substring(sIndex, lIndex);
                                }
                                Console.WriteLine("DCS: Player Choosing Cargo (heliID: " + heliID + ", cargoID: " + cargoID + ")");
                                hash[heliID] = cargoID;
                            }
                            else if (s.Contains(HookCargoString))
                            {
                                int startIndex = s.IndexOf(HookCargoString) + HookCargoString.Length;
                                int lastIndex = s.Length - startIndex;
                                string heliID = s.Substring(startIndex, lastIndex);
                                double time = double.Parse(s.Substring(0, 9), NumberStyles.Any);
                                if (hash.ContainsKey(heliID))
                                {
                                    Console.WriteLine("DCS: Player Hooked Cargo (heliID: " + heliID + ", cargoID: " + hash[heliID] + ")");
                                    string luastring = "local t = {\n\t[\"Event\"] = \"HOOK\", [\"HeliID\"] = \"" + heliID + "\", [\"CargoID\"] = \"" + hash[heliID] + "\", [\"Time\"] = " + time + "\n}\nreturn t";
                                    File.WriteAllText(writePath + "\\sl_eh_" + filecount + ".lua", luastring);
                                    filecount++;
                                }
                                else
                                {
                                    Console.WriteLine("WARNING - Could not find heliID in hash (heliID: " + heliID + ")");
                                }
                            }
                            else if (s.Contains(UnhookCargoString))
                            {
                                int startIndex = s.IndexOf(UnhookCargoString) + UnhookCargoString.Length;
                                int lastIndex = s.Length - startIndex;
                                string heliID = s.Substring(startIndex, lastIndex);
                                double time = double.Parse(s.Substring(0, 9), NumberStyles.Any);
                                if (hash.ContainsKey(heliID))
                                {
                                    Console.WriteLine("DCS: Player Unhooked Cargo (heliID: " + heliID + ", cargoID: " + hash[heliID] + ")");
                                    string luastring = "local t = {\n\t[\"Event\"] = \"UNHOOK\", [\"HeliID\"] = \"" + heliID + "\", [\"CargoID\"] = \"" + hash[heliID] + "\", [\"Time\"] = " + time + "\n}\nreturn t";
                                    File.WriteAllText(writePath + "\\sl_eh_" + filecount + ".lua", luastring);
                                    filecount++;
                                }
                                else
                                {
                                    Console.WriteLine("WARNING - Could not find heliID in hash (heliID: " + heliID + ")");
                                }
                            }
                            else if (s.Contains(CargoCrashString))
                            {
                                int startIndex = s.IndexOf(CargoCrashString) + CargoCrashString.Length;
                                int lastIndex = s.Length - startIndex;
                                string cargoID = s.Substring(startIndex, lastIndex);
                                double time = double.Parse(s.Substring(0, 9), NumberStyles.Any);
                                if (hash.ContainsValue(cargoID))
                                {
                                    string heliID = hash.FirstOrDefault(x => x.Value == cargoID).Key;
                                    Console.WriteLine("DCS: Player Destroyed Cargo (heliID: " + heliID + ", cargoID: " + cargoID + ")");
                                    string luastring = "local t = {\n\t[\"Event\"] = \"UNHOOK_CRASH\", [\"HeliID\"] = \"" + heliID + "\", [\"CargoID\"] = \"" + cargoID + "\", [\"Time\"] = " + time + "\n}\nreturn t";
                                    File.WriteAllText(writePath + "\\sl_eh_" + filecount + ".lua", luastring);
                                    filecount++;
                                }
                                else
                                {
                                    Console.WriteLine("WARNING - Could not find heliID in hash (cargoID: " + cargoID + ")");
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Error encountered: " + ex.Message);
                            break;
                        }
                    }

                    wh.WaitOne(10000);  // timeout of 10 seconds if file has not changed
                }
            }

            wh.Close();
        }
    }
}
