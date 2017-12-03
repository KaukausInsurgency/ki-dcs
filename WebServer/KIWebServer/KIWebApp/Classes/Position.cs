using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace KIWebApp.Classes
{
    public class Position
    {
        public double X { get; set; }
        public double Y { get; set; }
        public Position(double _x, double _y)
        {
            X = _x;
            Y = _y;
        }
    }
}