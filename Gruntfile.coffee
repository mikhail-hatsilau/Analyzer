module.exports = (grunt) ->

  grunt.initConfig {
    coffee: {
      compile: {
        files: {
          'app/modules/app.module.js': 'app/modules/app.module.coffee',
          'app/controllers/chart.controller.js': 'app/controllers/chart.controller.coffee',
          'app.js': 'app.coffee',
          'analyzer/analyzer.js': 'analyzer/analyzer.coffee'
        }
      }
    },

    jade: {
      compile: {
        files: {
          'index.html': 'index.jade'
        }
      }
    },

    sass: {
      dist: {
        options: {
          style: 'expanded'
        },
        files: {
          'styles/styles.css': 'styles/styles.sass'
        }
      }
    }
  }

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'

  grunt.registerTask 'build', ['coffee', 'jade', 'sass']
