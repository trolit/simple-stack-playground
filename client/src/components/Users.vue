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

        <div v-else-if="!value.length">
            No users available! ( • ᴖ • ｡)
        </div>

        <div v-else class="users">
            <div v-for="(user, index) in value" :key="index" class="user">
                <div>
                    {{ user.name }}
                </div>

                <div>
                    {{ user.email }}
                </div>
            </div>
        </div>

        <div class="mt-10">
            <slot name="actions" />
        </div>
    </div>
</template>

<script>
export default {
    props: {
        value: {
            type: Array,
            required: true
        },

        error: {
            type: String,
            required: true
        }
    },
};
</script>
