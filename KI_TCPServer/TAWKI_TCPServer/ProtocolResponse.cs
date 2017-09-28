using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TAWKI_TCPServer
{
    struct ProtocolResponseMultiData
    {
        public string Action;
        public bool Result;
        public string Error;
        public List<List<object>> Data;
    }

    struct ProtocolResponseSingleData
    {
        public string Action;
        public bool Result;
        public string Error;
        public List<object> Data;
    }
}
