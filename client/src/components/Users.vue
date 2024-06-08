<template>
    <div>
        <h1>Your users:</h1>

        <div v-if="error" class="text-error">
            An error occurred when trying to fetch data!

            <div class="mt-10">
                <strong>Reason:</strong>

                <blockquote>
                    {{ error }}
                </blockquote>
            </div>
        </div>

        <div v-else-if="isLoading">
            Loading...
        </div>

        <div v-else-if="!value.length">
            No users available! ( • ᴖ • ｡)
        </div>

        <div v-else class="users">
            <div v-for="({ name, email }, index) in value" :key="index" class="user">
                <div>
                    {{ name }}
                </div>

                <div>
                    {{ email }}
                </div>
            </div>
        </div>

        <div class="mt-10">
            <button :disabled="isLoading" @click="$emit('refetch')">Try again</button>
        </div>
    </div>
</template>

<script>
export default {
    emits: ['refetch'],

    props: {
        value: {
            type: Array,
            required: true
        },

        isLoading: {
            type: Boolean,
            requried: true
        },

        error: {
            type: String,
            required: true
        }
    },
};
</script>
