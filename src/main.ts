import { createApp } from 'vue'
import App from './App.vue'
import 'element-plus/es/components/message/style/css'
import 'element-plus/es/components/message-box/style/css'
import "element-plus/es/components/select-v2/style/css"
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import route from './router'
const app = createApp(App);
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
}
app.use(route);
app.mount('#app');
