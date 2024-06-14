import {defineConfig} from 'vite'
import vue from '@vitejs/plugin-vue'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import {ElementPlusResolver} from 'unplugin-vue-components/resolvers'
import dotenv from 'dotenv';

// 加载 .env 文件
dotenv.config();

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        vue(),
        AutoImport(
            {
                resolvers: [
                    ElementPlusResolver()
                ],
            }),
        Components(
            {
                resolvers: [
                    ElementPlusResolver()
                ],
            }
        ),
    ],
    server: {
        proxy: {
            '/api': {
                target: 'http://t.weather.sojson.com',
                changeOrigin: true,
                rewrite: (path) => path.replace(/^\/api/, '')
            }
        }
    }
})
