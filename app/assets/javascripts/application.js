// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require spin
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require bootstrap-sprockets
//= require_tree .

var ready;
ready = function() {
	
$('#exampleModal').on('show.bs.modal', function (event) {
  var a = $(event.relatedTarget); // Button that triggered the modal
  var title = a.data('producttitle'); // Extract info from data-* attributes
  var price = (a.data('productprice')/100).toString() + ' €';
  var description = a.data('productdescription');
  var firstcat = a.data('productfirstcat');
  var secondcat = a.data('productsecondcat');
  var productdocument = a.data('productdocument');
  var category = firstcat + '/' + secondcat;
  var productphotourl = a.data('productphotourl');
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var modal = $(this);
  modal.find('.modal-title').text(title);
  modal.find('.modal-body #product-price').val(price);
  modal.find('.modal-body #product-description').val(description);
  modal.find('.modal-body #category').val(category);
  modal.find('.modal-body #productdocument').val(productdocument);
  modal.find('.modal-body #product-photo').attr("src", productphotourl);
})

$('#coModal').on('show.bs.modal', function (e) {
  var button = $(e.relatedTarget); // Button that triggered the modal
  var title = button.data('producttitle'); // Extract info from data-* attributes
  var price = (button.data('productprice')/100).toString() + ' €';
  var description = button.data('productdescription');
  var firstcat = button.data('productfirstcat');
  var secondcat = button.data('productsecondcat');
  var productdocument = button.data('productdocument');
  var category = firstcat + '/' + secondcat;
  var productphotourl = a.data('productphotourl');
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var modal = $(this);
  modal.find('.modal-title').text(title);
  modal.find('.modal-body #product-price').val(price);
  modal.find('.modal-body #product-description').val(description);
  modal.find('.modal-body #category').val(category);
  modal.find('.modal-body #productdocument').val(productdocument);
  modal.find('.modal-body #product-photo').attr("src", productphotourl);
})

};

	$(document).ready(ready);