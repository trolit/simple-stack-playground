import axios from 'axios';
import { defineStore } from 'pinia'

export const useUsersStore = defineStore('user', {
    state: () => ({
        users: []
    }),

    actions: {
        async getAll() {
            const { data } = await axios.get('/users');

            this.users = data;

            return data;
        },

        async create({ email, name }) {
            const payload = {
                email,
                name
            }

            const { data } = await axios.post('/users', payload);

            this.users.push(data);
        },
    }
})
