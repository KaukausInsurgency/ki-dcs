$(document).ready(function () {

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

    function RenderDepotsFirstTime(modelObj, rootImgPath)
    {
        $(modelObj.Depots).each(function (i) {
            var ImagePoint = DCSPosToMapPos(this.Pos, modelObj.Map.DCSOriginPosition, modelObj.Map.Ratio);
            var Img = rootImgPath + this.Image;
            var tooltipid = "tip_depot_content_id_" + this.ID;
            var id_attribute = 'data-depotID="' + this.ID + '"';
            var dot = $('<img ' + id_attribute + ' class="mrk" src="' + Img + '" width="32" height="32" originleft="' + ImagePoint.x +
                '" origintop="' + ImagePoint.y + '" data-tooltip-content="#' + tooltipid + '"' + '"/>');
            dot.css({
                position: 'absolute',
                left: ImagePoint.x + "px",
                top: ImagePoint.y + "px"
            });
            $(".mapcontent").append(dot);

            // Render the tooltip contents
            var content = "<strong>" + this.Name + "</strong><br/>";
            content += "Status: " + this.Status + "<br/>";
            content += "<strong>Lat Long: " + this.LatLong + "</strong><br/>";
            content += "<strong>MGRS: " + this.MGRS + "</strong><br/><br/>";
            content += 'Capacity: ' + this.Capacity + '<br/>';   // get the overall capacity
            var arraytable = SplitStringIntoArrayTable(this.Resources, "|");     // now we convert this string into a json object    
            content += GenerateTableHTMLString(arraytable);                      // generate the html table from the json object
            var tooltipspan = $('<div class="tooltip_templates" style="display: none"><span id="' + tooltipid + '" style="font-size: 10px" >' + content + '</span></div>');
            $(".mapcontent").first().append(tooltipspan);
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
                '" origintop="' + ImagePoint.y + '" data-tooltip-content="#' + tooltipid + '"' + '"/>');
            dot.css({
                position: 'absolute',
                left: ImagePoint.x + "px",
                top: ImagePoint.y + "px"
            });
            $(".mapcontent").append(dot);

            var content = "<strong>" + this.Name + "</strong><br/>";
            content += "Type: " + this.Type + "<br/>";
            content += "Status: " + this.Status + "<br/>";
            content += "<strong>Lat Long: " + this.LatLong + "</strong><br/>";
            content += "<strong>MGRS: " + this.MGRS + "</strong><br/>";
            content += "Blue: " + this.BlueUnits + "<br/>";
            content += "Red: " + this.RedUnits + "<br/><br/>";       
            var arraytable = SplitStringIntoArrayTable(this.Resources, "|");     // now we convert this string into a json object    
            content += GenerateTableHTMLString(arraytable);                      // generate the html table from the json object
            var tooltipspan = $('<div class="tooltip_templates" style="display: none"><span id="' + tooltipid + '" style="font-size: 10px" >' + content + '</span></div>');
            $(".mapcontent").first().append(tooltipspan);
        });
    }

    function RenderMapFirstTime(modelObj, rootImgPath)
    {
        var headingcontent = $("<h2>Server: " + modelObj.ServerName + "</h2></br><h><b>Status: " + modelObj.Status + "</b></h></br><h><b>Restarts In: " + modelObj.RestartTime + "</b></h>");
        $("#Heading").append(headingcontent);

        RenderDepotsFirstTime(modelObj, rootImgPath);
        RenderCapturePointsFirstTime(modelObj, rootImgPath);

        $('.mrk').tooltipster({
            theme: 'tooltipster-noir'
        });      
    }

    RenderMapFirstTime(model, ROOT);

    // setup signalR
    $.connection.hub.logging = true;
    var GameHubProxy = $.connection.gameHub;    // apparently first letter is lowercase (signalr converts this)

    GameHubProxy.client.UpdateMarkers = function (modelObj) {
        $(modelObj.Depots).each(function (i) {
            var tooltipid = "tip_depot_content_id_" + this.ID;
            var content = "<strong>" + this.Name + "</strong><br/>";
            content += "Status: " + this.Status + "<br/>";
            content += "<strong>Lat Long: " + this.LatLong + "</strong><br/>";
            content += "<strong>MGRS: " + this.MGRS + "</strong><br/><br/>";
            content += 'Capacity: ' + this.Capacity + '<br/>';   // get the overall capacity
            var json_resources = SplitStringIntoArrayTable(this.Resources, "|");       // now we convert this string into a json object    
            content += GenerateTableHTMLString(json_resources);                         // generate the html table from the json object

            // locate the html content
            var img = $('[data-depotID=' + this.ID + ']');
            img.attr('src', ROOT + this.Image);   
            $('#' + tooltipid).html(content);
            //var tooltipspan = $('<span id="' + tooltipid + '" style="font-size: 10px" >' + content + '</span>');
            //img.tooltipster('content', content);
        });

        $(modelObj.CapturePoints).each(function (i) {
            var tooltipid = "tip_cp_content_id_" + this.ID;
            var content = "<strong>" + this.Name + "</strong><br/>";
            content += "Type: " + this.Type + "<br/>";
            content += "Status: " + this.Status + "<br/>";
            content += "<strong>Lat Long: " + this.LatLong + "</strong><br/>";
            content += "<strong>MGRS: " + this.MGRS + "</strong><br/>";
            content += "Blue: " + this.BlueUnits + "<br/>";
            content += "Red: " + this.RedUnits + "<br/><br/>";
            var json_resources = SplitStringIntoArrayTable(this.Resources, "|");     // now we convert this string into a json object    
            content += GenerateTableHTMLString(json_resources);     // generate the html table from the json object
            var img = $('[data-capturepointID=' + this.ID + ']');
            img.attr('src', ROOT + this.Image);
            $('#' + tooltipid).html(content);
            //var tooltipspan = $('<span id="' + tooltipid + '" style="font-size: 10px" >' + content + '</span>');
            //img.append(tooltipspan);
            //img.tooltipster('content', content);
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