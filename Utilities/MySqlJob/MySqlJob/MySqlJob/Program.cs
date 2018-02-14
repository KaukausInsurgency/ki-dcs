using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using MySql.Data;
using System.Net.Mail;
using MySql.Data.MySqlClient;
using System.IO;

namespace MySqlJob
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args == null)
            {
                Console.WriteLine("ERROR - no parameters specified");
                Console.ReadKey();
                return;
            }
            else if (args.Length != 1)
            {
                Console.WriteLine("ERROR - too many parameters specified");
                Console.ReadKey();
                return;
            }

            Config config;
            Console.WriteLine("Reading Config ...");

            try
            {
                config = new Config(args[0]);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error opening config file - " + ex.Message);
                Console.ReadKey();
                return;
            }


            JobMailer mail = new JobMailer(config.EmailTo, config.SMTP, config.EmailFrom, config.EmailFromPassword, config.Port, config.UseSSL);
            StringBuilder sb = new StringBuilder();

            if (config.SendTestEmail)
            {
                Console.WriteLine("Test Email Send is enabled - trying to send test email...");
                try
                {
                    mail.Send("NOREPLY: MySqlJob Test Email", "Hello,\nYou are receiving this email because a program was configured to alert you of notifications.\nIf you are not the correct recipient, please disregard this email.\nPlease do not reply to this email, as this inbox is not monitored.");
                    Console.WriteLine("Test Email was successfully sent");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error sending test email: " + ex.Message);
                    if (ex.InnerException != null)
                        Console.WriteLine("Exception Inner:   " + ex.InnerException);
                    Console.ReadKey();
                    return;
                }
            }

            Console.WriteLine("Attempting To Connect to database...");
            MySql.Data.MySqlClient.MySqlConnection DBConnect = new MySql.Data.MySqlClient.MySqlConnection(config.ConnectionString);
            try
            {
                DBConnect.Open();
                Console.WriteLine("Successful Connection to Database " + DBConnect.Database);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed To Connect to Database - " + ex.Message);
                sb.AppendLine("Failed To Connect to Database - " + ex.Message);
                mail.Send("NOREPLY: MySqlJob Job '" + config.Name + "' Failure", "Date of run: " + DateTime.Now.ToLongDateString() + "\nError: " + sb.ToString());
                return;
            }
            finally
            {
                if (DBConnect != null)
                    if (DBConnect.State == System.Data.ConnectionState.Open
                        || DBConnect.State == System.Data.ConnectionState.Connecting)
                        DBConnect.Close();
            }

            int CurrentStep = 0;
            bool JobFailed = false;
            try
            {
                sb.AppendLine("Opening Connection...");
                DBConnect.Open();
                sb.AppendLine("Connection Opened");
                foreach (var scriptfile in config.Steps)
                {
                    CurrentStep += 1;
                    sb.AppendLine("Starting Step " + CurrentStep + " (File: " + scriptfile + ")");
                    MySqlScript script = new MySqlScript(DBConnect, File.ReadAllText(scriptfile));
                    script.Delimiter = "$$";
                    int result = script.Execute();
                    sb.AppendLine("Step " + CurrentStep + " Result: " + result);
                    sb.AppendLine("Step " + CurrentStep + " Completed Successfully");
                }             
            }
            catch (Exception ex)
            {
                sb.AppendLine("Step " + CurrentStep + " Error - " + ex.Message);
                sb.AppendLine("Aborting Job");
                JobFailed = true;
            }
            finally
            {
                sb.AppendLine("Closing Connection...");  

                if (DBConnect != null)
                    if (DBConnect.State == System.Data.ConnectionState.Open || DBConnect.State == System.Data.ConnectionState.Connecting)
                        DBConnect.Close();

                sb.AppendLine("Connection Closed");
            }

            if (JobFailed)
            {
                sb.AppendLine("Job Failed - Sending Email");
                try
                {
                    mail.Send("NOREPLY: MySqlJob Job '" + config.Name + "' Failure", "Date of run: " + DateTime.Now.ToLongDateString() + "\nJob Log:\n" + sb.ToString());
                }
                catch (Exception ex)
                {
                    sb.AppendLine("An error occurred while trying to send email about job failure: " + ex.Message);
                }
            }
            else
            {
                sb.AppendLine("Job Completed Successfully");
            }
            string LogFileNameInfo = JobFailed ? "FAIL" : "PASS";
            string LogFileName = config.Name + "_" + DateTime.Now.ToString("yyyy-MM-dd-HH-mm") + "_" + LogFileNameInfo + ".log";
            File.WriteAllText(config.LogPath + "\\" + LogFileName, sb.ToString());
            return;
        }
    }
}
