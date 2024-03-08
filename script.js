const form = document.getElementById('keyword_form');
const input = document.getElementById('keyword');
const log = document.getElementById('log');

async function sendData() {
  const formData = new FormData(form);
  var keyword = formData.get('keyword');
  var regex = /^(\w+,)*\w+$/;
  if (!regex.test(keyword)) {
    alert('Invalid input. Please enter comma separated words.');
    return;
  }
  try {
    const response = await fetch(
      'https://rss.rz-nag.de/api/set/keywords',
      {
        method: 'POST',
        body: formData,
      }
    );
    if (response.status === 200) {
      log.innerHTML = 'Keywords updated successfully';
    }
  } catch (e) {
    console.error(e);
  }
}

form.addEventListener('submit', function (e) {
  sendData();
  e.preventDefault();
});

window.onload = function () {
  fetch('https://rss.rz-nag.de/api/get/keywords')
    .then((response) => response.text())
    .then((data) => {
      console.log(data);
      input.value = data.replace('"', '').replace('"', '');
    })
    .catch((e) => console.error(e));
  input.focus();
};
