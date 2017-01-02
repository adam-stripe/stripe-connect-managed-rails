$(function() {
  $(".campaign-image").click(function(){
    $(".img-thumbnail").removeClass("img-selected");
    $("#campaign_image").val(this.id);
    $(this).children("img").addClass("img-selected");
  });
});