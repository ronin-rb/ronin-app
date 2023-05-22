const Tabs = {
  init() {
    (document.querySelectorAll('.tabs') || []).forEach(($tabs) => {
      let $li_tabs = ($tabs.querySelectorAll('.tabs li:has(a)') || []);

      $li_tabs.forEach(($li) => {
        const $a       = $li.querySelector('a');
        const $content = document.getElementById($a.dataset.tabId);

        if ($li.classList.contains('is-active')) {
          $content.style.display = 'block';
        }
        else {
          $content.style.display = 'none';
        }

        $a.addEventListener('click', () => {
          $li_tabs.forEach(($other_li) => {
            $other_li.classList.remove('is-active');
          });

          $li.classList.add('is-active');
          $content.style.display = 'block';

          let $sibling_content = $content.parentNode.firstChild;

          while ($sibling_content) {
            if ($sibling_content.nodeType == 1 && $sibling_content !== $content) {
              $sibling_content.style.display = 'none';
            }

            $sibling_content = $sibling_content.nextSibling;
          }
        });
      });
    });
  }
};

ready(Tabs.init);
