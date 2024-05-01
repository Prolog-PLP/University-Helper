import { capitalize } from "../utils/utils";

const apiUsersURL = process.env.REACT_APP_API + "/users"
const getAllUsersRoute = apiUsersURL + "/"
const registerRoute = apiUsersURL + "/add";
// this route has changed
const getValidUsers = apiUsersURL + "/validated_users";
const getUnvalidUsers = apiUsersURL + "/unvalidated_users";
const updateUserRoute = apiUsersURL + "/update";
const getUserFieldRoute = apiUsersURL + "/getAny";
const getUserByFieldRoute = apiUsersURL + "/user";
export default class UserService {

    async validateLogin(logInfoSubmission) {
        const url = `${getAllUsersRoute}?email=${logInfoSubmission.email}&password=${logInfoSubmission.password}`;
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            },
        });

        if (!response.ok) {
            throw new Error('Failed to validate login.');
        }    
        return await response.json();
    }

    // register a user
    async registerUser(user) {
        const response = await fetch(registerRoute, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(user),
        });

        if (response.ok) {
            const responseData = await response.json();
            return responseData;
        } else {
            const errorData = await response.json();
            throw new Error(errorData.message || 'Failed to create the user on our system');
        }
    }

    // get users 
    async getDBUsers() {
        const response = await fetch(getAllUsersRoute, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch users.');
        }

        const responseData = await response.json();
        return responseData.users;
    }

    // already valid users
    async getValidUsers() {
        const response = await fetch(getValidUsers, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch users.');
        }

        return await response.json();
    }

    // users that are waiting to be validated
    async getUnvalidUsers() {
        const response = await fetch(getUnvalidUsers, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch users.');
        }

        return await response.json();
    }
    

    async updateUserField(data) {
        const response = await fetch(`${updateUserRoute}/${data.id}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });
        if (!response.ok) {
            throw new Error('Failed to update user');
        }

        await response.json();
    }

    async getUserField(data) {
        const queryParams = `${data.unique_key_name}=${data.unique_key}`;
        const url = getAllUsersRoute + `?${queryParams}`;

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch user field.');
        }
        const responseData = await response.json();
        const field = data.attribute;
        if (responseData.users && responseData.users.length > 0) {
            return responseData.users[0][field];
        } else {
            throw new Error('No users found.');
        }
    
    }

    async getUserByField(data) {
        const queryParams = `${data.unique_key_name}=${data.unique_key}`;
        const url = getAllUsersRoute + `?${queryParams}`;

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch user field.');
        }

        const responseData = await response.json();
        return responseData.users[0];
    }

}