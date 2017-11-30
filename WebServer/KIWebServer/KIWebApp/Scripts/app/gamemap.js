$(document).ready(function () {

    function IsStringEmptyOrWhitespace(str) {
        return (str.length === 0 || !str.trim());
    };
    // splits a string and converts it into a json object
    function SplitStringIntoJSON(str, separator)
    {
        var jsonobj = {};
        var strings = str.split(separator);
        var key = "";
        for (var s in strings)
        {
            if (IsStringEmptyOrWhitespace(strings[s]))
                continue;

            if (s % 2 == 0)
            {
                jsonobj[strings[s]] = "";
                key = strings[s];
            }
            else
            {
                jsonobj[key] = strings[s];
            }
        }

        return jsonobj;

    };

    function GenerateTableHTMLString(keypair)
    {
        var table = '<table>';
        var tr = "";
        
        jQuery.each(keypair, function (name, value) {
            tr += '<tr><td>' + name + '</td><td>' + value + '</td></tr>';
        });

        table += tr + "</table>";
        return table;
    }

    var headingcontent = $("<h2>Server: " + model.ServerName + "</h2></br><h>Restarts In: " + model.RestartTime + "</h>");
    $("#Heading").append(headingcontent);

    $(model.Depots).each(function (i) {
        var x = this.MapX;
        var y = this.MapY;
        var Img = ROOT + this.Image;
        var tooltipid = "tip_depot_content_id_" + i;
        var dot = $('<img class="mrk" src="' + Img + '" width="32" height="32" originleft="' + x +
            '" origintop="' + y + '" data-tooltip-content="#' + tooltipid + '"' + '"/>');
        dot.css({
            position: 'absolute',
            left: x + "px",
            top: y + "px"
        });
        $(".mapcontent").append(dot);

        var content = "<strong>" + this.Name + "</strong><br/>"
        content += "Status: " + this.Status + "<br/>"
        content += "<strong>Lat Long: " + this.LatLong + "</strong><br/>"
        content += "<strong>MGRS: " + this.MGRS + "</strong><br/><br/>"

        var res = this.Resources.replace(/(?:\r\n|\r|\n)/g, '|');
        res = res.replace(/(?:  )/g, '');   // clean up the double spaces in the string

        res = res.substring(res.indexOf("|") + 1, res.length);  // remove the first part from the string (We dont need to show 'DWM - Depot')
        var capacity = res.substring(0, res.indexOf("|")) + '<br/>';   // get the overall capacity
        content += capacity;
        res = res.substring(res.indexOf("|") + 1, res.length);  // remove the capacity from the string
        var json_resources = SplitStringIntoJSON(res, "|");     // now we convert this string into a json object    
        content += GenerateTableHTMLString(json_resources);     // generate the html table from the json object
        //content += this.Resources.replace(/(?:\r\n|\r|\n)/g, '<br/>');
        var tooltipspan = $('<div class="tooltip_templates" style="display: none"><span id="' + tooltipid + '" style="font-size: 10px" >' + content + '</span></div>')      
        $(".mapcontent").append(tooltipspan);  
    });

    $(model.CapturePoints).each(function (i) {
        var x = this.MapX;
        var y = this.MapY;
        var Img = ROOT + this.Image;
        var tooltipid = "tip_cp_content_id_" + i;
        var dot = $('<img class="mrk" src="' + Img + '" width="32" height="32" originleft="' + x +
            '" origintop="' + y + '" data-tooltip-content="#' + tooltipid + '"' + '"/>');
        dot.css({
            position: 'absolute',
            left: x + "px",
            top: y + "px"
        });
        $(".mapcontent").append(dot);

        var content = "<strong>" + this.Name + "</strong><br/>"
        content += "Status: " + this.Status + "<br/>"
        content += "<strong>Lat Long: " + this.LatLong + "</strong><br/>"
        content += "<strong>MGRS: " + this.MGRS + "</strong><br/><br/>"
        content += "Blue: " + this.BlueUnits + "<br/>";
        content += "Red: " + this.RedUnits + "<br/>";
        var tooltipspan = $('<div class="tooltip_templates" style="display: none"><span id="' + tooltipid + '" style="font-size: 10px" >' + content + '</span></div>')
        $(".mapcontent").append(tooltipspan);
    });

    $('.mrk').tooltipster({
        theme: 'tooltipster-noir'
    });
});


$(document).ready(function () {
    $("#viewport").mapbox(
        {
            mousewheel: true,
            afterZoom: function (level, layer, xcoord, ycoord, totalWidth, totalHeight, viewport)
            {
                // xcoord and ycoord are the new left/top coordinates of the current image
                $(".mrk").each(function (i)
                {
                    var x = 0
                    var y = 0
                    if (totalHeight === null || totalHeight === undefined)
                    {
                        x = parseInt($(this).attr("originleft"))
                        y = parseInt($(this).attr("origintop"))
                    }
                    else
                    {
                        var ratio = totalHeight / viewport.offsetHeight
                        x = parseInt($(this).attr("originleft")) * ratio
                        y = parseInt($(this).attr("origintop")) * ratio
                    }
                    

                    //var x = parseInt($(this).css("left").replace("px", ""))
                    //var y = parseInt($(this).css("top").replace("px", ""))
                    
                    $(this).css({
                        position: 'absolute',
                        left: x + "px",
                        top: y + "px"
                    })
                    
                })
                

            }
        });
    $(".map-control a").click(function () { //control panel 
        var viewport = $("#viewport");
        // this.className is same as method to be called 
        if (this.className == "zoom" || this.className == "back") {
            viewport.mapbox(this.className, 2);//step twice 
        }
        else {
            viewport.mapbox(this.className);
        }
        return false;
    });
}); 