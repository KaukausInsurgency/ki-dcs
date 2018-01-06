using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Models
{
    public class SearchResultsModel
    {
        public SearchResultsModel()
        {
            PlayerResults = new List<PlayerModel>();
            ServerResults = new List<ServerModel>();
        }
        public List<PlayerModel> PlayerResults;
        public List<ServerModel> ServerResults;
    }
}