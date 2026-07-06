import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      '/BillExists.aspx':    { target: 'http://localhost:60914', changeOrigin: true },
      '/BillAuthorize.aspx': { target: 'http://localhost:60914', changeOrigin: true },
      '/BillFrame.aspx':     { target: 'http://localhost:60914', changeOrigin: true },
      '/BillPdf.aspx':       { target: 'http://localhost:60914', changeOrigin: true },
      '/Images':             { target: 'http://localhost:60914', changeOrigin: true },
    },
  },
})
