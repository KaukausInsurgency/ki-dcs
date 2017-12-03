using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Classes
{
    public class Resolution
    {
        public double Width { get; set; }
        public double Height { get; set; }
        public Resolution(double w, double h)
        {
            Width = w;
            Height = h;
        }
    }
}