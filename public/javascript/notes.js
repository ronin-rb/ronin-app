const Notes = {
  init() {
    (document.querySelectorAll('.delete-note') || []).forEach(button => {
      button.addEventListener('click', () => {
        const noteId = button.getAttribute('data-note-id');
        Notes.delete(noteId, button)
      });
    });

    (document.querySelectorAll('.edit-note') || []).forEach(button => {
      button.addEventListener('click', () => {
        const noteId = button.getAttribute('data-note-id')
        Notes.toggleEditForm(noteId)
      })
    });

    (document.querySelectorAll('.update-note') || []).forEach(button => {
      button.addEventListener('click', () => {
        const noteId = button.getAttribute('data-note-id')
        Notes.toggleEditForm(noteId)
        Notes.update(noteId)
      })
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
  },

  toggleEditForm(noteId) {
    const editForm = document.getElementById(`note-edit-form-${noteId}`)
    const body = document.getElementById(`note-edit-body-${noteId}`)

    if (editForm.style.display === 'none') {
      body.style.display = 'none';
      editForm.style.display = 'block';
    } else {
      body.style.display = 'block';
      editForm.style.display = 'none';
    }
  },

  update(noteId) {
    const body = document.getElementById(`note-edit-body-${noteId}`)
    const newValue = document.getElementById(`note-edit-textarea-${noteId}`).value

    fetch(`${document.location.origin}/db/notes/${noteId}?` + new URLSearchParams({ body: newValue }), {
      method: 'PUT'
    })
    .then(response => {
      if (response.ok) {
        body.textContent = newValue
      } else {
        console.error('Failed update a note');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }
};

ready(Notes.init);
