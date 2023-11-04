const Notes = {
  init() {
    (document.querySelectorAll('.delete-note') || []).forEach(button => {
      button.addEventListener('click', () => {
        const noteId = button.getAttribute('data-note-id');
        Notes.delete(noteId, button)
      });
    });
  },

  delete(noteId, button) {
    fetch(`${document.location}/notes/${noteId}`, {
      method: 'DELETE'
    })
    .then(response => {
      if (response.ok) {
        button.parentElement.parentElement.remove();
      } else {
        console.error('Failed to delete note');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
};

ready(Notes.init);
