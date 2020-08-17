$(function(){
  function reload(){
    $.ajax({
      url: `/groups/${gon.group_id}/api/games`,
      type: "GET",
      data: {
        count: gon.game.turn_count
    },
      dataType: 'json'
    })
    .done(function(data){
      if(data.reload == 'true'){
        window.location.replace(`/groups/${gon.group_id}/games`);
      }
    })
    .fail(function(){
    })
  }

  setInterval(reload, 3000);
})