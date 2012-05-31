$(document).ready(function(){
    $("#commentForm").validate({
      submitHandler: function(form) {
        $('div.feedback form').hide();
        $('div.feedback div.success').show();
        form.submit();
      },
      errorElement: "p",
    })
  }
);
