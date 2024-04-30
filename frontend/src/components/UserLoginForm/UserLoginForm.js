import React, { useState, useEffect } from 'react';
import { Avatar, Button, CssBaseline, TextField, Link, Grid, Box, Typography, Container } from '@mui/material';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import { createTheme, ThemeProvider } from '@mui/material/styles';
import Alert from '@mui/material/Alert';
import { Form, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { useApi } from '../../hooks/useApi';

const UserLoginForm = () => {
    const [logInfo, setLogInfo] = useState({
        email: '',
        password: '',
    });

    const [alerts, setAlerts] = useState([]);
    const auth = useAuth();
    const api = useApi();
    const navigate = useNavigate();
    const location = useLocation();

    const redirectPath = location.state?.path || '/';

    useEffect(() => {
        if (alerts.length > 0) {
            const timer = setTimeout(() => {
                setAlerts(prevAlerts => prevAlerts.slice(1));
            }, 3000);

            return () => clearTimeout(timer);
        }
    }, [alerts]);

    const showAlert = (severity, message) => {
        setAlerts(prevAlerts => [...prevAlerts, { severity, message }]);
    };

    const handleChange = (e) => {
        setLogInfo({
            ...logInfo,
            [e.target.name]: e.target.value
        });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        handleLogin();
    };

    const handleLogin = async () => {
        try {
            const json = await api.validateLogin(logInfo);
            console.log(json.users[0]);
            if (json.users.length === 1 && logInfo.email !== '' && logInfo.password !== '') {
                auth.login(json.users[0]);
                navigate(redirectPath, { replace: true });
            } else {
                showAlert('error', 'Login e/ou senha inválidos');
            }
        } catch (error) {
            console.log(error);
        }
    }

    const styles = {
        form: {
            width: 'auto',
            height: 'auto',
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            flexDirection: 'column',
            backgroundColor: 'white',
            border: '1px solid rgba(0, 0, 0, 0.1)',
            borderRadius: '8px',
            padding: '20px',
            boxShadow: '0px 4px 8px rgba(0, 0, 0, 0.1)',
        },
        textField: {
            mt: 1,
            mb: 1,
        },
        button: {
            mt: 3,
            mb: 2,
        },
        alertContainer: {
            position: 'fixed',
            bottom: '2%',
            right: '1%',
            zIndex: 9999,
        },
    };

    return (
        <Box>
            <Box sx={styles.form}>
                <ThemeProvider theme={createTheme()}>
                    <Container component="main" maxWidth="xs">
                        <CssBaseline />
                        <Box
                            sx={{
                                display: 'flex',
                                flexDirection: 'column',
                                alignItems: 'center',
                            }}
                        >
                            <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
                                <LockOutlinedIcon />
                            </Avatar>
                            <Typography component="h1" variant="h5">
                                Sign in
                            </Typography>
                            <Form method='post' onSubmit={handleSubmit}>
                                <Box noValidate sx={{ mt: 1 }}>
                                    <TextField
                                        margin="normal"
                                        fullWidth
                                        id="email"
                                        label="Email Address"
                                        name="email"
                                        autoComplete="email"
                                        autoFocus
                                        sx={styles.textField}
                                        value={logInfo.email}
                                        onChange={handleChange}
                                    />
                                    <TextField
                                        margin="normal"
                                        fullWidth
                                        name="password"
                                        label="Password"
                                        type="password"
                                        id="password"
                                        autoComplete="current-password"
                                        sx={styles.textField}
                                        value={logInfo.password}
                                        onChange={handleChange}
                                    />
                                    <Button
                                        type="submit"
                                        fullWidth
                                        variant="contained"
                                        sx={{ ...styles.button, mt: 3, mb: 2 }}
                                    >
                                        Sign In
                                    </Button>
                                    <Grid container justifyContent="flex-end">
                                        <Grid item>
                                            <Link href="/register" variant="body2">
                                                Don't have an account? Sign Up
                                            </Link>
                                        </Grid>
                                    </Grid>
                                </Box>
                            </Form>
                        </Box>
                    </Container>
                </ThemeProvider>
            </Box>
            <Box sx={styles.alertContainer}>
                {alerts.map((alert, index) => (
                    <Alert key={index} severity={alert.severity} sx={{ my: 1 }}>
                        {alert.message}
                    </Alert>
                ))}
            </Box>
        </Box>
    );
};

export default UserLoginForm;
