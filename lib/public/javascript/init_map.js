function initMap() {
  const lat = Number(document.getElementById('map').dataset.lat);
  const lng = Number(document.getElementById('map').dataset.lng);
  const uluru = { lat: lat, lng: lng };
  const map = new google.maps.Map(document.getElementById('map'), {
    zoom: 14,
    center: uluru,
    disableDefaultUI: true,
    gestureHandling: 'none',
  });
}
