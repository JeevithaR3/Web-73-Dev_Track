const form = document.getElementById('donation-form');

form.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = document.getElementById('name').value;
    const phone = document.getElementById('phone').value;
    const email = document.getElementById('email').value;
    const paymentOption = document.getElementById('payment-option').value;
    // Add payment gateway integration logic here
    console.log(name, phone, email, paymentOption);
});