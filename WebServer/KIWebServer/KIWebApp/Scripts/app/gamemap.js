$(document).ready(function () {

    var headingcontent = $("<h2>Server: " + model.ServerName + "</h2></br><h>Restarts In: " + model.RestartTime + "</h>");
    $("#Heading").append(headingcontent);

    $(model.Depots).each(function (i) {
        var x = this.MapX;
        var y = this.MapY;
        var Img = ROOT + this.Image;
        var tooltipid = "tip_content_id_" + i;
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
        content += this.Resources.replace(/(?:\r\n|\r|\n)/g, '<br/>');

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