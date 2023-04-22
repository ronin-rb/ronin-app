const ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
    const $notification = $delete.parentNode;

    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });

  (document.querySelectorAll('.advanced > a.advanced-toggle') || []).forEach(($toggle) => {
    const $advanced = $toggle.parentNode;

    $advanced.classList.add('hidden');

    $toggle.addEventListener('click', (e) => {
      if ($advanced.classList.contains('hidden'))
      {
        $advanced.classList.remove('hidden');
      }
      else
      {
         $advanced.classList.add('hidden');
      }
    });
  });
});
