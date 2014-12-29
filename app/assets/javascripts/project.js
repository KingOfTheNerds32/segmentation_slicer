  var main = function(){
    $('.table-section').click(function(){
      $(this).nextUntil('.table-section').slideToggle(0);
    });
    $('#expand_collapse').click(function(){
      $('.table-section').each(function(){
        $(this).nextUntil('.table-section').slideToggle(0);
      });
    });
  };

  $(document).ready(main);