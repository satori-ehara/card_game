$(function() {
  console.log(window.location.search);

  $('.game-main__player--hand-card').on({'click': function() {
      console.log($(this).text());


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
  })
});