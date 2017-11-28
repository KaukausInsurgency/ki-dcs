$(document).ready(function () {
    /*
    $('#GameMap').prepend($('<img>',
        {
            id: 'GameMapImg',
            src: MapImg,
            height: "697",
            width: "1307",
            class: "rounded"
        }))
    */
    var coords = [[504, 84]];

    $(coords).each(function (i) {
        var pos = this;
        var dot = $('<img class="mrk" src="' + DepotImg + '" width="32" height="32" originleft="' + pos[0] + '" origintop="' + pos[1] + '"/>');
        dot.css({
            position: 'absolute',
            left: pos[0] + "px",
            top: pos[1] + "px"
        });
        $(".mapcontent").append(dot);
    });

});


$(document).ready(function () {
    $("#viewport").mapbox(
        {
            mousewheel: true,
            afterZoom: function (level, layer, xcoord, ycoord, xscale, yscale, viewport)
            {
                // xcoord and ycoord are the new left/top coordinates of the current image
                $(".mrk").each(function (i)
                {
                    var scaleX = xcoord / viewport.offsetWidth 
                    var scaleY = ycoord / viewport.offsetHeight
                    var width = parseInt($(this).attr("width").replace("px", ""))
                    var height = parseInt($(this).attr("height").replace("px", ""))
                    var offx = parseInt($(this).attr("originleft")) - xcoord * scaleX
                    var offy = parseInt($(this).attr("origintop")) - ycoord * scaleY
                    var x = offx - width / 2
                    var y = offy - height / 2
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