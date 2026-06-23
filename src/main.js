import { createApp } from "vue";
import AdminPage from "./AdminPage.vue";
import App from "./App.vue";
import "./styles.css";

const isAdminRoute = window.location.pathname === "/admin" || window.location.pathname.startsWith("/admin/");

createApp(isAdminRoute ? AdminPage : App).mount("#app");
