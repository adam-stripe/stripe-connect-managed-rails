var stripe = Stripe('pk_test_PnGDuS8CtF0xPA17inYiarcj');

var elements = stripe.elements();

// Construct the Stripe element:

var card = elements.create('card', {
  iconColor: 'magenta',
  style: {
  	base: {
      fontSize: '16px'
    },
  }
});

// Initialize the Stripe element into the DOM `span` element, with id="card":
card.mount('#card');

var stripeResponseHandler = function(status, response) {
  // Grab the form:
  var form = document.getElementById('payment-form');

  if (response.error) { // Problem!
    // Show the errors on the form:
  } else { // Token was created!
    // Get the token ID:
    var token = response.id;

    // Insert the token ID into the form so it gets submitted to the server:
    var form = document.getElementById('payment-form');
    var hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripeToken');
    hiddenInput.setAttribute('value', token);
    form.appendChild(hiddenInput);

    // Submit the form:
    form.submit();
  }
};

// Create a token when the form is submitted
var form = document.getElementById('payment-form');
form.addEventListener('submit', function(e) {
  e.preventDefault();
  Stripe.card.createToken(form, stripeResponseHandler);
});

function stripeTokenHandler(token) {
  // Insert the token ID into the form so it gets submitted to the server:
  var form = document.getElementById('payment-form');
  var hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  // Submit the form:
  form.submit();
}

function createToken() {
  stripe.createToken(card).then(
    function(token) {
      stripeTokenHandler(token); // send this to your server
    },
    function(error) {
      console.log(error); // display an error
    }
  );
};

// Create a token when the form is submitted.
var form = document.getElementById('payment-form');
form.addEventListener('submit', function(e) {
  e.preventDefault();
  createToken();
});
