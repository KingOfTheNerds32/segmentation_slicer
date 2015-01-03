var main = function(){
  $('.table-section').click(function(){
    $(this).nextUntil('.table-section').slideToggle(0);
  });
  $('#expand').click(function(){
    $('.table-section').each(function(){
      $(this).nextUntil('.table-section').slideDown(0);
    });
  });
  $('#collapse').click(function(){
    $('.table-section').each(function(){
      $(this).nextUntil('.table-section').slideUp(0);
    });
  });
  $('#filter_clear').click(function(){
    //Either implementation is fine. Keeping both for reference for now
    //$('.filter-control').find('option:first').attr('selected','selected');
    $('.filter-control').each(function(index, element){
      $(this)[0].selectedIndex = 0;
    });
  });
  $(function(){
    $('.table').floatThead({scrollingTop:50});
  });
  $('form').submit(function(){
    $('#update_status').show();
  })
};

var table_updater = function(){
  $(function(){
    $('.table').floatThead({scrollingTop:50});
  });
  $('.table-section').click(function(){
    $(this).nextUntil('.table-section').slideToggle(0);
  });
  $('#update_status').removeClass();

  //Tell User that data is being updated
  var btn = $('#update_status')
  btn.removeClass().addClass('alert alert-success').text('Results updated!').fadeOut(1750, function(){
    btn.removeClass().addClass('alert alert-info').text('Updating results');
  });
};

$(document).ready(main);
$(document).ajaxComplete(table_updater);