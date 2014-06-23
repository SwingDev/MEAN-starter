exports.config =
    paths:
        public: 'build/public'
        watched: ['development', 'vendor']
    modules:
        definition: false
        wrapper: false
    files:
        javascripts:
            defaultExtension: 'coffee'
            joinTo:
                'scripts/site.js': /^development[\/\\]public[\/\\]scripts/
                'scripts/vendor.js': /^(development[\/\\]public[\/\\]vendor|bower_components)/
            order:
                before: ['development/public/scripts/main.coffee']
        stylesheets:
            defaultExtension: 'scss'
            joinTo:
                'styles/site.css': /^development[\/\\]public[\/\\]styles/
                'styles/vendor.css': /^(development[\/\\]public[\/\\]vendor|bower_components)/
    overrides:
        production:
            paths:
                public: 'release'
            optimize: true
            sourceMap: false
            plugins:
                uglify:
                    mangle: false
                    compress:
                        global_defs:
                            DEBUG: false
                cleancss:
                    keepSpecialComments: 0
                    removeEmpty: true
                autoReload:
                    enabled: false
