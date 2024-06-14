import { createRouter, createWebHashHistory } from "vue-router"
import type { RouteRecordRaw } from "vue-router";

const routes: RouteRecordRaw[] = [
    {
        name: "Home",
        component: import("../views/PCVersion/index.vue"),
        path: "/"
    },
    {
        name: "TestAPI",
        component: import("../views/TestAPI.vue"),
        path: "/TestAPI"
    }
];
const route = createRouter({routes, history: createWebHashHistory()});
export default route;