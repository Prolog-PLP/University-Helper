const apiNotesURL = process.env.REACT_APP_API + "/notes"
const getAllNotesRoute = apiNotesURL + "/";
const getNoteIdRoute = apiNotesURL + "/getId"
const removeNoteRoute = apiNotesURL + "/removeNote"
const registerNoteRoute = apiNotesURL + "/add"
const updateNoteRoute = apiNotesURL + "/updateANote"
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
    return data;
  }

  async removeNote(note) {
    await fetch(removeNoteRoute, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(note),
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
    console.log(warnedUser, note);
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
    await fetch(updateNoteRoute, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(note),
    });
    if (note.noteType === 'Warning') {
      await this.warnUser({ warningID: note.noteId, warnedUser: warnedUser.dbUserId });
    }
  }

  async getNotesByCreatorId(userId) {
    const url = `${getAllNotesRoute}?creatorID=${userId}`;
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    return await response.json();
  }

  async getUserWarnings(userId) {
    const queryParams = new URLSearchParams({ dbUserId: userId }).toString();
    const url = userNotificationsRoute + `?${queryParams}`;
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      }
    });
    return await response.json();
  }

}