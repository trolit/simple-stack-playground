<template>
    <div>
        <h1>User form</h1>

        <p>Name</p>
        <input v-model="formData.name" placeholder="Name" />

        <p class="mt-10">Email</p>
        <input v-model="formData.email" placeholder="Email" />

        <div class="mt-10">
            <button :disabled="isLoading || isEmpty" @click="submit">Submit</button>
        </div>
    </div>
</template>

<script>
import { useUsersStore } from "@/stores/users";

export default {
    data() {
        const usersStore = useUsersStore();

        const defaultFormData = {
            name: '',
            email: ''
        }

        return {
            usersStore,
            defaultFormData,
            formData: { ...defaultFormData },
            isLoading: false,
        };
    },

    computed: {
        isEmpty() {
            return Object.values(this.formData).some((value) => !value)
        }
    },

    methods: {
        async submit() {
            this.isLoading = true;

            try {
                await this.usersStore.create(this.formData)

                this.formData = { ...this.defaultFormData }
            } catch (error) {
                console.error(error);
            } finally {
                this.isLoading = false;
            }
        }
    },
};
</script>
