import axios from 'axios';
import { defineStore } from 'pinia'

export const useUsersStore = defineStore('user', {
    state: () => ({
        users: []
    }),

    getters: {
        USERS: (state) => state.users
    },

    actions: {
        async getAll() {
            const { data } = await axios.get('/users');

            this.users = data;

            return data;
        },

        create({ email, name }) {
            const payload = {
                email,
                name
            }

            return axios.post('/users', payload);
        },
    }
})
