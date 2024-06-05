<template>
  <header>
    <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" />

    <span>simple client</span>
  </header>

  <main>
    <RouterView />
  </main>
</template>

<script>
import { RouterView } from 'vue-router'

export default {
  components: {
    RouterView,
  },
};
</script>
