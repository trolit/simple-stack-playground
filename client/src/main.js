import './assets/main.css'

import axios from "axios";
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'

const pinia = createPinia()
const app = createApp(App)

app.use(pinia)
app.use(router)

axios.defaults.baseURL = import.meta.env.VITE_API_URL

app.mount('#app')
