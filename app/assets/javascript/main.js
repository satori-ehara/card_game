$(function() {
  console.log(gon)

  function ajax_send(hand,number){
    $.ajax({
      url: `/groups/${gon.group_id}/games/${gon.game_id}`,
      type: "PATCH",
      data: {
        hand: hand,
        number: number
    },
      dataType: 'json'
    })
    .done(function(data){
      console.log(data);
      switch (data.number){
        case 3:
          $('.message').empty();
          $('.message').text("手札を確認したらボタンを押してください。");
          $('.game-main__enemy--hand-card#card').text(data.card);
          button = '<button class="redirect",type="button">確認</button>'
          $('.message').append(button);
          $('.redirect').on('click', next_turn);
        break;
        default:
          console.log("ここ通りましたよ");
          window.location.replace(`/groups/${gon.group_id}/games`);
        break;
      }
    })
  }

  $('.game-main__player--hand-card').on({'click': function() {
      console.log($(this).text());

      if(gon.user_id == gon.action_id){
        ajax_send($(this).data('hand'),Number($(this).text()));
      }else{
        $('.message').text("相手のアクションです。")
      }
    }
  })

  var next_turn = function() {
    ajax_send(0,0);
  };
});