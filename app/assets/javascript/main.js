$(function() {
  console.log(gon)

  function ajax_send(){
    $.ajax({
      url: `/groups/${gon.group_id}/games/${gon.game_id}`,
      type: "PATCH",
      data: {
        hand: $(this).data('hand'),
        number: Number($(this).text())
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
        if(gon.game.deck[0].length == 0){
          $('.message').text("デッキ枚数切れ")
        }else{
          ajax_send();
        }
      }else{
        $('.message').text("相手のアクションです。")
      }
    }
  })
});