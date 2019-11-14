$(document).on('turbolinks:load', () => {
  $('.click-to-copy').click(function() {
    $(this).focus().select()
    document.execCommand("copy")
  })

  $('.datatables tr').click(function() {
    $('#popup-wrapper').show()
    let template = $(this).attr('data-template')
    $('#row-data-popup').html($(`#${template}`).html())
  })

  $('#popup-wrapper').click(function() {
    $('#popup-wrapper').hide()
  })

  $('#popup').click(function(e) {
    e.stopPropagation()
    e.preventDefault()
  })
  //
  // $('input#campaign_name').keyup(function(e) {
  //   $('#campaign_slug').val(slug($(this).val()))
  // })
  //
  // var slug = function(str) {
  //   str = str.replace(/^\s+|\s+$/g, ''); // trim
  //   str = str.toLowerCase();
  //
  //   // remove accents, swap ñ for n, etc
  //   var from = "ãàáäâẽèéëêìíïîõòóöôùúüûñç·/_,:;";
  //   var to   = "aaaaaeeeeeiiiiooooouuuunc------";
  //   for (var i=0, l=from.length ; i<l ; i++) {
  //     str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i));
  //   }
  //
  //   str = str.replace(/[^a-z0-9 -]/g, '') // remove invalid chars
  //     .replace(/\s+/g, '-') // collapse whitespace and replace by -
  //     .replace(/-+/g, '-'); // collapse dashes
  //
  //   return str;
  // }

})
