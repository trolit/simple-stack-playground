<template>
  <div class="home-view">
    <div class="block">
      <Users :value="users" :error="getAllError" :is-loading="isLoading" @refetch="fetchUsers" />
    </div>

    <div class="block">
      <AddUserForm />
    </div>
  </div>
</template>

<script>
import { useUsersStore } from "@/stores/users";

import Users from "@/components/Users.vue";
import AddUserForm from "@/components/AddUserForm.vue";

export default {
  components: {
    Users,
    AddUserForm
  },

  data() {
    const usersStore = useUsersStore();

    return {
      usersStore,
      getAllError: "",
      isLoading: false,
    };
  },

  computed: {
    users() {
      return this.usersStore.users;
    }
  },

  methods: {
    async fetchUsers() {
      this.getAllError = '';
      this.isLoading = true;

      try {
        await this.usersStore.getAll();
      } catch (error) {
        this.getAllError = error.message;
      } finally {
        this.isLoading = false;
      }
    }
  },

  created() {
    this.fetchUsers();
  }
};
</script>
