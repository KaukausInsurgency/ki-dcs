using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading;

namespace KIWebApp.Asyncs
{
    public class GameScheduler : IDisposable
    {
        private System.Threading.Timer timer;
        private int period;

        public GameScheduler(TimerCallback callback, int period)
        {
            this.period = period;
            timer = new System.Threading.Timer(callback, timer, 0, period);
        }

        public void Pause()
        {
            timer.Change(Timeout.Infinite, Timeout.Infinite);
        }

        public void Resume()
        {
            timer.Change(0, period);
        }

        public void Dispose()
        {
            timer.Dispose();
        }
    }
}