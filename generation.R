library(rmarkdown)

build = function(src) rmarkdown::render(input=sprintf('%s.Rmd', src),output_dir='www', output_format = 'all')

build('index')
build('docs/inform201502')
build('docs/inform201505')
build('docs/inform201508')
build('docs/inform201511')
build('docs/summary')
