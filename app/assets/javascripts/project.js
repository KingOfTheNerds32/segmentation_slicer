var main = function() {
  $('.table-section').click(function() {
    $(this).nextUntil('.table-section').slideToggle(0);
  });
  $('#expand').click(function() {
    $('.table-section').each(function() {
      $(this).nextUntil('.table-section').slideDown(0);
    });
  });
  $('#collapse').click(function() {
    $('.table-section').each(function() {
      $(this).nextUntil('.table-section').slideUp(0);
    });
  });
  $('#filter_clear').click(function() {
    //Either implementation is fine. Keeping both for reference for now
    //$('.filter-control').find('option:first').attr('selected','selected');
    $('.filter-control').each(function(index, element) {
      $(this)[0].selectedIndex = 0;
    });
  });
  $('form').submit(function() {
    $('#update_status').show();
  })
  table_formatter();
};

var table_updater = function() {
  $('.table-section').click(function() {
    $(this).nextUntil('.table-section').slideToggle(0);
  });
  $('#update_status').removeClass();

  //Tell User that data is being updated
  var btn = $('#update_status')
  btn.removeClass().addClass('alert alert-success').text('Results updated!').fadeOut(1750, function() {
    btn.removeClass().addClass('alert alert-info').text('Updating results');
  });
  table_formatter();
};

var table_formatter = function() {
  $('.table .data-row').each(function() {
    maxVal = 0
    minVal = 100
    rangeVal = parseInt($('.range', this).html());
    if (rangeVal > 19.5) {
      $('.range', this).addClass("range-fill");
      $(this).addClass("high-range");
    }

    if ($(this).hasClass("high-range")) {
      $('.result-cell', this).each(function() {
        numVal = parseInt(this.innerText)
        if (numVal > maxVal) {
          maxVal = numVal
        }
        if (numVal < minVal) {
          minVal = numVal
        }
      });
      // console.log(maxVal, minVal)

      $('.result-cell', this).each(function() {
        // $(this).addClass("range-fill")
        if (this.innerText.indexOf('*') < 0) {

          numVal = parseInt(this.innerText)

          diffFromMin = numVal - minVal
          diffFromMax = maxVal - numVal
          if (diffFromMin <= 4.5) {
            $(this).addClass("low-result");
          };
          if (diffFromMax <= 4.5) {
            $(this).addClass("high-result")
          }
        }
      });
    };
  });
};

$(document).ready(main);
$(document).ajaxComplete(table_updater);