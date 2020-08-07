$(function() {
  console.log(gon)

  function ajax_send(card){
    $.ajax({
      url: `/groups/${gon.group_id}/games/${gon.game_id}`,
      type: "PATCH",
      data: {
        hand: card.data('hand'),
        number: Number(card.text())
    },
      dataType: 'json'
    })
    .done(function(){
      window.location.replace(`/groups/${gon.group_id}/games`);
    })
  }

  $('.game-main__player--hand-card').on({'click': function() {
      console.log($(this).text());

      if(gon.user_id == gon.action_id){
          ajax_send($(this));
      }else{
        $('.message').text("相手のアクションです。")
      }
    }
  })
});