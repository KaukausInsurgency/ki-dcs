using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace TAWKI_TCPServer
{
    class ConfigReader
    {
        private string _configPath;
        private string _DBConnect;
        private int _portNumber;
        private int _maxConnections;
        private List<string> _whitelist;

        public ConfigReader()
        {
            _configPath = Directory.GetCurrentDirectory() + "\\config.xml";
            XmlDocument xml = new XmlDocument();
            try
            {
                xml.Load(_configPath);
                XmlNodeList dbxml = xml.GetElementsByTagName("DBConnect");
                XmlNodeList portxml = xml.GetElementsByTagName("Port");
                XmlNodeList maxConnxml = xml.GetElementsByTagName("MaxConnections");
                XmlNodeList whitelistxml = xml.GetElementsByTagName("WhiteList");

                if (dbxml.Count == 0)
                    throw new Exception("Could not find <DBConnect> in config");
                if (portxml.Count == 0)
                    throw new Exception("Could not find <Port> in config");
                if (maxConnxml.Count == 0)
                    throw new Exception("Could not find <MaxxConnections> in config");
                if (whitelistxml.Count == 0)
                    throw new Exception("Could not find <WhiteList> in config");

                _DBConnect = dbxml[0].InnerText;
                _portNumber = int.Parse(portxml[0].InnerText);
                _maxConnections = int.Parse(maxConnxml[0].InnerText);
                _whitelist = new List<String>(whitelistxml[0].InnerText.Split(';'));
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error - could not open or read config file (path: " + _configPath + ") - " + ex.Message + " - Using Default values");
                _portNumber = 9983;
                _maxConnections = 5;
                _DBConnect = "Server=localhost; Database=ko; Uid=root; Pwd=root;";
            }
        }

        public int PortNumber
        {
            get { return _portNumber; }
        }

        public int MaxConnections
        {
            get { return _maxConnections; }
        }

        public string DBConnect
        {
            get { return _DBConnect; }
        }

        public List<string> WhiteList
        {
            get { return _whitelist; }
        }
    }
}
