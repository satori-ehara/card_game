$(function() {
  console.log("test");

  $('.game-main__player--hand-card').on({'click': function() {
      console.log($(this).text());
    }
  });
});