$(document).ready(function () {
    $('.clickable-row').click(function () {
        var id = parseInt($(this).attr("serverID"));
        $.ajax({
            url: '@Url.Action("Game", "Servers")',
            type: 'GET',
            data: { serverID: id }
        });
    })
})