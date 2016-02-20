
get_detail = ->
  console.log($('#repo_title').val());
  $.ajax url: '/repos/find_content?url=' + $('#repo_url').val()
  return false
$(document).ready ->
  $('.find_detail').click ->
    get_detail()
  $('.go-top').click ->
    $('html, body').animate { scrollTop: 0 }, 'slow'
    return
  if $(window).scrollTop() < 45
    $('.go-top').hide()
  $(window).scroll ->
    if $(this).scrollTop() < 45
      $('.go-top').hide()
    else
      $('.go-top').show()
    return
  return