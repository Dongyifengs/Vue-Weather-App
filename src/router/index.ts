import { createRouter, createWebHashHistory } from "vue-router"
import type { RouteRecordRaw } from "vue-router";

const routes: RouteRecordRaw[] = [
    {
        name: "Home",
        component: import("../views/PCVersion.vue"),
        path: "/"
    }
];
const route = createRouter({routes, history: createWebHashHistory()});
export default route;