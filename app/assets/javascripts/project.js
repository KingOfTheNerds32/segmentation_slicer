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
    $('.table').floatThead();
  });
};

var table_updater = function(){
  $(function(){
    $('.table').floatThead();
  });
  $('.table-section').click(function(){
    $(this).nextUntil('.table-section').slideToggle(0);
  });
};

$(document).ready(main);
$(document).ajaxComplete(table_updater);