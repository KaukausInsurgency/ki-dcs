$(document).ready(function () {

    if (!model.Map.MapExists)
    {
        var headingcontent = $("<h2>Server: " + model.ServerName + "</h2></br><h><b>Status: " + model.Status + "</b></h></br><h><b>Restarts In: " + model.RestartTime +
                                "</b></h></br><h><b>Warning: No map was found for this server</b></h>");
        $("#Heading").append(headingcontent);
        return;
    }

    // async sleep function
    function Sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async function AnimateMarker(marker) {
        if (marker.hasClass("animating"))
        {
            return; // if the element is already being animated then do not attach another async animation
        }
        marker.toggleClass("animating");
        var timer = window.setInterval(function () {
            marker.toggleClass('animate');
        }, 1000);

        await Sleep(10000);

        if (timer) {
            window.clearInterval(timer);
            timer = null;
        };
        marker.removeClass("animate");
        marker.toggleClass("animating");
    };

    function IsStringEmptyOrWhitespace(str) {
        return str.length === 0 || !str.trim();
    }

    // splits a string and converts it into a json object
    function SplitStringIntoArrayTable(str, separator)
    {
        var tablearray = [];
        var rows = str.split("\n");
        for (var i = 0; i < rows.length; i++)
        {
            tablearray.push(rows[i].split(separator));
        }
        
        return tablearray;
    }

    function GenerateTableHTMLString(arraytable)
    {
        var table = '<table style="table-layout: fixed; width: 200px;">';
        var tr = "";
        for (var i = 0; i < arraytable.length; i++)
        {
            var cellwidth = Math.floor(100 / arraytable[i].length); 
            if (i === 0)
            {
                tr += '<thead><tr>';
                for (var j = 0; j < arraytable[i].length; j++) {
                    tr += '<td style="width:' + cellwidth + '%">' + arraytable[i][j] + '</td>';
                }
                tr += '</tr></thead><tbody>';
            }
            else
            {
                tr += '<tr>';
                for (var j = 0; j < arraytable[i].length; j++) {
                    tr += '<td style="width:' + cellwidth + '%">' + arraytable[i][j] + '</td>';
                }
                tr += '</tr>';
            }
        }

        table += tr + "</tbody></table>";
        return table;
    }

    function DCSPosToMapPos(point, originpoint, ratio)
    {
        var xSignHandle = originpoint.X < 0 ? -1 : 1;
        var ySignHandle = originpoint.Y < 0 ? -1 : 1;
        var normalizedX = point.X - originpoint.X;
        var normalizedY = point.Y - originpoint.Y;
        var imagepoint = {};
        imagepoint.x = (normalizedX * xSignHandle) / ratio;
        imagepoint.y = (normalizedY * ySignHandle) / ratio;
        return imagepoint;
    }

    function InitTooltip(elem)
    {
        elem.tooltipster({
            theme: 'tooltipster-noir',
            contentAsHTML: true,
            trigger: 'click',
            contentCloning: true
        });   
    }

    function RenderDepotContent(depotModel)
    {
        // Render the tooltip contents
        var content = "<strong>" + depotModel.Name + "</strong><br/>";
        content += "Status: " + depotModel.Status + "<br/>";
        content += "<strong>Lat Long: " + depotModel.LatLong + "</strong><br/>";
        content += "<strong>MGRS: " + depotModel.MGRS + "</strong><br/><br/>";
        content += 'Capacity: ' + depotModel.Capacity + '<br/>'; 
        var arraytable = SplitStringIntoArrayTable(depotModel.Resources, "|"); 
        content += GenerateTableHTMLString(arraytable);
        var tooltipcontent = '<div>' + content + '</div>';
        return tooltipcontent;
    }

    function RenderSideMissionContent(sidemissionmodel)
    {
        var content = "<strong>" + sidemissionmodel.Name + "</strong><br/>";
        content += "Time Remaining: " + sidemissionmodel.TimeRemaining + "<br/>";
        content += "Status: " + sidemissionmodel.Status + "<br/>";
        content += "<strong>Lat Long: " + sidemissionmodel.LatLong + "</strong><br/>";
        content += "<strong>MGRS: " + sidemissionmodel.MGRS + "</strong><br/><br/>";
        if (sidemissionmodel.Desc.length < 50) {
            content += sidemissionmodel.Desc;
        }
        else {
            content += sidemissionmodel.Desc.substr(0, 49) + "...";
        }
        var tooltipcontent = '<div>' + content + '</div>';
        return tooltipcontent;
    }

    function RenderCapturePointContent(capturepointmodel)
    {
        var content = "<strong>" + capturepointmodel.Name + "</strong><br/>";
        content += "Type: " + capturepointmodel.Type + "<br/>";
        content += "Status: " + capturepointmodel.Status + "<br/>";
        content += "<strong>Lat Long: " + capturepointmodel.LatLong + "</strong><br/>";
        content += "<strong>MGRS: " + capturepointmodel.MGRS + "</strong><br/>";
        content += "Blue: " + capturepointmodel.BlueUnits + "<br/>";
        content += "Red: " + capturepointmodel.RedUnits + "<br/>";
        content += "Capacity: " + capturepointmodel.MaxCapacity;
        if (capturepointmodel.Text.length !== 0)
        {
            content += "<br/><br/>";
        }
        content += capturepointmodel.Text + "<br/>";
        var tooltipcontent = '<div>' + content + '</div>';
        return tooltipcontent;
    }

    function RenderDepotsFirstTime(modelObj, rootImgPath)
    {
        $(modelObj.Depots).each(function (i) {
            var ImagePoint = DCSPosToMapPos(this.Pos, modelObj.Map.DCSOriginPosition, modelObj.Map.Ratio);
            var Img = rootImgPath + this.Image;
            var id_attribute = 'data-depotID="' + this.ID + '"';
            var dot = $('<img ' + id_attribute + ' class="mrk" src="' + Img + '" width="32" height="32" originleft="' + ImagePoint.x +
                '" origintop="' + ImagePoint.y + '" />');
            dot.css({
                position: 'absolute',
                left: ImagePoint.x + "px",
                top: ImagePoint.y + "px"
            });
            $(".mapcontent").append(dot);

            var model = this;
            var elem = $('[' + id_attribute + ']');
            InitTooltip(elem);
            var instances = $.tooltipster.instances('[' + id_attribute + ']');
            $.each(instances, function (i, instance) {
                instance.content(RenderDepotContent(model));
            });
        });
    }

    function RenderCapturePointsFirstTime(modelObj, rootImgPath)
    {
        $(model.CapturePoints).each(function (i) {
            var ImagePoint = DCSPosToMapPos(this.Pos, modelObj.Map.DCSOriginPosition, modelObj.Map.Ratio);
            var Img = rootImgPath + this.Image;
            var tooltipid = "tip_cp_content_id_" + this.ID;
            var id_attribute = 'data-capturepointID="' + this.ID + '"';
            var dot = $('<img ' + id_attribute + ' class="mrk" src="' + Img + '" width="32" height="32" originleft="' + ImagePoint.x +
                '" origintop="' + ImagePoint.y + '" />');
            dot.css({
                position: 'absolute',
                left: ImagePoint.x + "px",
                top: ImagePoint.y + "px"
            });
            $(".mapcontent").append(dot);
            var elem = $('[' + id_attribute + ']');
            InitTooltip(elem);
            var model = this;
            var instances = $.tooltipster.instances('[' + id_attribute + ']');
            $.each(instances, function (i, instance) {
                instance.content(RenderCapturePointContent(model));
            });      
        });
    }

    function RenderSideMissionsFirstTime(modelObj, rootImgPath) {
        $(model.Missions).each(function (i) {
            var ImagePoint = DCSPosToMapPos(this.Pos, modelObj.Map.DCSOriginPosition, modelObj.Map.Ratio);
            var Img = rootImgPath + this.Image;
            var tooltipid = "tip_sm_content_id_" + this.ID;
            var id_attribute = 'data-sidemissionID="' + this.ID + '"';
            var dot = $('<img ' + id_attribute + ' class="mrk" src="' + Img + '" width="32" height="32" originleft="' + ImagePoint.x +
                '" origintop="' + ImagePoint.y + '" />');
            dot.css({
                position: 'absolute',
                left: ImagePoint.x + "px",
                top: ImagePoint.y + "px"
            });
            $(".mapcontent").append(dot);
            var elem = $('[' + id_attribute + ']');
            InitTooltip(elem);
            var model = this;
            var instances = $.tooltipster.instances('[' + id_attribute + ']');
            $.each(instances, function (i, instance) {
                instance.content(RenderSideMissionContent(model));
            });     
        });
    }

    function RenderMapFirstTime(modelObj, rootImgPath)
    {
        var headingcontent = $("<h2>Server: " + modelObj.ServerName + "</h2></br><h><b>Status: " + modelObj.Status + "</b></h></br><h><b>Restarts In: " + modelObj.RestartTime + "</b></h>");
        $("#Heading").append(headingcontent);

        RenderDepotsFirstTime(modelObj, rootImgPath);
        RenderCapturePointsFirstTime(modelObj, rootImgPath);
        RenderSideMissionsFirstTime(modelObj, rootImgPath);
    }

    RenderMapFirstTime(model, ROOT);
    var G_DCSOriginPos = model.Map.DCSOriginPosition;
    var G_MapRatio = model.Map.Ratio;

    // setup signalR
    $.connection.hub.logging = true;
    var GameHubProxy = $.connection.gameHub;    // apparently first letter is lowercase (signalr converts this)

    GameHubProxy.client.UpdateMarkers = function (modelObj) {
        $(modelObj.Depots).each(function (i) {
            // locate the html content
            var img = $('[data-depotID=' + this.ID + ']');
            img.attr('src', ROOT + this.Image);   
            var model = this;
            var instances = $.tooltipster.instances('[data-depotID=' + this.ID + ']');
            $.each(instances, function (i, instance) {
                instance.content(RenderDepotContent(model));
            });     

            if (this.StatusChanged) 
            {
                AnimateMarker(img);
            }
        });

        $(modelObj.CapturePoints).each(function (i) {
            // locate the html content
            var img = $('[data-capturepointID=' + this.ID + ']');
            img.attr('src', ROOT + this.Image);
            var model = this;
            var instances = $.tooltipster.instances('[data-capturepointID=' + this.ID + ']');
            $.each(instances, function (i, instance) {
                instance.content(RenderCapturePointContent(model));
            });   

            if (this.StatusChanged) {
                AnimateMarker(img);
            }
        });

        $(modelObj.Missions).each(function (i) {   
            var imghtml = $('[data-sidemissionID=' + this.ID + ']');

            if (this.TimeInactive < 60 && imghtml.length > 0)
            {    
                imghtml.attr('src', ROOT + this.Image);
                var model = this;
                var instances = $.tooltipster.instances('[data-sidemissionID=' + this.ID + ']');
                $.each(instances, function (i, instance) {
                    instance.content(RenderSideMissionContent(model));
                });   
                if (this.StatusChanged) {
                    AnimateMarker(imghtml);
                }
            }
            else if (this.TimeInactive < 60 && imghtml.length === 0)
            {
                var ImagePoint = DCSPosToMapPos(this.Pos, G_DCSOriginPos, G_MapRatio);
                var Img = ROOT + this.Image;
                var id_attribute = 'data-sidemissionID="' + this.ID + '"';
                var dot = $('<img ' + id_attribute + ' class="mrk" src="' + Img + '" width="32" height="32" originleft="' + ImagePoint.x +
                    '" origintop="' + ImagePoint.y + '" />');
                dot.css({
                    position: 'absolute',
                    left: ImagePoint.x + "px",
                    top: ImagePoint.y + "px"
                });
                $(".mapcontent").append(dot);
                var elem = $('[' + id_attribute + ']');
                InitTooltip(elem);
                var model = this;
                var instances = $.tooltipster.instances('[' + id_attribute + ']');
                $.each(instances, function (i, instance) {
                    instance.content(RenderSideMissionContent(model));
                });   

                // animate the marker to indicate to user it was newly created
                AnimateMarker(elem);
            }
            else
            {
                $('[data-sidemissionID=' + this.ID + ']').remove();
            }
            
        });
    };

    GameHubProxy.client.UpdateOnlinePlayers = function (modelObj) {
        $('.clickable-row').remove();    // clear out the table
        $(modelObj).each(function (i) {
            var row = $('<tr class="clickable-row" playerUCID="' + this.UCID + '">\
                <td><img src="' + ROOT + this.RoleImage + '" />  ' + this.Role + '</td>\
                <td>' + this.Name + '</td>\
                <td>' + this.Side + '</td>\
                <td>' + this.Lives + '</td>\
                <td>' + this.Ping + '</td>\
                </tr>');

            $('.table > tbody:last-child').append(row); // add row to table
        });
    };

    $.connection.hub.start().done(function ()
    {

        $(window).bind('beforeunload', function () {
            var GHubProxy = $.connection.gameHub;
            GHubProxy.server.unsubscribe(model.ServerID);
        });

        var GHubProxy = $.connection.gameHub;
        GHubProxy.server.subscribe(model.ServerID);
    });
    
    $(".mrk").hover(
        function () {
            $(this).toggleClass('active');
        }, function () {
            $(this).removeClass('active');
        }
    );
    
        

    
});


