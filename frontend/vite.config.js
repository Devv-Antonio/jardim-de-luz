import { defineConfig } from "vite";
export default defineConfig({
  server: { proxy: { "/api": "http://localhost:8000" } },
  preview: { proxy: { "/api": "http://localhost:8000" } },
});
