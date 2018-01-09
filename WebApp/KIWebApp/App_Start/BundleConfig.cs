using System.Web;
using System.Web.Optimization;

namespace KIWebApp
{
    public class BundleConfig
    {
        // For more information on Bundling, visit http://go.microsoft.com/fwlink/?LinkId=254725
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryui").Include(
                        "~/Scripts/jquery-ui-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/knockout").Include(
                        "~/Scripts/knockout-{version}.js"));

            // Tooltips bundle
            bundles.Add(new ScriptBundle("~/bundles/tooltipster").Include(
                "~/Scripts/tooltipster/tooltipster.bundle.js"));

            // dynatable bundle
            bundles.Add(new ScriptBundle("~/bundles/dynatable").Include(
                "~/Scripts/dynatable/jquery.dynatable.js"));

            bundles.Add(new ScriptBundle("~/bundles/signalr").Include(
                "~/Scripts/jquery.signalR-2.2.2.js"));

            bundles.Add(new ScriptBundle("~/bundles/app").Include(
                "~/Scripts/app/registertable.js"));

            // Game Map bundle
            bundles.Add(new ScriptBundle("~/bundles/gamemap").Include(
                "~/Scripts/mapbox/jquery.mapbox.js",
                "~/Scripts/mapbox/jquery.mousewheel.js",
                "~/Scripts/app/gamemap.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/statistics").Include(
                        "~/Scripts/app/dashboard-overall.js"));




            bundles.Add(new StyleBundle("~/Content/themes/base/css").Include(
                        "~/Content/themes/base/jquery.ui.core.css",
                        "~/Content/themes/base/jquery.ui.resizable.css",
                        "~/Content/themes/base/jquery.ui.selectable.css",
                        "~/Content/themes/base/jquery.ui.accordion.css",
                        "~/Content/themes/base/jquery.ui.autocomplete.css",
                        "~/Content/themes/base/jquery.ui.button.css",
                        "~/Content/themes/base/jquery.ui.dialog.css",
                        "~/Content/themes/base/jquery.ui.slider.css",
                        "~/Content/themes/base/jquery.ui.tabs.css",
                        "~/Content/themes/base/jquery.ui.datepicker.css",
                        "~/Content/themes/base/jquery.ui.progressbar.css",
                        "~/Content/themes/base/jquery.ui.theme.css"));

            bundles.Add(new StyleBundle("~/Content/bootstrap").Include(
                        "~/Content/bootstrap.css",
                        "~/Content/bootstrap-theme.css"));

            bundles.Add(new StyleBundle("~/Content/tooltipster").Include(
                        "~/Content/tooltipster/tooltipster.bundle.min.css"));

            bundles.Add(new StyleBundle("~/Content/dynatable").Include(
                "~/Content/dynatable/jquery.dynatable.css"));

            bundles.Add(new StyleBundle("~/Content/app").Include(
                "~/Content/app/app.css"));

            bundles.Add(new StyleBundle("~/Content/statistics").Include(
                "~/Content/app/dashboard-overall.css"));
        }
    }
}