using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace MySqlJob
{
    class Config
    {
        public List<string> Steps { get; }
        public string Name { get; }
        public string EmailFrom { get; }
        public string EmailFromPassword { get; }
        public string EmailTo { get; }
        public string SMTP { get; }
        public int Port { get; }
        public bool UseSSL { get; }
        public string LogPath { get; }
        public string ConnectionString { get; }
        public bool SendTestEmail { get; }
        public Config(string path)
        {
            XmlDocument xml = new XmlDocument();
            xml.Load(path);

            SendTestEmail = false;
            if (xml.SelectSingleNode("//Name") == null)
            {
                throw new Exception("<Name> not found in config xml");
            }
            else if (xml.SelectSingleNode("//Steps/Step") == null)
            {
                throw new Exception("<Steps><Step> not found in config xml");
            }
            else if (xml.SelectSingleNode("//EmailAccount") == null)
            {
                throw new Exception("<EmailAccount> not found in config xml");
            }
            else if (xml.SelectSingleNode("//EmailAccount").Attributes["Email"] == null)
            {
                throw new Exception("<EmailAccount> attribute 'Email' not found in config xml");
            }
            else if (xml.SelectSingleNode("//EmailAccount").Attributes["Password"] == null)
            {
                throw new Exception("<EmailAccount> attribute 'Password' not found in config xml");
            }
            else if (xml.SelectSingleNode("//EmailTo") == null)
            {
                throw new Exception("<EmailTo> not found in config xml");
            }
            else if (xml.SelectSingleNode("//SMTP") == null)
            {
                throw new Exception("<SMTP> not found in config xml");
            }
            else if (xml.SelectSingleNode("//SMTP").Attributes["Server"] == null)
            {
                throw new Exception("<SMTP> attribute 'Server' not found in config xml");
            }
            else if (xml.SelectSingleNode("//SMTP").Attributes["Port"] == null)
            {
                throw new Exception("<SMTP> attribute 'Port' not found in config xml");
            }
            else if (xml.SelectSingleNode("//SMTP").Attributes["UseSSL"] == null)
            {
                throw new Exception("<SMTP> attribute 'UseSSL' not found in config xml");
            }
            else if (xml.SelectSingleNode("//ConnectionString") == null)
            {
                throw new Exception("<ConnectionString> not found in config xml");
            }
            else if (xml.SelectSingleNode("//LogPath") == null)
            {
                throw new Exception("<LogPath> not found in config xml");
            }
            else if (!Directory.Exists(xml.SelectSingleNode("//LogPath").InnerText))
            {
                throw new Exception("<LogPath> - path '" + xml.SelectSingleNode("//LogPath").InnerText + "' not found");
            }

            Name = xml.SelectSingleNode("//Name").InnerText;
            EmailFrom = xml.SelectSingleNode("//EmailAccount").Attributes["Email"].InnerText;
            EmailFromPassword = xml.SelectSingleNode("//EmailAccount").Attributes["Password"].InnerText;
            EmailTo = xml.SelectSingleNode("//EmailTo").InnerText;
            SMTP = xml.SelectSingleNode("//SMTP").Attributes["Server"].InnerText;
            Port = Convert.ToInt32(xml.SelectSingleNode("//SMTP").Attributes["Port"].InnerText);
            UseSSL = Convert.ToBoolean(xml.SelectSingleNode("//SMTP").Attributes["UseSSL"].InnerText);
            LogPath = xml.SelectSingleNode("//LogPath").InnerText;
            ConnectionString = xml.SelectSingleNode("//ConnectionString").InnerText;
            Steps = xml.SelectNodes("//Steps/Step").Cast<XmlNode>()
                                                   .Select(node => node.InnerText)
                                                   .ToList();

            if (xml.SelectSingleNode("//TestEmail") != null)
            {
                string val = xml.SelectSingleNode("//TestEmail").InnerText.ToLower();
                if (val == "true" || val == "yes")
                    SendTestEmail = true;
            }
        }
    }
}
