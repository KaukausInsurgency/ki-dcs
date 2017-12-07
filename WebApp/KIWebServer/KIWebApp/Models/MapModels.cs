using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using KIWebApp.Classes;

namespace KIWebApp.Models
{
    public class MapLayerModel
    {
        public Resolution Resolution { get; set; }
        public string ImagePath { get; set; }
        public MapLayerModel(Resolution res, string path)
        {
            Resolution = res;
            ImagePath = path;
        }
    }

    public class GameMapModel
    {
        public Resolution Resolution { get; set; }
        public string ImagePath { get; set; }
        public Position DCSOriginPosition { get; set; }
        public double Ratio;
        public List<MapLayerModel> Layers { get; set; }
    }
}