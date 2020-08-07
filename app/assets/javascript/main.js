$(function() {

  function ajax_send(){
    console.log("呼び出し成功")
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
        ajax_send();
      }else{
        $('.message').text("相手のアクションです。")
      }
    }
  })
});