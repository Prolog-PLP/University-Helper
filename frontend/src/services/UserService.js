import { capitalize } from "../utils/utils";

const apiUsersURL = process.env.REACT_APP_API + "/users"
const getAllUsersRoute = apiUsersURL + "/"
const registerRoute = apiUsersURL + "/add";
// this route has changed
const dbUsersRoute = apiUsersURL + "/";
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
        const response = await fetch(dbUsersRoute, {
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
        console.log(data);
        if (!response.ok) {
            throw new Error('Failed to update user');
        }

        await response.json();
    }

    async getUserField(data) {
        const queryParams = new URLSearchParams(data).toString();
        const url = getUserFieldRoute + `?${queryParams}`;

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch user field.');
        }

        return await response.json();
    }

    async getUserByField(data) {
        const queryParams = new URLSearchParams(data).toString();
        const url = getUserByFieldRoute + `?${queryParams}`;
        console.log(url);

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok) {
            throw new Error('Failed to fetch user field.');
        }

        return await response.json();
    }

}