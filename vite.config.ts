import { defineConfig } from 'vite'

// 引入ElementUI 自动导入插件
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    // 引用ElementUI自动导入的插件
    AutoImport({
      resolvers: [ElementPlusResolver()],
    }),
    Components({
      resolvers: [ElementPlusResolver()],
    })
  ],
  server: {
      host: '0.0.0.0',
      port: 443,
      https: {
        key: './ssl/privkey.pem',
        cert: './ssl/fullchain.pem'
      },
      proxy: {
          '/api/mi': {
              target: 'https://weatherapi.market.xiaomi.com/wtr-v3/',
              changeOrigin: true,
              rewrite: (path) => path.replace(/^\/api\/mi/, ''),
          },
      }
  }
})
