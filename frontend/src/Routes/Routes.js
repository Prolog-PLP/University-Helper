import React from 'react';
import { Route, createBrowserRouter, createRoutesFromElements } from 'react-router-dom';
import AppPageLayout from '../layouts/AppPageLayout/AppPageLayout';
import HomePage from '../pages/home';
import RegisterPage from '../pages/register';
import LoginPage from '../pages/login';
import AdminPage from '../pages/admin';
import NoteCreationPage from '../pages/notes/creation';
import ProtectedRoutes from './ProtectedRoutes'
import LogoutPage from '../pages/logout/LogoutPage';
import ListNotesWithEdit from '../pages/notes/list/withEdit';
import ListNotesReadOnly from '../pages/notes/list/readOnly';
import EditNote from '../pages/notes/edition';

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path='/' element={<AppPageLayout />}>
      <Route index element={<HomePage />} />
      <Route path="register" element={<RegisterPage />} />
      <Route path="login" element={<LoginPage />} />
      <Route path="logout" element={<LogoutPage />} />

      <Route element={<ProtectedRoutes allowedRoles={["Administrator"]} />}>
        <Route path="admin" element={<AdminPage />} />
      </Route>

      <Route element={<ProtectedRoutes allowedRoles={["Professor", "Student"]} />}>
        <Route path="note-creation" element={<NoteCreationPage />} />
      </Route>
      <Route element={<ProtectedRoutes allowedRoles={["Administrator", "Professor", "Student"]} />}>
        <Route path="note-list">
          <Route index element={<ListNotesWithEdit />} />
          <Route path='user-warnings' element={<ListNotesReadOnly warningsEnabled={true}/>} />
        </Route>
        <Route path="note-edition" element={<EditNote />} />
        <Route path='public-notes' element={<ListNotesReadOnly warningsEnabled={false} />} />
      </Route>
    </Route>
  )
);

export default router;
