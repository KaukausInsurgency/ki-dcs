using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TAWKI_TCPServer
{
    class Program
    {
        static void Main(string[] args)
        {
            //if (args.Length != 2)
            //{
            //    Console.WriteLine("Invalid Arguments given - expected PORT MAXCONNECTIONS");
            //    return;
            //}
            ConfigReader cr = new ConfigReader();
            KIDB.DBConnection = cr.DBConnect;

            SocketServer server;
            try
            {
                SocketClient.SetHeartBeatResponse("{'type':'alive'}\n");
                //port = int.Parse(args[0]);
                //maxConn = int.Parse(args[1]);
                server = new SocketServer(cr.MaxConnections, cr.PortNumber);
                server.Open();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in creating Socket: " + ex.Message);
                return;
            }



            Console.WriteLine("Server is now running on: " + server.Address() + " - use F2 to close server");
            while(true)
            {
                if (Console.ReadKey().Key == ConsoleKey.F2)
                {
                    server.Close();
                    Console.WriteLine("Server Terminated");
                    return;
                }
            }
        }
    }
}
