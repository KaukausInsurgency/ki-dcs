using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FizzWare.NBuilder;
using NUnit.Framework;

namespace KIWebApp.Tests
{
    [TestFixture]
    class IT_DAL
    {
        private static string DBConnect = "";

        [OneTimeSetUp]
        public void Setup()
        {
            DBConnect = System.Configuration.ConfigurationManager.ConnectionStrings["DBMySqlConnect"].ConnectionString;
        }


    }
}
