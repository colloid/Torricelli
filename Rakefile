task :default => [ :rebuild, :test ]

task :rebuild do
    sh "make", "-C", "lib/cinderella", "clean"
    sh "make", "-C", "lib/cinderella"
end

task :test do
    tests = FileList["test/*.rb"]
    tests.each do |test|
        ruby "-I", "lib", test
    end
end

task :clean do
    sh "make", "-C", "lib/cinderella", "clean"
end
