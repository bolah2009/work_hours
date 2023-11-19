const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './node_modules/preline/dist/**/*.js',
  ],
    // enable dark mode via class strategy
    darkMode: 'class',
  safelist: [
    {
      pattern:
        /(bg-(red|yellow|green|indigo)-200)|(text-(red|yellow|green|indigo)-900)/,
    },
  ],
  theme: {
    extend: {
      colors: {
        authLink: '#677adc',
        authBlue: '#4285F4',
        authLightGray: '#E8E8E8',
        authMidGray: '#AEAEAE',
        authDarkGray: '#313131',
        authLightestGray: '#F3F3F3',
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require('preline/plugin'),
  ]
}
