const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      backgroundImage: theme => ({
        'bgfixed': "url('/assets/img/bgfixed.jpg')",
      }),
      backgroundPosition: {
        'bgfixed': 'center',
      },
      backgroundSize: {
        'bgfixed': 'cover',
      },
      backgroundAttachment: {
        'bgfixed': 'fixed',
      },
      backgroundRepeat: {
        'bgfixed': 'no-repeat',
      },
      height: {
        'bgfixed': '500px',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
