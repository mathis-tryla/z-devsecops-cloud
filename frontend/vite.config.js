import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    port: 3000,
    proxy: {
        '/api': {
            //target: 'http://back:8080',
            target: 'http://localhost:8080',
            //target: 'http://' + import.meta.env.BASE_URL + ':8080',
            ws: true,
            changeOrigin: true
        }
    }
  }
})