$(document).ready(function () {
    $("#viewport").mapbox(
        {
            mousewheel: true,
            afterZoom: function (level, layer, xcoord, ycoord, totalWidth, totalHeight, viewport)
            {
                // xcoord and ycoord are the new left/top coordinates of the current image
                $(".mrk").each(function (i) {
                    var x = 0;
                    var y = 0;
                    if (totalHeight === null || totalHeight === undefined) {
                        x = parseInt($(this).attr("originleft"));
                        y = parseInt($(this).attr("origintop"));
                    }
                    else {
                        var ratio = totalHeight / viewport.offsetHeight;
                        x = parseInt($(this).attr("originleft")) * ratio;
                        y = parseInt($(this).attr("origintop")) * ratio;
                    }


                    //var x = parseInt($(this).css("left").replace("px", ""))
                    //var y = parseInt($(this).css("top").replace("px", ""))

                    $(this).css({
                        position: 'absolute',
                        left: x + "px",
                        top: y + "px"
                    });

                });
                

            }
        });
    $(".map-control a").click(function () { //control panel 
        var viewport = $("#viewport");
        // this.className is same as method to be called 
        if (this.className === "zoom" || this.className === "back") {
            viewport.mapbox(this.className, 2);//step twice 
        }
        else {
            viewport.mapbox(this.className);
        }
        return false;
    });
}); 