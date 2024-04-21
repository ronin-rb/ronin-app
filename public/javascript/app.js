class DarkModeToggle {
  constructor() {
    this.button = document.querySelector("#dark-mode-toggle");
    this.sun    = this.button.querySelector("#dark-mode-sun");
    this.moon   = this.button.querySelector("#dark-mode-moon");

    if (this.isEnabled() || this.darkModePreferred()) {
      // set the toggle if dark-mode was previous enabled or is preferred
      this.moon.style.display = "inline";
      this.sun.style.display  = "none";
      document.body.classList.add("dark-mode");
    }

    this.button.addEventListener("click", this.toggle.bind(this));
  }

  isEnabled() { return localStorage.getItem("dark-mode") != null; }

  darkModePreferred() {
    return window.matchMedia("(prefers-color-scheme: dark)").matches;
  }

  disable() {
    this.moon.style.display = "none";
    this.sun.style.display  = "inline";
    document.body.classList.remove("dark-mode");

    localStorage.removeItem("dark-mode");
  }

  enable() {
    this.moon.style.display = "inline";
    this.sun.style.display  = "none";
    document.body.classList.add("dark-mode");

    localStorage.setItem("dark-mode",true);
  }

  toggle(setting) {
    if (this.isEnabled()) { this.disable(); }
    else                  { this.enable();  }
  }
}

const ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {
  const dark_mode_toggle = new DarkModeToggle();

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

  (document.querySelectorAll('.dropdown') || []).forEach(dropdown => {
    dropdown.addEventListener('click', function(event) {
      event.stopPropagation();
      dropdown.classList.toggle('is-active');
    });
  })

  document.addEventListener('click', function (event) {
    (document.querySelectorAll('.dropdown') || []).forEach(dropdown => {
      if (!dropdown.contains(event.target)) {
        dropdown.classList.remove('is-active')
      }
    })
  })
});
