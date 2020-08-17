$(function() {

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
        case 2:
          $('.message').empty();
          $('.message').text("指定する数値を選択して下さい。");
          select = `
            <p>
            <select name="example1">
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
            <option value="6">6</option>
            <option value="7">7</option>
            <option value="8">8</option>
            <option value="9">9</option>
            <option value="10">10</option>
            </select>
            </p>
          `
          button = '<button class="redirect",type="button">確認</button>'
          $('.message').append(select);
          $('.message').append(button);
          $('.redirect').on('click', function(){
            ajax_send($('option:selected').val(),21)
          });
        break;
        case 3:
          $('.message').empty();
          $('.message').text("手札を確認したらボタンを押してください。");
          $('.game-main__enemy--hand-card#card').text(data.card);
          button = '<button class="redirect",type="button">確認</button>'
          $('.message').append(button);
          $('.redirect').on('click', next_turn);
        break;
        case 5:
          $('.message').empty();
          $('.message').text("破棄させる相手の手札を選択して下さい。");
          $('.game-main__enemy').empty();
          $.each(data.card, function(index, value){
            enemy_hand = `<div class="game-main__enemy--hand-card" id="card" data-hand="${index}">0</div>`
            $('.game-main__enemy').append(enemy_hand);
          })
          $('.game-main__enemy--hand-card').on({'click': function() {
            ajax_send($(this).data('hand'),91)
            }
          })
        break;
        case 9:
          $('.game-main__enemy').empty();
          $.each(data.card, function(index, value){
            enemy_hand = `<div class="game-main__enemy--hand-open" id="card" data-hand="${index}">${value}</div>`
            $('.game-main__enemy').append(enemy_hand);
          })
          $(".game-main__player--hand-card").off("click");
          $('.game-main__enemy--hand-open').on({'click': function() {
            ajax_send($(this).data('hand'),91)
            }
          })
        break;
        default:
          window.location.replace(`/groups/${gon.group_id}/games`);
        break;
      }
    })
  }

  $('.game-main__player--hand-card').on({'click': function(e) {
      if(gon.game.condition != "started"){
        return false;
      }
      if(gon.user_id == gon.action_id){
        if($(this).data('hand') >= 10){
          ajax_send($(this).data('hand')-10,71);
        }else{
          if($(this).text() != 10){
            ajax_send($(this).data('hand'),Number($(this).text()));
          }else{
            $('.message').text("このカードは出すことができません")
          }
        }
      }else{
        $('.message').text("相手のアクションです。")
      }
    }
  })

  var next_turn = function() {
    ajax_send(0,0);
  };
});