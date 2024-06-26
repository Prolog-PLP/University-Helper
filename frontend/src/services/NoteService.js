const apiNotesURL = process.env.REACT_APP_API + "/notes"
const getAllNotesRoute = apiNotesURL + "/";
const getNoteIdRoute = apiNotesURL + "/getId"
const removeNoteRoute = apiNotesURL + "/delete"
const registerNoteRoute = apiNotesURL + "/add"
const updateNoteRoute = apiNotesURL + "/update"
const notifyUserRoute = apiNotesURL + "/notifyUser"
const userNotificationsRoute = apiNotesURL + "/userNotifications"

export default class NoteService {

  async getNoteId(prefix) {
    const response = await fetch(getNoteIdRoute + `/${prefix}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const data = await response.json();
    return data.id;
  }

  async removeNote(note) {
    await fetch(removeNoteRoute + `?id=${note.id}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
      },
    })
  }

  async registerNote({ warnedUser, ...note }) {
    await fetch(registerNoteRoute, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(note),
    });
    if (note.type === "Warning") {
      await this.warnUser({ warningID: note.id, warnedUser: warnedUser.id });
    }
  }

  async warnUser(warningNotification) {
    await fetch(notifyUserRoute, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(warningNotification),
    });
  }

  async updateNote({ warnedUser, ...note }) {
    await fetch(updateNoteRoute + `/${note.id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(note),
    });
  }

  async getNotesByCreatorId(userId) {
    const url = `${getAllNotesRoute}?creatorID=${userId}`;
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const responseData = await response.json();
    return responseData.notes;
  }

  async getUserWarnings(userId) {
    const url = userNotificationsRoute + `?warnedUser=${userId}`;
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    });
    const responseData = await response.json();
    return responseData.notes;
  }

  async getNoteWarningById(noteID) {
    const url = userNotificationsRoute + `?warningID=${noteID}`;
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    });
    const responseData = await response.json();
    return responseData;
  }

  async getNotes() {
    const response = await fetch(getAllNotesRoute, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    const responseData = await response.json();
    return responseData.notes;
  }
}