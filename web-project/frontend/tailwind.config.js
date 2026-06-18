export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        secondary: '#10B981',
        accent: '#F59E0B',
        dark: '#1F2937',
        light: '#F9FAFB',
      },
      gradients: {
        'primary-gradient': 'linear-gradient(135deg, #3B82F6 0%, #2563EB 100%)',
        'success-gradient': 'linear-gradient(135deg, #10B981 0%, #059669 100%)',
      }
    },
  },
  plugins: [],
}
