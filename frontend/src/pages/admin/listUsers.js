import React from "react";
import { useState, useEffect } from "react";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import { Box, Button, Typography, MenuItem, Select, ListItemIcon, FormControl, IconButton } from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import AdminPanelSettingsOutlinedIcon from "@mui/icons-material/AdminPanelSettingsOutlined";
import LockOpenOutlinedIcon from "@mui/icons-material/LockOpenOutlined";
import SecurityOutlinedIcon from "@mui/icons-material/SecurityOutlined";
import DeleteIcon from "@mui/icons-material/Delete";
import { blue, red } from "@mui/material/colors";
import { useApi } from "../../hooks/useApi.js";

const ListUsers = () => {
  const [rows, setRows] = useState([]);
  const api = useApi();

  useEffect(() => {
    api.getDBUsers().then((dbUsers) => {
      //const activeUsers = dbUsers.filter(user => user.dbIsDeleted !== true);
      console.log(dbUsers.users);
      setValidates(dbUsers.users);
    });
  }, []);

  useEffect(() => {
    console.log(rows);
  }, [rows]);

  const updateUser = async (field, newValue, match, matchValue) => {
    await api.updateUserField({ fieldToUpdate: field, newValue, whereField: match, whereValue: matchValue });
  };

  const setValidates = (activeUsers) => {

    fetch('http://localhost:8000/api/users/validated_users', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(),
    })
      .then(response => response.json())
      .then(data => {
        const userIds = data.users.map(item => item.id);
        const hashSet = new Set(userIds);
        const nRows = activeUsers.map(activeUser => ({
          ...activeUser,
          isValidated: hashSet.has(activeUser.id) || activeUser.id === 1,
        }))
        setRows(nRows);
      })
      .catch(error => {
        console.error('Error updating user:', error);
      });
  };

  const theme = createTheme({
    components: {
      MuiDataGrid: {
        styleOverrides: {
          columnHeader: {
            backgroundColor: blue[800], // Cor de fundo do cabeçalho
            color: '#ffffff', // Cor do texto no cabeçalho
          },
        },
      },
    },
    palette: {
      black: {
        main: "#000000", // Cor primária
      },
      primary: {
        main: "#ffffff", // Cor primária
      },
      secondary: {
        main: blue[100], // Cor secundária
      },
      special: {
        main: blue["300"], // Cor secundária
      },
      error: {
        main: red[600], // Cor de erro
      },
      // Adicione outras cores conforme necessário
    },
  });

  const handleAccessChange = (id, newAccess, email) => {
    // Impede a alteração do nível de acesso se for 'admin'
    const currentAccess = rows.find(row => row.id === id).type;
    if (currentAccess !== "admin") {
      const newRows = rows.map((row) => {
        if (row.id === id) {
          return { ...row, type: newAccess };
        }
        return row;
      });
      updateUser("type", newAccess, "email", email);
      setRows(newRows);
    }
  };

  const handleDeleteRow = (id) => {
    fetch(`http://localhost:8000/api/users/delete?id=${id}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
      },
      mode: 'cors',
    })
      .then(response => response.json())
      .then(result => {
        console.log(result);
        if (result.success) {
          setRows(prevRows => prevRows.filter(row => row.id !== id));
        }
      })
      .catch(error => console.error('Error deleting user:', error));
  };

  const columns = [
    { field: "id", headerName: 'Id', headerAlign: 'center', flex: 0.5 },
    {
      field: "name",
      headerName: 'Nome',
      headerAlign: 'center',
      flex: 1,
    },
    {
      field: "university",
      headerName: 'Universidade',
      type: 'number',
      headerAlign: 'center',
      align: 'left',
      flex: 1,
    },
    { field: "enrollment", headerName: 'Matrícula', headerAlign: 'center', align: 'center', flex: 1 },
    { field: "email", headerName: 'Email', headerAlign: 'center', flex: 1 },
    {
      field: 'delete',
      headerName: 'Deletar',
      headerAlign: 'center',
      flex: 0.5,
      renderCell: (params) => (
        <IconButton onClick={() => handleDeleteRow(params.row.id)}>
          <DeleteIcon color="error" />
        </IconButton>
      ),
    },
    {
      field: 'validate',
      headerName: 'Status',
      headerAlign: 'center',
      align: 'center',
      flex: 1,
      renderCell: (params) => {
        // O ideal é usar o padrão abaixo igual nos outros casos, mas por hora, deixarei mockado
        const isValidated = params.row.isValidated;

        //const isValidated = true;

        if (!isValidated) {
          // Botão vermelho para validar
          return (
            <Button
              onClick={() => {
                fetch('http://localhost:8000/api/users/validateUser', {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: JSON.stringify(params.row.id),
                }
                )
                const nRows = rows.map((row) => {
                  if (row.id === params.row.id)
                    row.isValidated = true;
                  return { ...row }
                })
                setRows(nRows);
                params.row.isValidated = true;
              }
              }
              style={{ color: 'white', backgroundColor: 'red', padding: '3px 10px', borderRadius: '4px' }}
            >
              Validar
            </Button>
          );
        } else {
          // Texto estilizado para indicar que o usuário foi validado
          return (
            <Button
              style={{ color: 'white', backgroundColor: 'green', padding: '3px 10px', borderRadius: '4px' }}
            >
              Validado
            </Button>
          );
        }
      }
    },
    {
      field: 'type',
      headerName: 'Cargo',
      headerAlign: 'center',
      flex: 1,
      renderCell: (params) => (
        <FormControl fullWidth>
          <Select
            value={params.row.type}
            onChange={(event) => handleAccessChange(params.row.id, event.target.value, params.row.email)}
            displayEmpty
            size="small"
            sx={{
              display: 'flex',
              alignItems: 'center',
              backgroundColor: params.row.type === "administrator"
                ? theme.palette.special.main
                : theme.palette.secondary.main,
              color: theme.palette.primary.contrastText,
            }}
          >
            <MenuItem value="administrator" disabled>
              <ListItemIcon>
                <AdminPanelSettingsOutlinedIcon fontSize="small" />
              </ListItemIcon>
              <Typography variant="body2">Admin</Typography>
            </MenuItem>
            <MenuItem value="professor">
              <ListItemIcon>
                <SecurityOutlinedIcon fontSize="small" />
              </ListItemIcon>
              <Typography variant="body2">Professor</Typography>
            </MenuItem>
            <MenuItem value="student">
              <ListItemIcon>
                <LockOpenOutlinedIcon fontSize="small" />
              </ListItemIcon>
              <Typography variant="body2">Aluno</Typography>
            </MenuItem>
          </Select>
        </FormControl>
      ),
    },
  ];

  return (
    <ThemeProvider theme={theme}>
      <Box margin="0 auto" width={"100%"} justifyContent={"center"} alignItems={"center"}>
        <Box
          height="80vh"
          sx={{
            "& .MuiSelect-select": {
              display: 'flex',
              alignItems: 'center',
              pl: 1,
              pr: '24px',
            },
            "& .MuiDataGrid-root": {
              border: "none",
            },
            "& .MuiDataGrid-cell": {
              borderBottom: "none",
            },
            "& .name-column--cell": {
              color: theme.palette.black.main,
              backgroundColor: `${theme.palette.primary.main} !important`,
            },
            "& .MuiDataGrid-columnHeaders": {
              backgroundColor: `${theme.palette.primary.main} !important`,
              borderBottom: "none",
            },
            "& .MuiDataGrid-virtualScroller": {
              backgroundColor: theme.palette.primary.main,
            },
            "& .MuiDataGrid-footerContainer": {
              borderTop: "none",
              backgroundColor: theme.palette.primary.main,
            },
            "& .MuiCheckbox-root": {
              color: `${theme.palette.primary.main} !important`,
            },
          }}
        >
          <DataGrid rows={rows}
            columns={columns}
            getRowId={(row) => row.id}
            autoPageSize />
        </Box>
      </Box>
    </ThemeProvider>
  );
};

export default ListUsers;
