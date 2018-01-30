$(document).ready(function () {

    // Apply line color to each column
    $('.dash-columns-eight').each(function (i) {
        var cl = "";
        switch (i) {
            case 0:
                cl = 'dash-col-lblue';
                break;
            case 1:
                cl = 'dash-col-lorange';
                break;
            case 2:
                cl = 'dash-col-lred';
                break;
            case 3:
                cl = 'dash-col-lgreen';
                break;
            case 4:
                cl = 'dash-col-lgold';
                break;
            case 5:
                cl = 'dash-col-lpurple';
                break;
            case 6:
                cl = 'dash-col-orange';
                break;
            case 7:
                cl = 'dash-col-tan';
                break;
            case 8:
                cl = 'dash-col-green';
                break;
            case 9:
                cl = 'dash-col-brown';
                break;
            case 10:
                cl = 'dash-col-dpink';
                break;
            case 11:
                cl = 'dash-col-dark';
                break;
            case 12:
                cl = 'dash-col-gray';
                break;
            default:
                cl = 'dash-col-lblue';
        };

        $(this).addClass(cl);
    });
});


$(document).ready(function () {

    Highcharts.chart('last-session', {

        chart: {
            backgroundColor: null
        },

        title: {
            text: 'Last Session'
        },

        yAxis: {
            title: {
                text: 'Count'
            },
            allowDecimals: false
        },

        xAxis: {
            title: {
                text: 'Time (HH:MM:SS)'
            },
            type: 'datetime',

            dateTimeLabelFormats: {
                day: null,
                week: null,
                month: null,
                year: null,
                hour: '%H:%M',
                minute: '%H:%M:%S'
            }
        },

        tooltip: {
            dateTimeLabelFormats: {
                hour: '%H:%M',
                minute: '%H:%M:%S'
            },
            formatter: function () {
                return this.y + '<br/>' + Highcharts.dateFormat('%H:%M:%S', this.x);
            }
        },

        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle'
        },

        plotOptions: {
            series: {
                label: {
                    connectorAllowed: false
                },
                pointStart: 0,
                dataLabels: {
                    enabled: false,
                    formatter: function () {
                        return Highcharts.dateFormat('%H:%M:%S', this.x);
                    }
                },
            }
        },

        series: model.LastSessionSeries,

        responsive: {
            rules: [{
                condition: {
                    maxWidth: 500
                },
                chartOptions: {
                    legend: {
                        layout: 'horizontal',
                        align: 'center',
                        verticalAlign: 'bottom'
                    }
                }
            }]
        },

        exporting: { enabled: false },
        credits: {
            enabled: false
        },

    });





    Highcharts.chart('last-5-sessions', {
        chart: {
            type: 'bar',
            backgroundColor: null
        },
        title: {
            text: 'Last 5 Sessions'
        },
        xAxis: {
            categories: ['5', '4', '3', '2', '1'],
            title: {
                text: null
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Activity',
                align: 'high'
            },
            labels: {
                overflow: 'justify'
            },
            allowDecimals: false
        },
        plotOptions: {
            bar: {
                dataLabels: {
                    enabled: true
                }
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: -40,
            y: 80,
            floating: true,
            borderWidth: 1,
            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
            shadow: true
        },
        credits: {
            enabled: false
        },
        exporting: { enabled: false },
        series: model.LastXSessionsEventsSeries
    });






    Highcharts.chart('airframe-chart', {
        chart: {
            margin: [0, 0, 30, 0],
            spacingTop: 0,
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0,
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie',
            backgroundColor: null
        },
        title: {
            text: 'Top 5 Airframes',
            style: {
                fontSize: '18px'
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                size: '75%',
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false
                },
                showInLegend: true,
                borderWidth: 0
            }
        },
        exporting: { enabled: false },
        credits: {
            enabled: false
        },
        series: [{
            name: 'Airframe',
            colorByPoint: true,
            data: model.TopAirframesSeries
        }]
    });






    Highcharts.chart('score-chart', {
        chart: {
            margin: [0, 0, 30, 0],
            spacingTop: 0,
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0,
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie',
            backgroundColor: null
        },
        title: {
            text: 'Score',
            style: {
                fontSize: '18px'
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                size: '75%',
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false
                },
                showInLegend: true,
                borderWidth: 0
            }
        },
        exporting: { enabled: false },
        credits: {
            enabled: false
        },
        series: [{
            name: 'Score',
            colorByPoint: true,
            data: [{
                name: 'Kills',
                y: model.Kills
            }, {
                name: 'Depot Resupplies',
                y: model.DepotResupplies
            }, {
                name: 'Transport',
                y: model.TransportDismounts
            }, {
                name: 'Slingload',
                y: model.SlingLoadUnhooks
            }]
        }]
    });






    Highcharts.chart('sortie-success', {

        chart: {
            margin: [0, 0, 50, 0],
            type: 'solidgauge',
            height: 190,
            backgroundColor: 'rgba(0,0,0,0)',
            spacingTop: 0,
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0,
            backgroundColor: null
        },

        title: {
            text: 'Sortie',
            style: {
                fontSize: '1.8em'
            },
            margin: 1,
            y: 165
        },

        tooltip: {
            borderWidth: 0,
            backgroundColor: 'none',
            shadow: false,
            style: {
                fontSize: '0.8em'
            },
            pointFormat: '{series.name}<br><span style="font-size:1.7em; color: {point.color}; font-weight: bold">{point.y}%</span>',
            positioner: function (labelWidth) {
                return {
                    x: (this.chart.chartWidth - labelWidth) / 2,
                    y: (this.chart.plotHeight / 2) - 25
                };
            },
            enabled: true
        },

        pane: {
            startAngle: 0,
            endAngle: 360,
            size: 130,
            background: {
                outerRadius: '87%',
                innerRadius: '63%',
                backgroundColor: Highcharts.Color(Highcharts.getOptions().colors[1])
                    .setOpacity(0.3)
                    .get(),
                borderWidth: 0
            }
        },

        yAxis: {
            min: 0,
            max: 100,
            lineWidth: 0,
            tickPositions: []
        },

        plotOptions: {
            solidgauge: {
                borderWidth: '16px',
                dataLabels: {
                    enabled: false
                },
                linecap: 'square',
                stickyTracking: false,
                rounded: true
            }
        },

        exporting: { enabled: false },

        credits: {
            enabled: false
        },

        series: [{
            name: 'Success',
            borderColor: Highcharts.getOptions().colors[1],
            data: [{
                color: Highcharts.getOptions().colors[1],
                radius: '75%',
                innerRadius: '75%',
                y: model.SortieSuccessRatio
            }]
        }],
    });

    var chart = $('#sortie-success').highcharts(),
        point = chart.series[0].points[0];
    point.onMouseOver(); // Show the hover marker
    chart.tooltip.refresh(point); // Show the tooltip
    chart.tooltip.hide = function () { console.log() };






    Highcharts.chart('sling-success', {

        chart: {
            margin: [0, 0, 50, 0],
            type: 'solidgauge',
            height: 190,
            backgroundColor: 'rgba(0,0,0,0)',
            spacingTop: 0,
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0,
            backgroundColor: null
        },

        title: {
            text: 'Slingload',
            style: {
                fontSize: '1.8em'
            },
            margin: 1,
            y: 165
        },

        tooltip: {
            borderWidth: 0,
            backgroundColor: 'none',
            shadow: false,
            style: {
                fontSize: '0.8em'
            },
            pointFormat: '{series.name}<br><span style="font-size:1.7em; color: {point.color}; font-weight: bold">{point.y}%</span>',
            positioner: function (labelWidth) {
                return {
                    x: (this.chart.chartWidth - labelWidth) / 2,
                    y: (this.chart.plotHeight / 2) - 25
                };
            },
            enabled: true
        },

        pane: {
            startAngle: 0,
            endAngle: 360,
            size: 130,
            background: {
                outerRadius: '87%',
                innerRadius: '63%',
                backgroundColor: Highcharts.Color(Highcharts.getOptions().colors[1])
                    .setOpacity(0.3)
                    .get(),
                borderWidth: 0
            }
        },

        yAxis: {
            min: 0,
            max: 100,
            lineWidth: 0,
            tickPositions: []
        },

        plotOptions: {
            solidgauge: {
                borderWidth: '16px',
                dataLabels: {
                    enabled: false
                },
                linecap: 'square',
                stickyTracking: false,
                rounded: true
            }
        },

        exporting: { enabled: false },

        credits: {
            enabled: false
        },

        series: [{
            name: 'Success',
            borderColor: Highcharts.getOptions().colors[1],
            data: [{
                color: Highcharts.getOptions().colors[1],
                radius: '75%',
                innerRadius: '75%',
                y: model.SlingLoadSuccessRatio
            }]
        }]
    });

    var chart = $('#sling-success').highcharts(),
        point = chart.series[0].points[0];
    point.onMouseOver(); // Show the hover marker
    chart.tooltip.refresh(point); // Show the tooltip
    chart.tooltip.hide = function () { console.log() };


    Highcharts.chart('transport-success', {

        chart: {
            margin: [0, 0, 50, 0],
            type: 'solidgauge',
            height: 190,
            backgroundColor: 'rgba(0,0,0,0)',
            spacingTop: 0,
            spacingBottom: 0,
            spacingLeft: 0,
            spacingRight: 0,
            backgroundColor: null
        },

        title: {
            text: 'Transport',
            style: {
                fontSize: '1.8em'
            },
            margin: 1,
            y: 165
        },

        tooltip: {
            borderWidth: 0,
            backgroundColor: 'none',
            shadow: false,
            style: {
                fontSize: '0.8em'
            },
            pointFormat: '{series.name}<br><span style="font-size:1.7em; color: {point.color}; font-weight: bold">{point.y}%</span>',
            positioner: function (labelWidth) {
                return {
                    x: (this.chart.chartWidth - labelWidth) / 2,
                    y: (this.chart.plotHeight / 2) - 25
                };
            },
            enabled: true
        },

        pane: {
            startAngle: 0,
            endAngle: 360,
            size: 130,
            background: {
                outerRadius: '87%',
                innerRadius: '63%',
                backgroundColor: Highcharts.Color(Highcharts.getOptions().colors[1])
                    .setOpacity(0.3)
                    .get(),
                borderWidth: 0
            }
        },

        yAxis: {
            min: 0,
            max: 100,
            lineWidth: 0,
            tickPositions: []
        },

        plotOptions: {
            solidgauge: {
                borderWidth: '16px',
                dataLabels: {
                    enabled: false
                },
                linecap: 'square',
                stickyTracking: false,
                rounded: true
            }
        },

        exporting: { enabled: false },

        credits: {
            enabled: false
        },

        series: [{
            name: 'Success',
            borderColor: Highcharts.getOptions().colors[1],
            data: [{
                color: Highcharts.getOptions().colors[1],
                radius: '75%',
                innerRadius: '75%',
                y: model.TransportSuccessRatio
            }]
        }]
    });

    var chart = $('#transport-success').highcharts(),
        point = chart.series[0].points[0];
    point.onMouseOver(); // Show the hover marker
    chart.tooltip.refresh(point); // Show the tooltip
    chart.tooltip.hide = function () { console.log() };
});