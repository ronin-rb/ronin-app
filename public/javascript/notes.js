class Note {
  constructor(noteDiv) {
    this.noteDiv = noteDiv;
    this.id = noteDiv.getAttribute('data-note-id');

    (noteDiv.querySelectorAll('.edit-note') || []).forEach(editNoteButton => {
      editNoteButton.addEventListener('click', () => {
        this.toggleEditForm()
      })
    })

    noteDiv.querySelector('.delete-note').addEventListener('click', () => {
      this.delete()
    })

    noteDiv.querySelector('.update-note').addEventListener('click', () => {
      this.toggleEditForm()
      this.update()
    })
  }

  update() {
    const body = this.noteDiv.querySelector('.note-body')
    const newValue = this.noteDiv.querySelector('.textarea').value

    fetch(`${document.location.origin}/db/notes/${this.id}?` + new URLSearchParams({ body: newValue }), {
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
      console.error('Error: ', error);
    });
  }

  delete() {
    fetch(`${document.location}/notes/${this.id}`, {
      method: 'DELETE'
    })
    .then(response => {
      if (response.ok) {
        this.noteDiv.remove();
      } else {
        console.error('Failed to delete note');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
  }

  toggleEditForm() {
    const editForm = this.noteDiv.querySelector('.note-form')
    const body = this.noteDiv.querySelector('.note-body')

    if (editForm.style.display === 'none') {
      body.style.display = 'none';
      editForm.style.display = 'block';
    } else {
      body.style.display = 'block';
      editForm.style.display = 'none';
    }
  }
}

class Notes {
  constructor() {
    this.notes = [];

    (document.querySelectorAll('.note-div') || []).forEach(noteDiv => {
      this.notes.push(new Note(noteDiv))
    })
  }
};

ready(() => {
  new Notes();
});
