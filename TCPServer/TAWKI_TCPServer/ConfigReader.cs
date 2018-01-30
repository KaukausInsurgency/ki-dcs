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
        private bool _useUPnP;
        private bool _useWhiteList;
        private bool _configReadSuccess;
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
                XmlNodeList upnpxml = xml.GetElementsByTagName("UseUPnP");

                if (dbxml.Count == 0)
                    throw new Exception("Could not find <DBConnect> in config");
                if (portxml.Count == 0)
                    throw new Exception("Could not find <Port> in config");
                if (maxConnxml.Count == 0)
                    throw new Exception("Could not find <MaxConnections> in config");
                if (whitelistxml.Count == 0)
                    _useWhiteList = false;
                else
                    _useWhiteList = true;
                if (upnpxml.Count == 0)
                    _useUPnP = false;
         

                _DBConnect = dbxml[0].InnerText;
                _portNumber = int.Parse(portxml[0].InnerText);
                _maxConnections = int.Parse(maxConnxml[0].InnerText);

                if (_useWhiteList)
                    _whitelist = new List<String>(whitelistxml[0].InnerText.Split(';'));

                if (upnpxml.Count != 0 && (upnpxml[0].InnerText.ToUpper() == "YES" || upnpxml[0].InnerText.ToUpper() == "TRUE"))
                    _useUPnP = true;

                _configReadSuccess = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error - could not open or read config file (path: " + _configPath + ") - " + ex.Message);
                _configReadSuccess = false;
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

        public bool ConfigReadSuccess
        {
            get { return _configReadSuccess; }
        }

        public bool UseUPnP
        {
            get { return _useUPnP; }
        }

        public bool UseWhiteList
        {
            get { return _useWhiteList; }
        }

        public List<string> WhiteList
        {
            get { return _whitelist; }
        }
    }
}
